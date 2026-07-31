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
#!/usr/bin/env bash
set -e

PIPER_VERSION="2023.11.14-2"
VOICE_URL="https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_GB/alba/medium"
VOICE_NAME="en_GB-alba-medium"

# Detect OS and architecture
OS="$(uname -s)"
ARCH="$(uname -m)"
case "$OS" in
  Linux)  PLATFORM="linux_${ARCH}" ;;
  Darwin) [[ "$ARCH" == "arm64" ]] && PLATFORM="macos_arm64" || PLATFORM="macos_x64" ;;
  MINGW*|CYGWIN*|MSYS*) PLATFORM="windows_amd64" ;;
  *) echo "Unsupported OS: $OS"; exit 1 ;;
esac

# Download and extract Piper
mkdir -p ~/.local/share/piper
cd ~/.local/share/piper
if [[ "$PLATFORM" == windows_amd64 ]]; then
  curl -L -o piper.zip "https://github.com/rhasspy/piper/releases/download/${PIPER_VERSION}/piper_${PLATFORM}.zip"
  unzip -o piper.zip
else
  curl -L -o piper.tar.gz "https://github.com/rhasspy/piper/releases/download/${PIPER_VERSION}/piper_${PLATFORM}.tar.gz"
  tar -xzf piper.tar.gz
fi

# Download voice model and config
mkdir -p ~/.local/share/piper-voices
cd ~/.local/share/piper-voices
wget -nc "$VOICE_URL/${VOICE_NAME}.onnx"
wget -nc "$VOICE_URL/${VOICE_NAME}.onnx.json"
```

Use text-to-speech in Neovim with these commands:
- `<space>tw` - Speak Word
- `<space>tc` - Speak Current Line
- `<space>tp` - Speak Current Paragraph
- `<space>tf` - Speak Current File
- `<space>tv` - Speak Visual Selection


You can convert text to audio with


```bash
cat input.txt | piper \
  --model en_GB-alba-medium.onnx \
  --config en_GB-alba-medium.onnx.json \
  --output_file speech.wav

ffmpeg -i speech.wav -codec:a libmp3lame -q:a 4 output.mp3
```

## Nerd Fonts Setup

Nerd Fonts are required for icon rendering (used by markdown preview and other UI components).

**Linux:**
```bash
mkdir -p ~/.local/share/fonts
curl -fLo ~/.local/share/fonts/JetBrainsMono.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip ~/.local/share/fonts/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
fc-cache -fv
```

**macOS:**
```bash
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font
```

Then set `JetBrainsMono Nerd Font` (or equivalent) as your terminal's font.

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

### Zig and Elixir Tagbar Setup
For Exuberant Ctags (default in many distros), a `.ctags` file is provided in this repo with support for:
- Zig (functions, structs, enums, unions, constants, variables, tests)

Save the file in `$HOME/.ctags`.
Press `<F8>` to toggle Tagbar for code navigation in supported languages.

Zig and Elixir support requires the language patterns in `.ctags`. The configuration is already included in this repo.
