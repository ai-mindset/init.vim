# init.vim
A comprehensive Neovim configuration that turns Neovim into a full-featured IDE for Data Science, AI Engineering, and Backend development. Supports Python, Go, Clojure, JavaScript/TypeScript (via Deno), shell scripting, containerisation, and technical documentation.

## Development Environments
- GitHub Copilot AI assistance
- Ollama local AI assistance 

### Python (Data Science/AI)
- Full LSP support via Pyright
- Automatic linting and formatting with Ruff
- REPL integration through Conjure

### Go (Backend/Data Science/AI)
- Full LSP support via `gopls`
- Excellent documentation on hover
- Automatic formatting with `go fmt`
- `go vet` catches errors before compilation
- Quickly execute current file with `:GoRun`

### Clojure (Backend/Data Processing)
- Complete Clojure LSP integration
- REPL-driven development with Conjure
- Structural editing via `vim-sexp`
- Automatic formatting with `cljfmt`
- Linting with `clj-kondo`

### Deno (TypeScript/JavaScript)
- Advanced LSP features for modern JavaScript/TypeScript
- Built-in linting and formatting

### Container & Infrastructure
- Containerfile/Dockerfile LSP support
- Shell script (Bash/Zsh) language server

### Documentation
- Markdown LSP with preview via [glow](https://github.com/charmbracelet/glow) 
- Spell checking 
- Text-to-speech support via Piper

## Key Bindings
- `<leader>` = `<space>`
- `<localleader>` = `,`

### Development
- LSP hover: `K`
- Definition: `gd`
- References: `gr`
- Code actions: `<leader>ca`

### Navigation
- Find keymappings: `<leader>k`

### REPL
- Connect: `<localleader>cc`
- Evaluate: `<localleader>ee`
- Documentation: `<localleader>hd`

## Requirements
- [Neovim](https://neovim.io/)
- [git](https://git-scm.com/)
- [node.js](https://nodejs.org/) (for copilot.vim)
- [ollama](https://ollama.com/) (for [ollama.nvim](https://github.com/nomnivore/ollama.nvim))
- [ripgrep](https://github.com/BurntSushi/ripgrep) for global line completions through fzf.vim (optional)
- [glow](https://github.com/charmbracelet/glow) for Markdown preview (optional)
- [Deno](https://ai-mindset.github.io/deno/) (for TypeScript/JavaScript)
- [Python](https://ai-mindset.github.io/bring-it-back-to-basics/) 
- [Clojure](https://github.com/ai-mindset/clj-installer)
- [PiperTTS](https://github.com/rhasspy/piper) (for text-to-speech)
- Alba voice [model](https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/alba/medium/en_GB-alba-medium.onnx?download=true) and [config](https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/alba/medium/en_GB-alba-medium.onnx.json?download=true.json), in `/usr/share/piper-voices/`. You can replace Alba with another [voice model](https://github.com/rhasspy/piper/blob/master/VOICES.md) of your choice

## Installation
1. Backup your existing config:
```bash
mv ~/.config/nvim ~/.config/nvim.backup # Backup your current setup (if you have one)
# Cleanup old configuration artefacts
rm -r ~/.local/share/nvim 
rm -r ~/.local/state/nvim
rm -r ~/.cache/nvim 
```

2. Install Vim-plug
```bash
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

3. Clone this config:
```bash
git clone https://github.com/ai-mindset/init.vim ~/.config/nvim
```

4. Start Neovim:
```bash
nvim --headless +PlugInstall +qall # Only required on first start, to install plugins
```

## Customization
- LSP servers: Modify `ensure_installed` in the Mason setup
- Copilot: Edit `g:copilot_filetypes` to enable/disable for specific languages
- Colour scheme: Change `colorscheme vscode` to your preferred theme
