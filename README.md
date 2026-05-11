# init.vim
A comprehensive Neovim configuration that transforms your editor into a full-featured IDE with intelligent code assistance, seamless Git integration, and powerful language tools for Data Science, AI Engineering, and Backend development.

## Development Environments
- GitHub Copilot integration
- Local LLM assistance with Ollama integration

### Python (Data Science/AI)
- Full LSP support via Jedi Language Server
- Automatic linting and formatting with Ruff
- Type checking with ty
- IPython integration with cell-based execution
- Jupyter notebook support with automatic conversion

### Elixir (Functional Programming-style Data Science/AI)
- Elixir Language Server (ElixirLS) integration
- Real-time error checking and diagnostics
- Mix project support with formatting
- Code intelligence and hover documentation

### Zig (Systems Programming)
- Zig Language Server (ZLS) integration
- Real-time error checking with zig compiler
- Automatic code formatting with zig fmt
- Smart completion and diagnostic messages

### Container & Infrastructure
- Containerfile/Dockerfile LSP support
- Shell script (Bash/Zsh) language server

### Documentation & Data
- Markdown LSP with preview via markdown-preview.nvim
- JSON/YAML language servers with Biome formatting
- Built-in spell checking
- Text-to-speech capabilities via Piper
- CSV viewing and editing with csvview.nvim
- Note-taking with journal.nvim

## Key Bindings
- `<leader>` = `<space>`
- `<localleader>` = `,`

### Development
- LSP hover: `K`
- Go to definition: `gd`
- Go to declaration: `gD`
- Go to implementation: `gi`
- Find references: `gr`
- Show diagnostics: `gh`
- Code actions: `<leader>ca`
- Rename symbol: `<leader>rn`
- Show signature help: `<C-k>` (insert mode)

### Formatting
- Format file: `<leader>==`
- Format JSON with jq: `<leader>=j`

### Navigation
- Find files: `<leader>f`
- Find keymappings: `<leader>k`
- Previous/next cell: `[c` / `]c`
- Previous/next conflict: `[g` / `]g`
- Previous/next git hunk: `<c` / `>c`
- Toggle Tagbar: `<F8>`
- Insert cell above: `<F9>`
- Insert cell below: `<F10>`

### IPython Integration
- Send cell: `<localleader>c`
- Send line: `<localleader>l`
- Send selection: `<localleader>v` (visual mode)

### Git Operations
- Diff view: `<leader>gd`
- Merge conflicts view: `<leader>gm`
- Open conflicts: `<leader>gc`
- Close diff view: `<leader>gx`
- Accept current changes: `<leader>go`
- Accept incoming changes: `<leader>gt`
- Accept both changes: `<leader>gb`
- Stage hunk: `<leader>hs`
- Reset hunk: `<leader>hr`
- Preview hunk: `<leader>hp`

### Elixir Development
- Format current file: `<leader>ef`
- Run all tests: `<leader>et`
- Compile project: `<leader>ec`
- Restart Elixir LS: `<leader>er`

### Text-to-Speech
- Speak word: `<leader>tw`
- Speak current line: `<leader>tc`
- Speak paragraph: `<leader>tp`
- Speak file: `<leader>tf`
- Speak selection: `<leader>tv`

### Spelling
- Toggle spell checking: `<leader>ss`
- Next misspelled word: `<leader>sn`
- Previous misspelled word: `<leader>sp`
- Add word to dictionary: `<leader>sa`
- Suggest corrections: `<leader>s?`

### Copy Path
- Copy full path: `<leader>Yf`
- Copy relative path: `<leader>Yr`
- Copy filename only: `<leader>Yn`

### AI Assistance
- Start Ollama Server: `<leader>os`
- Stop Ollama Server: `<leader>ox`
- Trigger Ollama completion: `<C-x><C-o>` (insert mode)

### Utilities
- Toggle paste mode: `<leader>pp`

