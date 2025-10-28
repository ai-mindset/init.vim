# init.vim
A comprehensive Neovim configuration that transforms your editor into a full-featured IDE with intelligent code assistance, seamless Git integration, and powerful language tools for Data Science, AI Engineering, and Backend development.

## Development Environments
- GitHub Copilot with Copilot Chat integration
- Local LLM assistance with llama.vim

### Python (Data Science/AI)
- Full LSP support via Pyright
- Automatic linting and formatting with Ruff
- IPython integration with cell-based execution
- Jupyter notebook support with automatic conversion

### Rust (Systems programming/AI)
- Rust Analyzer LSP integration
- Smart completion and diagnostic messages
- Automatic imports and cargo commands
- Tagbar support for code navigation

### Deno (TS/JS backend dev./Data Science/AI)
- Advanced LSP features for modern JavaScript/TypeScript
- Built-in linting and formatting

### Julia (Data Science/AI)
- Full language server support with hover documentation
- Snippet completion and intelligent code assistance
- JuliaFormatter integration for code formatting
- REPL integration via vim-slime

### Container & Infrastructure
- Containerfile/Dockerfile LSP support
- Shell script (Bash/Zsh) language server

### Documentation & Data
- Markdown LSP with preview via markdown-preview.nvim
- Built-in spell checking
- Text-to-speech capabilities via Piper
- CSV viewing and editing with csvview.nvim
- Note-taking with journal.nvim

## Key Bindings
- `<leader>` = `<space>`
- `<localleader>` = `,`

### Development
- LSP hover: `K`
- Definition: `gd`
- References: `gr`
- Code actions: `<leader>ca`
- Format file: `<leader>==`
- Format JSON: `<leader>j`

### Navigation
- Find files: `<leader>f`
- Find keymappings: `<leader>k`
- Previous/next cell: `[c` / `]c`

### IPython
- Send cell: `<localleader>c`
- Send line: `<localleader>l`
- Send selection: `<localleader>v` (in visual mode)

### Git
- Diff view: `<leader>gd`
- Merge conflicts: `<leader>gm`
- Stage hunk: `<leader>hs`
- Preview hunk: `<leader>hp`
- Conflict resolution: `<leader>go/gt/gb` (ours/theirs/both)

### AI Assistance
- Copilot Chat: `<leader>cp`
- Toggle Chat: `<leader>cpt`
- Fix diagnostic: `<leader>cpf`
- Explain code: `<leader>cpe`

## Requirements
- [Neovim](https://neovim.io/)
- [git](https://git-scm.com/)
- [node.js](https://nodejs.org/) (for copilot.vim)
- [llama-cpp-server](https://github.com/ggerganov/llama.cpp) (for llama.vim)
- [ripgrep](https://github.com/BurntSushi/ripgrep) for global search (optional)
- [Deno](https://deno.com/) (TS/JS development)
- [Python](https://www.python.org/) (optionally, [Jupyter](https://jupyter.org/) for notebook support)
- [IPython](https://ipython.org/) for Python REPL-driven development
- [Julia](https://julialang.org/)
- [PiperTTS](https://github.com/rhasspy/piper) (for text-to-speech)
- Alba voice model in `/usr/share/piper-voices/`

## Installation
1. Backup your existing config:
```bash
mv ~/.config/nvim ~/.config/nvim.backup # Backup your current setup
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

## Julia Setup

For full Julia language support, set up your environment with these steps:

```bash
# Install juliaup (cross-platform Julia version manager)
curl -fsSL https://install.julialang.org | sh

# Add Julia and set as default (v1.12 is the latest stable release at the time of writing)
juliaup add 1.12  # Replace with your version
juliaup default 1.12  # Replace with your version

# Install required packages in the global environment
julia --project=~/.julia/environments/v1.12 -e '
    using Pkg;
    Pkg.add(["LanguageServer", "SymbolServer", "StaticLint", "JuliaFormatter"]);
    Pkg.precompile()
'
```

Note: v1.12 is used in this example as it's the latest stable version at the time of writing. Replace with whichever version you have installed.

## Customization
- LSP servers: Modify `ensure_installed` in the Mason setup (Python, Rust, JSON, YAML, etc.)
- Colour scheme: Change `colorscheme catppuccin` to your preferred theme
- Formatters: Adjust `formatters_by_ft` in the conform.nvim setup
- Keybindings: Modify the which-key configuration
- CSV view: Customize the csvview.nvim configuration

## Rust Tagbar Setup
For Exuberant Ctags (default in many distros), create `~/.ctags` with:

```
--langdef=Rust
--langmap=Rust:.rs
--regex-Rust=/^[ \t]*(#\[[^\]]\][ \t]*)*(pub[ \t]+)?(extern[ \t]+)?("[^"]+"[ \t]+)?(unsafe[ \t]+)?fn[ \t]+([a-zA-Z0-9_]+)/\6/f,functions,function definitions/
--regex-Rust=/^[ \t]*(pub[ \t]+)?type[ \t]+([a-zA-Z0-9_]+)/\2/T,types,type definitions/
--regex-Rust=/^[ \t]*(pub[ \t]+)?enum[ \t]+([a-zA-Z0-9_]+)/\2/g,enumerations,enumeration names/
--regex-Rust=/^[ \t]*(pub[ \t]+)?struct[ \t]+([a-zA-Z0-9_]+)/\2/s,structure names/
--regex-Rust=/^[ \t]*(pub[ \t]+)?mod[ \t]+([a-zA-Z0-9_]+)/\2/m,modules,module names/
--regex-Rust=/^[ \t]*(pub[ \t]+)?(static|const)[ \t]+(mut[ \t]+)?([a-zA-Z0-9_]+)/\4/c,consts,static constants/
--regex-Rust=/^[ \t]*(pub[ \t]+)?trait[ \t]+([a-zA-Z0-9_]+)/\2/t,traits,traits/
--regex-Rust=/^[ \t]*(pub[ \t]+)?impl([ \t\n]*<[^>]*>)?[ \t]+(([a-zA-Z0-9_:]+)[ \t]*(<[^>]*>)?[ \t]+(for)[ \t]+)?([a-zA-Z0-9_]+)/\4 \6 \7/i,impls,trait implementations/
--regex-Rust=/^[ \t]*macro_rules![ \t]+([a-zA-Z0-9_]+)/\1/d,macros,macro definitions/
--regex-Rust=/^[ \t]*(pub[ \t]+)?impl[ \t]+([a-zA-Z0-9_]+)/\2/r,impls,impl/
```

This enables tagbar (<F8>) to display Rust code structure.
