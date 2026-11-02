local state = {
	agent = nil, -- { label = <display string>, send = fun(text, on_done) }
}

local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "ai-line" })
end

--- Run a command and hand back trimmed stdout, or an error message.
---@param cmd string[]
---@param on_done fun(stdout: string?, err: string?)
local function run(cmd, on_done)
	local ok, err = pcall(vim.system, cmd, { text = true }, function(result)
		vim.schedule(function()
			if result.code ~= 0 then
				local stderr = vim.trim(result.stderr or "")
				on_done(nil, stderr ~= "" and stderr or (cmd[1] .. " exited with code " .. result.code))
				return
			end
			on_done(result.stdout or "", nil)
		end)
	end)
	if not ok then
		on_done(nil, "failed to run " .. cmd[1] .. ": " .. tostring(err))
	end
end

--- Run a command and decode its JSON stdout.
---@param cmd string[]
---@param on_done fun(result: table?, err: string?)
local function run_json(cmd, on_done)
	run(cmd, function(stdout, err)
		if err then
			on_done(nil, err)
			return
		end
		local decode_ok, decoded = pcall(vim.json.decode, stdout)
		if not decode_ok then
			on_done(nil, "failed to parse " .. cmd[1] .. " output")
			return
		end
		on_done(decoded, nil)
	end)
end

-- Claude Code sessions running in Ghostty ------------------------------------

local claude = {}

-- Prints one "id<TAB>cwd<TAB>title" line per Ghostty terminal surface.
-- (`tab` would resolve to Ghostty's tab class inside the tell block, hence `character id 9`.)
local GHOSTTY_LIST = [[
set sep to character id 9
tell application "Ghostty"
	set out to ""
	repeat with t in terminals
		set out to out & (id of t) & sep & (working directory of t) & sep & (name of t) & linefeed
	end repeat
	return out
end tell]]

-- Pastes argv[2] into terminal argv[1], then presses enter.
local GHOSTTY_SEND = [[
on run argv
	tell application "Ghostty"
		set t to terminal id (item 1 of argv)
		input text (item 2 of argv) to t
		delay 0.1
		send key "enter" to t
	end tell
end run]]

--- Claude Code prefixes its terminal title with a status glyph (✳ idle, ◐◓◑◒ or braille spinner while busy).
---@param title string
local function has_claude_glyph(title)
	local nr = vim.fn.char2nr(title)
	return nr == 0x2733 or (nr >= 0x25D0 and nr <= 0x25D3) or (nr >= 0x2800 and nr <= 0x28FF)
end

---@param on_done fun(terminals: table[])
local function ghostty_terminals(on_done)
	run({ "osascript", "-e", GHOSTTY_LIST }, function(stdout, err)
		if err then
			notify("could not list Ghostty terminals: " .. err, vim.log.levels.WARN)
			return on_done({})
		end
		local terminals = {}
		for line in stdout:gmatch("[^\n]+") do
			local id, cwd, title = line:match("^([^\t]*)\t([^\t]*)\t(.*)$")
			if id then
				table.insert(terminals, { id = id, cwd = cwd, title = title })
			end
		end
		on_done(terminals)
	end)
end

--- The Ghostty terminals a session could live in: same cwd, preferring ones with Claude's title glyph.
local function candidate_terminals(session, terminals)
	local same_cwd, with_glyph = {}, {}
	for _, term in ipairs(terminals) do
		if term.cwd == session.cwd then
			table.insert(same_cwd, term)
			if has_claude_glyph(term.title) then
				table.insert(with_glyph, term)
			end
		end
	end
	return #with_glyph > 0 and with_glyph or same_cwd
end

---@param on_done fun(targets: table[])
function claude.list(on_done)
	if vim.fn.executable("claude") == 0 then
		return on_done({})
	end
	run_json({ "claude", "agents", "--json" }, function(sessions, err)
		if err then
			notify("claude agents failed: " .. err, vim.log.levels.WARN)
			return on_done({})
		end
		if #sessions == 0 then
			return on_done({})
		end
		ghostty_terminals(function(terminals)
			local targets = {}
			for _, session in ipairs(sessions) do
				local cwd = vim.fn.fnamemodify(session.cwd, ":~")
				for _, term in ipairs(candidate_terminals(session, terminals)) do
					table.insert(targets, {
						label = string.format(
							"claude [%s] %s — %s  (%s)",
							session.status,
							session.name,
							term.title,
							cwd
						),
						send = function(text, cb)
							run({ "osascript", "-e", GHOSTTY_SEND, term.id, text }, function(_, send_err)
								cb(send_err)
							end)
						end,
					})
				end
			end
			on_done(targets)
		end)
	end)
end

-- picker / send --------------------------------------------------------------

---@param on_selected? fun() called once an agent has been picked
local function select_agent(on_selected)
	claude.list(function(targets)
		if #targets == 0 then
			notify("no active Claude sessions found in Ghostty", vim.log.levels.WARN)
			return
		end
		vim.ui.select(targets, {
			prompt = "Select agent",
			format_item = function(target)
				return target.label
			end,
		}, function(choice)
			if choice then
				state.agent = choice
				notify("selected agent: " .. choice.label)
				if on_selected then
					on_selected()
				end
			end
		end)
	end)
end

--- Grab the just-exited visual selection's line range and leave visual mode.
local function visual_line_range()
	local start_line, end_line = vim.fn.line("v"), vim.fn.line(".")
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end
	vim.cmd("normal! \27") -- <Esc>, so the input popup doesn't open mid-selection
	return start_line, end_line
end

---@param filename string
---@param start_line integer
---@param end_line integer
local function prompt_and_send(filename, start_line, end_line)
	Snacks.input({
		prompt = string.format("Comment for %s:%d-%d", filename, start_line, end_line),
	}, function(comment)
		if not comment or vim.trim(comment) == "" then
			return
		end

		local text =
			string.format("File: %s\nLines: %d-%d\nComment: %s", filename, start_line, end_line, vim.trim(comment))

		state.agent.send(text, function(err)
			if err then
				notify("send failed: " .. err, vim.log.levels.ERROR)
				return
			end
			notify("sent to " .. state.agent.label)
		end)
	end)
end

local function send_selection()
	local start_line, end_line = visual_line_range()
	local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")

	local function send()
		prompt_and_send(filename, start_line, end_line)
	end

	if state.agent then
		send()
	else
		select_agent(send)
	end
end

return {
	"folke/snacks.nvim",
	keys = {
		{ "<leader>ai", select_agent, desc = "AI: pick target agent" },
		{ "<leader>as", send_selection, mode = "v", desc = "AI: send selection with comment to agent" },
	},
}