## Requirements
- [Neovim](https://neovim.io/)
- [git](https://git-scm.com/)
- [node.js](https://nodejs.org/) (for copilot.vim)
- [ollama](https://ollama.com/) (for local LLM capabilities)
- [ripgrep](https://github.com/BurntSushi/ripgrep) for global search (optional)
- [Zig](https://ziglang.org/) (Systems programming)
- [Elixir](https://elixir-lang.org/) (Functional programming/Backend development)
- [Python](https://www.python.org/) with [uv](https://github.com/astral-sh/uv) (optionally, [Jupyter](https://jupyter.org/) for notebook support)
- [IPython](https://ipython.org/) for Python REPL-driven development
- [Piper](https://github.com/OHF-Voice/piper1-gpl) (for text-to-speech, previously rhasspy/piper)
- Voice model for text-to-speech capabilities

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

4. Install tree-sitter CLI (required for syntax highlighting):

**Linux:**
```bash
# Install system library
sudo apt install libtree-sitter-dev

# Download pre-built CLI binary
curl -L -o /tmp/tree-sitter-linux-x64.gz https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.5/tree-sitter-linux-x64.gz
gunzip /tmp/tree-sitter-linux-x64.gz
sudo mv /tmp/tree-sitter-linux-x64 /usr/local/bin/tree-sitter
sudo chmod +x /usr/local/bin/tree-sitter
```

**macOS:** `brew install tree-sitter`

**Windows:** Download from [GitHub releases](https://github.com/tree-sitter/tree-sitter/releases/latest) or `winget install tree-sitter.tree-sitter`

5. Start Neovim:
```bash
nvim --headless +PlugInstall +qall # Only required on first start, to install plugins
```

Treesitter parsers (elixir, eex, heex, python, zig, etc.) will install automatically when you first open files of those types.

## Ollama Setup

For local LLM capabilities, you need to install and set up Ollama:

```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Start the Ollama server
ollama serve

# In another terminal, pull the mistral model
ollama pull mistral
```

You can also start and stop the Ollama server directly from Neovim using:
- `<leader>os` - Start Ollama Server
- `<leader>ox` - Stop Ollama Server

## Piper TTS Setup

For text-to-speech capabilities, install Piper using `uv` (a faster, more reliable Python package installer):

```bash
# Install uv if you don't have it already
curl -fsSL https://astral.sh/uv/install.sh | bash

# Install Piper using uv
uv pip install piper-tts

# Download a voice model
mkdir -p ~/.local/share/piper-voices/
# You can choose any voice model from https://huggingface.co/rhasspy/piper-voices/
# For example:
wget -P ~/.local/share/piper-voices/ https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_GB/alba/medium/en_GB-alba-medium.onnx
```

Use text-to-speech in Neovim with these commands:
- `<space>tw` - Speak Word
- `<space>tc` - Speak Current Line
- `<space>tp` - Speak Current Paragraph
- `<space>tf` - Speak Current File
- `<space>tv` - Speak Visual Selection

## Elixir Setup

For full Elixir language support, install Elixir and set up your development environment:

```bash
# Install Elixir (varies by OS)
# On macOS with Homebrew:
brew install elixir

# On Ubuntu/Debian:
sudo apt-get update
sudo apt-get install elixir

# On Arch Linux:
sudo pacman -S elixir

# Verify installation
elixir --version
mix --version
```

The configuration automatically installs and configures ElixirLS (Elixir Language Server) via Mason. No additional setup is required.

Use the Elixir development keybindings:
- `<leader>ef` - Format current file with `mix format`
- `<leader>et` - Run all tests with `mix test`
- `<leader>ec` - Compile project with `mix compile`
- `<leader>er` - Restart Elixir Language Server

## Customisation
- LSP servers: Modify `ensure_installed` in the Mason setup (Python, Zig, Elixir, Docker, Markdown, Bash, JSON, YAML, etc.)
- Colour scheme: Change `colorscheme catppuccin` to your preferred theme
- Formatters: Adjust `formatters_by_ft` in the conform.nvim setup
- Keybindings: Modify the which-key configuration
- CSV view: Customize the csvview.nvim configuration

## Tagbar Setup

### Zig Tagbar Setup
For Exuberant Ctags (default in many distros), a `.ctags` file is provided in this repo with support for:
- Zig (functions, structs, enums, unions, constants, variables, tests)

Save the file in `$HOME/.ctags`.
Press `<F8>` to toggle Tagbar for code navigation in supported languages.

Zig support requires the language patterns in `.ctags`. The configuration is already included in this repo.
