# init.vim

A Neovim IDE for Jac, Python, Go, JavaScript/TypeScript, Elixir, and Markdown.
Includes LSP completion and navigation, diagnostics, formatting, Tree-sitter,
FZF, Git tools, and the Modus theme.

## Setup

Requires Neovim 0.12+, Git, curl, a C compiler, and `tree-sitter-cli` 0.26.1+.
Node.js and Python support the default language tools; Go and Elixir tooling
require their respective runtimes.

Back up your existing Neovim configuration, then:

```bash
git clone https://github.com/ai-mindset/init.vim
cd init.vim
python3 scripts/install.py
nvim
```

The installer copies all required files into `~/.config/nvim` and backs up
replaced files. Use `--target /path/to/nvim` for another location. Run it again
from your checkout to install updates, then restart Neovim.

First launch installs plugins and language tools automatically. Use
`:PlugInstall` to retry plugin installation and `:Mason` to inspect tools.

## Keys

`<leader>` is `Space`; `<localleader>` is `,`. Press `Space` and pause to
browse all mappings with which-key.

| Keys | Action |
| ---- | ------ |
| `K` | Hover documentation; press again to focus |
| `gd` / `gr` | Definition / references |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>ca` / `<leader>rn` | Code action / rename |
| `<leader>==` | Format file or selection |
| `<leader>f` | Find files |
| `<leader>j` | Jac commands |
| `<leader>l` / `<leader>g` | Diagnostics / Git |
| `<leader>mr` / `<leader>mp` | Render Markdown / Marp preview |
| `<F8>` | Toggle Tagbar |

## Jac

Install Jac using the [official guide](https://docs.jaseci.org/quick-guide/install/).
Neovim includes `~/.local/bin` in its PATH. Run `jac install` inside your project
to resolve dependencies. Use `:TSInstall jac` to retry parser installation.

| Command | Action |
| ------- | ------ |
| `:JacRun [args]` | Run the current file |
| `:JacTest` / `:JacTestProject` | Test the current module / project |
| `:JacCheck` / `:JacLint` | Type-check / lint the project |
| `:JacDebug` | Debug in the Jdb terminal debugger |
| `:JacStart` | Start the development server with hot reload |
| `:JacInfo` / `:JacHoverInfo` | Inspect tooling / hover lookup status |

Tasks save the current file and run in a separate terminal at the project root.
Press `<C-\><C-n>` to leave terminal mode, or `Ctrl-C` to stop the program.

Hover appears immediately; additional Python documentation loads asynchronously
and is cached. Jac function docstrings go before `def`; the file's first
string documents the module. To disable the Python documentation fallback,
set `let g:jac_hover_python_docs = v:false`.

For runtime node/edge graphs, call `printgraph(root, file="graph.dot");` after
building the graph, then execute the program normally with `:JacRun`.

## Optional tools

- **Notebooks/IPython:** IPython, tmux, and Jupytext; Python cells use `# %%`.
- **Ollama:** run `ollama pull mistral`; commands are under `<leader>o`.
- **Marp:** install the Marp CLI for slide previews.
- **Piper speech:** install Piper, an audio player, and `en_GB-alba-medium.onnx`
  in `~/.local/share/piper-voices/`; commands are under `<leader>t`.
- **Extras:** ripgrep, Universal Ctags, jq, and a Nerd Font.

Troubleshoot with `:checkhealth`, `:Mason`, `:ConformInfo`, or the Jac status
commands above. Configuration lives in `init.vim`.
