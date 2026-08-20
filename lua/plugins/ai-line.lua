local state = {
	agent = nil, -- { target = <pane_id>, label = <display string> }
}

local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "herdr" })
end

--- Run `herdr <args...>` and decode its JSON response.
---@param args string[]
---@param on_done fun(result: table?, err: string?)
local function herdr_cmd(args, on_done)
	local cmd = vim.list_extend({ "herdr" }, args)
	local ok, err = pcall(vim.system, cmd, { text = true }, function(result)
		vim.schedule(function()
			if result.code ~= 0 then
				local decode_ok, decoded = pcall(vim.json.decode, result.stderr or "")
				local message = decode_ok and decoded.error and decoded.error.message
				if not message then
					local stderr = vim.trim(result.stderr or "")
					message = stderr ~= "" and stderr or ("herdr exited with code " .. result.code)
				end
				on_done(nil, message)
				return
			end

			local decode_ok, decoded = pcall(vim.json.decode, result.stdout)
			if not decode_ok then
				on_done(nil, "failed to parse herdr output")
				return
			end
			on_done(decoded, nil)
		end)
	end)
	if not ok then
		on_done(nil, "failed to run herdr: " .. tostring(err))
	end
end

---@param agent table
local function agent_label(agent)
	local name = agent.name or agent.agent or agent.display_agent or "agent"
	local label = string.format("[%s] %s", agent.agent_status or "unknown", name)
	local extra = agent.terminal_title_stripped or agent.title
	if extra and extra ~= "" then
		label = label .. " — " .. extra
	end
	return label .. "  (" .. agent.pane_id .. ")"
end

local function select_agent()
	herdr_cmd({ "agent", "list" }, function(result, err)
		if err then
			notify("agent list failed: " .. err, vim.log.levels.ERROR)
			return
		end

		local agents = result.result and result.result.agents or {}
		if #agents == 0 then
			notify("no active herdr agents", vim.log.levels.WARN)
			return
		end

		vim.ui.select(agents, {
			prompt = "Select herdr agent",
			format_item = agent_label,
		}, function(choice)
			if not choice then
				return
			end
			state.agent = { target = choice.pane_id, label = agent_label(choice) }
			notify("selected agent: " .. state.agent.label)
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

local function send_selection()
	local start_line, end_line = visual_line_range()

	if not state.agent then
		notify("no herdr agent selected — press <leader>ai first", vim.log.levels.WARN)
		return
	end

	local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")

	Snacks.input({
		prompt = string.format("Comment for %s:%d-%d", filename, start_line, end_line),
	}, function(comment)
		if not comment or vim.trim(comment) == "" then
			return
		end

		local text =
			string.format("File: %s\nLines: %d-%d\nComment: %s", filename, start_line, end_line, vim.trim(comment))

		herdr_cmd({ "agent", "prompt", state.agent.target, text }, function(_, err)
			if err then
				notify("agent prompt failed: " .. err, vim.log.levels.ERROR)
				return
			end
			notify("sent to " .. state.agent.label)
		end)
	end)
end

return {
	"folke/snacks.nvim",
	keys = {
		{ "<leader>ai", select_agent, desc = "Herdr: pick target agent" },
		{ "<leader>as", send_selection, mode = "v", desc = "Herdr: send selection with comment to agent" },
	},
}
