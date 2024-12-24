# init.vim
A comprehensive Neovim configuration that transforms Neovim into a full-featured IDE for data science, AI Engineering, and backend development. Supports Python, Clojure, JavaScript/TypeScript (via Deno), shell scripting, containerization, and technical documentation.

## Development Environments
- GitHub Copilot AI assistance

### Python (Data Science/AI)
- Full LSP support via Pyright
- Automatic linting and formatting with Ruff
- REPL integration through Conjure
- IPython support with matplotlib integration

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
- Markdown LSP with preview
- Spell checking 
- Text-to-speech support via Piper

## Features
- **Language Server Protocol** (LSP) integration
- **GitHub Copilot**
- **Fuzzy finding** for files and code
- **Tree-sitter** syntax highlighting
- **Git** integration
- **VSCode-like** theme

## Key Bindings
### Development
- LSP hover: `K`
- Definition: `gd`
- References: `gr`
- Code actions: `<space>ca`

### Navigation
- Find files: `<space>f`
- Live grep: `<space>l`
- Buffers: `<space>bf`
- Git files: `<space>gf`
- Diagnostics: `<space>dg`

### REPL
- Connect: `<localleader>cc`
- Evaluate: `<localleader>ee`
- Documentation: `<localleader>hd`

## Requirements
- Neovim
- git
- fzf
- node.js (for copilot.vim)
- [glow](https://github.com/charmbracelet/glow) for Markdown preview (optional)
- [Deno](https://ai-mindset.github.io/deno/) (for TypeScript/JavaScript)
- [Python](https://ai-mindset.github.io/bring-it-back-to-basics/) with IPython and matplotlib
- [Clojure](https://github.com/ai-mindset/clj-installer)
- [PiperTTS](https://github.com/rhasspy/piper) (for text-to-speech)
- Alba voice [model](https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/alba/medium/en_GB-alba-medium.onnx?download=true) and [config](https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/alba/medium/en_GB-alba-medium.onnx.json?download=true.json), in `/usr/share/piper-voices/`. You can replace Alba with another [voice model](https://github.com/rhasspy/piper/blob/master/VOICES.md) of your choice

## Installation
1. Backup your existing config:
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. Clone this config:
```bash
git clone https://github.com/ai-mindset/init.vim ~/.config/nvim
```

3. Start Neovim:
```bash
nvim +PlugInstall
```

Vim-plug and plugins will install automatically on first launch.

## Customization
- LSP servers: Modify `ensure_installed` in the Mason setup
- Copilot: Edit `g:copilot_filetypes` to enable/disable for specific languages
- Colour scheme: Change `colorscheme vscode` to your preferred theme
