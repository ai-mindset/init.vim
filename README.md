# init.vim
A modern Neovim configuration focused on Clojure, TypeScript (Deno), and Python development with LSP support.

## Features

- **LSP Support**: Built-in language server support via Mason
  - Clojure, Deno (TypeScript), Python, and Lua preconfigured
  - Automatic LSP server installation
  - Intelligent code completion with nvim-cmp

- **Snippet Support**: LuaSnip with VSCode snippet compatibility
  - Tab completion with fallback
  - VSCode snippet loading via friendly-snippets

- **Git Integration**:
  - Full Git support via fugitive
  - Git signs in gutter
  - Git history browsing via Telescope

- **File Navigation**:
  - Telescope fuzzy finder
  - File history
  - Live grep
  - Git integration

- **Clojure Development**:
  - Conjure for REPL integration
  - Structured editing with vim-sexp
  - Simplified S-expression mappings

- **Quality of Life**:
  - GitHub Copilot (enabled for Python, TypeScript, Clojure)
  - Auto-pairs
  - Comments (gcc)
  - Text objects (surround)
  - Spell checking
  - TTS support via Piper
  - Status line with mode, spell status, and path info

## Key Mappings

- Leader key: `,`
- File finding: `,ff` (files), `,fg` (grep), `,fb` (buffers)
- Git: `,gc` (commits), `,gb` (branches)
- Spell checking: `,ss` (toggle), `,sn` (next), `,sp` (previous)
- TTS: `tw` (word), `tc` (line), `tp` (paragraph), `tf` (file)
- LSP: `gd` (definition), `K` (hover), `gr` (references)

## Requirements

- Neovim >= 0.8
- git
- ripgrep (for Telescope grep)
- A C compiler (for Treesitter)
- Deno (for TypeScript/JavaScript)
- [PiperTTS](https://github.com/rhasspy/piper) (for text-to-speech)
- Alba voice [model](https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/alba/medium/en_GB-alba-medium.onnx?download=true) and [config](https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/alba/medium/en_GB-alba-medium.onnx.json?download=true.json), in `/usr/share/piper-voices/alba.onnx`. You can replace Alba with another [voice model](https://github.com/rhasspy/piper/blob/master/VOICES.md) of your choice

## Installation

1. Backup your existing config:
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. Clone this config:
```bash
git clone  https://github.com/ai-mindset/init.vim ~/.config/nvim
```

3. Start Neovim:
```bash
nvim
```

Vim-plug and plugins will install automatically on first launch.

## Customization

- LSP servers: Modify `ensure_installed` in the Mason setup
- Copilot: Edit `g:copilot_filetypes` to enable/disable for specific languages
- Colour scheme: Change `colorscheme onedark` to your preferred theme
