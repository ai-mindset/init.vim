# init.vim

A lightweight, full-featured Neovim IDE for Python, Deno TypeScript/JavaScript,
Elixir, Markdown, and technical writing. The configuration favours fast native
features, visible diagnostics, discoverable Which-key mappings, and a
comfortable Catppuccin Macchiato interface for Kitty and tmux.

## Language support

### Python

- Jedi Language Server provides completion, navigation, signatures, and hover
  documentation.
- Pyright provides `standard` type checking without duplicating Jedi's UI
  features.
- Ruff provides linting, import organisation, and formatting.
- IPython cells work through vim-slime and tmux.
- Jupyter notebooks are edited as Python percent-format buffers through
  Jupytext.

### Deno TypeScript/JavaScript

- Deno's language server provides completion, navigation, type checking, and
  lint diagnostics.
- Deno formatting runs through conform.nvim.
- Attachment is limited to plain `typescript` and `javascript` files in Deno
  projects; React filetypes are intentionally excluded.

### Elixir

- ElixirLS provides completion, navigation, compiler diagnostics, and Dialyzer
  analysis.
- Mix formatting runs automatically through conform.nvim.
- Credo diagnostics are added when the current Mix project includes Credo.

### Markdown and writing

- markdown-oxide provides Markdown language intelligence.
- markdownlint-cli2 reports Markdown style problems.
- render-markdown.nvim renders Markdown inside Neovim.
- Marp preview is available for saved slide decks.
- Prose buffers enable wrapping and British English spell checking.
- Piper TTS can read a word, line, paragraph, selection, or file.

### Additional support

- actionlint checks files under `.github/workflows/`.
- Tree-sitter highlighting, indentation, folding, and sticky code context cover
  the configured languages.
- Vlime supports Common Lisp, csvview.nvim handles tabular data, and
  journal.nvim manages notes.
- Git workflows use Fugitive, Gitsigns, and Diffview.
- Ollama provides optional local LLM completion.

## Diagnostics

LSP servers and external linters all publish through Neovim's diagnostic API.
Every severity is retained and shown through:

- coloured `E`, `W`, `I`, and `H` gutter signs;
- coloured line numbers and underlines;
- statusline counts such as `E:2@14`, including the first affected line;
- a non-focus-stealing popup when the cursor rests on an affected line;
- navigable location and quickfix lists containing file, line, column, source,
  rule code, and message.

Virtual text is disabled so diagnostics do not displace source code. `K` opens
rendered LSP documentation, while `gh` opens diagnostics for the current line.

| Mapping                     | Action                                       |
| --------------------------- | -------------------------------------------- |
| `]d` / `[d`                 | Next / previous diagnostic                   |
| `<leader>ln` / `<leader>lp` | Next / previous diagnostic                   |
| `<leader>le` / `<leader>lE` | Next / previous error                        |
| `<leader>lw` / `<leader>lW` | Next / previous warning                      |
| `<leader>lh` or `gh`        | Show diagnostics on the current line         |
| `<leader>ld`                | List diagnostics for the current buffer      |
| `<leader>lD`                | List known diagnostics across loaded buffers |

Each jump opens the corresponding diagnostic message. The entire group is
discoverable under `<leader>l` in Which-key.

## Requirements

Required:

