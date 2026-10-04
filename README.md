# init.vim

A self-bootstrapping Neovim IDE for Python, Deno
TypeScript/JavaScript, Elixir, Markdown, and technical writing.

## What you get

- LSP completion, navigation, code actions, and visible diagnostics.
- Linting and format-on-save, with an explicit `<leader>==` formatter.
- Tree-sitter highlighting, indentation, folding, and sticky context.
- FZF search, Git tooling, snippets, autopairs, and Catppuccin Macchiato.
- Which-key discovery: press `Space` and pause to see available commands.
- Optional notebooks/IPython, Common Lisp, Marp, Piper speech, and Ollama.

| Language              | Default tooling                                                     |
| --------------------- | ------------------------------------------------------------------- |
| Python                | Jedi navigation/completion, Pyright type checking, Ruff lint/format |
| TypeScript/JavaScript | Deno LSP, linting, tests, and formatting                            |
| Elixir                | ElixirLS, Mix formatting, and project-local Credo                   |
| Markdown              | markdown-oxide, markdownlint-cli2, Deno formatting                  |

## Five-minute setup

Install:

- Neovim 0.12 or newer;
- Git and curl;
- a C compiler and `tree-sitter-cli` 0.26.1 or newer;
- Node.js and Python for the default language tools.

Confirm that `nvim`, `node`, `python`, and `tree-sitter --version` work, then:

```bash
mkdir -p ~/.config
mv ~/.config/nvim ~/.config/nvim.backup  # only if it already exists
git clone https://github.com/ai-mindset/init.vim ~/.config/nvim
nvim
```

The first launch downloads vim-plug, installs plugins, reloads the
configuration, and starts installing language tools through Mason. Tree-sitter
parsers install separately when its CLI is available. Initial setup may take a
few minutes; use `:Mason` and `:checkhealth` if anything fails.

Mason installs `actionlint`, `jedi-language-server`, `pyright`, `ruff`,
`markdown-oxide`, `markdownlint-cli2`, `deno`, and `elixir-ls`. Erlang and
Elixir are additionally required when working on Elixir projects.

## Everyday keys

`<leader>` is `Space`; `<localleader>` is `,`. Which-key exposes the full map.

| Mapping                     | Action                                   |
| --------------------------- | ---------------------------------------- |
| `K`                         | Hover documentation                      |
| `gd` / `gr`                 | Go to definition / find references       |
| `[d` / `]d`                 | Previous / next diagnostic               |
| `<leader>ca` / `<leader>rn` | Code action / rename                     |
| `<leader>==`                | Format file or selection                 |
| `<leader>f`                 | Find files                               |
| `<leader>mr` / `<leader>mp` | Render Markdown / toggle Marp preview    |
| `<leader>tw/tc/tp/tf/tv`    | Speak word/line/paragraph/file/selection |
| `<leader>ts`                | Stop speech                              |
| `<F8>`                      | Toggle Tagbar                            |

Grouped commands live under `<leader>l` (diagnostics), `<leader>g` (Git),
`<leader>d` (Deno), `<leader>e` (Elixir), `<leader>s` (spelling), and
`<leader>o` (Ollama).

## Optional integrations

- **IPython and notebooks:** install IPython, tmux, and Jupytext. Python cells
  use `# %%`; `.ipynb` files are edited through Jupytext.
- **Piper TTS:** install
  [Piper](https://github.com/OHF-Voice/piper1-gpl), an audio player (`aplay`,
  `pw-play`, `afplay`, or `ffplay`), and `en_GB-alba-medium.onnx` under
  `~/.local/share/piper-voices/` or `/usr/share/piper-voices/`. New speech
  replaces current speech; `<leader>ts` or `:PiperStop` stops it.
- **Ollama:** install [Ollama](https://ollama.com/), run
  `ollama pull mistral`, then use `<leader>os` / `<leader>ox` to start/stop it
  and `<C-x><C-o>` for completion.
- **Marp:** install the Marp CLI for `<leader>mp` slide previews.
- **Extras:** ripgrep improves search, Universal Ctags at
  `/usr/bin/ctags-universal` enables Tagbar, `jq` enables explicit JSON
  formatting, and a Nerd Font enables file icons.

## Customising

Search for `mason_packages`,
`lsp_servers`, `linters_by_ft`, `formatters_by_ft`, or `wk.add` to change the
installed tools, language behavior, formatting, or mappings.
