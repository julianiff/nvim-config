#!/bin/bash

pnpm add -g @vtsls/language-server
pnpm add -g vscode-langservers-extracted
pnpm add -g typescript-language-server typescript
pnpm add -g pyright
pnpm add -g @fsouza/prettierd
pnpm add -g prettier

# Go tools
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest

# Lua language server
brew install lua-language-server

# Stylua
brew install stylua

# Python
pip install --user black

# PHP
composer global require friendsofphp/php-cs-fixer

# Phpactor
mkdir -p ~/.local/share/phpactor
git clone https://github.com/phpactor/phpactor.git ~/.local/share/phpactor
cd ~/.local/share/phpactor && composer install --no-dev -o
ln -sf ~/.local/share/phpactor/bin/phpactor ~/.local/bin/phpactor

echo "Done. Add ~/.local/bin to PATH if needed"