- [Neovim](https://neovim.io/) 0.12.0 or newer;
- Git and curl;
- a C compiler and
  [tree-sitter-cli](https://github.com/nvim-treesitter/nvim-treesitter) 0.26.1
  or newer for Tree-sitter parser builds;
- Node.js for Pyright and markdownlint-cli2—the configuration also discovers
  asdf Node installations;
- Python for Python tooling;
- Erlang and Elixir for ElixirLS and Mix workflows.

Useful optional tools:

- [ripgrep](https://github.com/BurntSushi/ripgrep) for FZF-powered search and
  completion;
- IPython, tmux, and Jupytext for the Python REPL/notebook workflow;
- [Marp CLI](https://github.com/marp-team/marp-cli) for slide preview;
- [Piper](https://github.com/OHF-Voice/piper1-gpl), a supported audio player,
  and the Alba voice model for TTS;
- [Ollama](https://ollama.com/) for local LLM completion;
- `jq` for the explicit JSON formatting command;
- Universal Ctags for Tagbar;
- a Nerd Font for optional filetype icons.

## Installation

1. Back up an existing configuration if necessary:

```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. Clone this repository:

```bash
git clone https://github.com/ai-mindset/init.vim ~/.config/nvim
```

3. Install `tree-sitter-cli` using an upstream-supported installation method and
   confirm it is available on `PATH`:

```bash
tree-sitter --version
```

If the upstream Linux binary requires a newer glibc than the host provides,
build the CLI in a Debian Bullseye container. This keeps Rust, Cargo, Clang, and
the older build-time glibc inside Podman; only the resulting executable is
written to `~/.local/bin`:

```bash
mkdir -p "$HOME/.local"

podman run --rm \
  --volume "$HOME/.local:/output" \
  docker.io/library/rust:1.97.1-bullseye \
  bash -c '
    apt-get update &&
    apt-get install -y --no-install-recommends clang libclang-dev &&
    export PATH="/usr/local/cargo/bin:$PATH" &&
    cargo install tree-sitter-cli \
      --version 0.26.11 \
      --locked \
      --root /output
  '
```

Ensure the installation directory is on the shell path, then verify the host
binary rather than the incompatible download:

```bash
export PATH="$HOME/.local/bin:$PATH"
rehash
command -v tree-sitter
tree-sitter --version
```

The `--rm` option removes the temporary build container when it exits. After
verifying the CLI, the cached build image can also be removed:

```bash
podman image rm docker.io/library/rust:1.97.1-bullseye
podman system df
```

4. Start Neovim normally:

```bash
nvim
```

On a fresh installation, the configuration downloads vim-plug, installs plugins,
and reloads itself. Mason then installs these tools from the central
`mason_packages` list:

- actionlint
- jedi-language-server
- pyright
- ruff
- markdown-oxide
- markdownlint-cli2
- deno
- elixir-ls

Tree-sitter installs its configured parsers independently once the CLI is
available. ElixirLS may perform a longer one-time compilation when first opened
after an upgrade.

## Main keybindings

Press `<leader>` (Space) and pause briefly to browse available mappings with
Which-key.

| Mapping               | Action                               |
| --------------------- | ------------------------------------ |
| `K`                   | LSP hover documentation              |
| `<leader>ca`          | LSP code action                      |
| `<leader>rn`          | Rename symbol                        |
| `<leader>==`          | Format file or visual selection      |
| `<leader>f`           | Find files with FZF                  |
| `<leader>mp`          | Toggle Marp preview                  |
| `<leader>mr`          | Toggle in-editor Markdown rendering  |
| `<leader>tw/tc/tp/tf` | Speak word / line / paragraph / file |
| `<leader>tv`          | Speak visual selection               |
| `<F8>`                | Toggle Tagbar                        |

Deno commands are under `<leader>d`, Elixir commands under `<leader>e`, Git
commands under `<leader>g`, and spelling commands under `<leader>s`.

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

Install Piper and place `en_GB-alba-medium.onnx` in either:

- `~/.local/share/piper-voices/`
- `/usr/share/piper-voices/`

The configuration looks for the Piper executable on `PATH`, in `~/.local/bin`,
`~/.local/share/piper`, or `~/.venv/bin`. Playback uses the first available
command among `aplay`, `pw-play`, `afplay`, and `ffplay`.

## Interface and terminal

Catppuccin Macchiato uses true colour and explicit high-contrast gutter, ruler,
cursor-line, cursor-column, and diagnostic highlights. Kitty works directly;
configure tmux separately to advertise `tmux-kitty` and RGB colour.

Tree-sitter context keeps the enclosing function or scope visible at the top of
long files. Hover, signature, completion-documentation, diagnostic, and Markdown
windows use bordered floating windows.

## Tagbar

The bundled `.ctags` file defines tags for Elixir, JavaScript, TypeScript, and
Zig. Copy or link it to `~/.ctags` if your Ctags installation does not load the
repository file automatically. Press `<F8>` to toggle Tagbar.

## Customisation

- Mason tools: edit `mason_packages`.
- LSP clients: edit `lsp_servers` and their `vim.lsp.config` blocks.
- Linters: edit `linters_by_ft` and `lint_buffer`.
- Formatters: edit `formatters_by_ft` in the conform.nvim setup.
- Keybindings: edit the `wk.add` tables.
- Theme: adjust the Catppuccin setup and `apply_accessible_ui_highlights`.
