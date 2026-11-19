# init.vim

Neovim IDE for Odin, Python, JavaScript/TypeScript, Elixir, and Markdown:
LSP completion and navigation, diagnostics, format on save, Tree-sitter, FZF,
Git tools, and the Modus theme. The entire configuration lives in a portable
`init.vim`.

## Setup

Requires **Neovim 0.12+**, Git, curl, a C compiler, `tree-sitter-cli` 0.26.1+,
Node.js, and Python 3. Install the runtimes for the languages you use; Odin also
needs [OLS](https://github.com/DanielGavin/ols). For Bun, see below.

```sh
git clone https://github.com/ai-mindset/init.vim
cd init.vim
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
mkdir -p "$config_dir"
[ ! -e "$config_dir/init.vim" ] || cp "$config_dir/init.vim" "$config_dir/init.vim.backup"
cp init.vim "$config_dir/init.vim"
nvim
```

Only `init.vim` needs to be copied; no installer or companion files are required.
To update, copy the latest `init.vim` to the same location and restart Neovim.
Plugins and Mason tools install automatically.
Retry plugins with `:PlugInstall`; inspect tools with `:Mason`.

## Daily use

`<leader>` is **Space**; `<localleader>` is **`,`**. Press Space and pause to
browse mappings. Supported files format on save; `:Format` formats manually.

| Keys | Action |
| ---- | ------ |
| `K` | Hover documentation; press again to focus |
| `gd` / `gr` | Definition / references |
| `<C-k>` in insert mode | Signature help |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>ca` / `<leader>rn` | Code action / rename |
| `<leader>==` | Format file or selection |
| `<leader>f` | Find files |
| `<leader>l` / `<leader>g` | Diagnostics / Git |
| `<leader>O` | Odin commands |
| `<leader>mr` / `<leader>mp` | Render Markdown / Marp preview |
| `<F8>` | Toggle Tagbar |

Python uses Ruff for linting/formatting; Elixir formats with `mix format`.
GitHub Actions workflows use `actionlint`.

## Odin

OLS supplies language services and runs `odin check -vet` on save for compiler
errors, unused variables/imports, and shadowing. Tree-sitter supplies highlighting,
indentation, and folds.

Formatting uses `odinfmt`, with OLS as fallback. Build it with `./odinfmt.sh` in
the OLS repository; place it on PATH or beside `odin`. Settings come from the
nearest `odinfmt.json` above the file's directory.

Tools are discovered on PATH or beside the compiler under `~/.local/opt/odin*/`;
`ODIN_ROOT` also locates the compiler. Override paths before LSP setup with
`g:odin_executable`, `g:ols_executable`, or `g:odinfmt_executable`. Keep OLS's
bundled `builtin` folder beside it when provided.

| Command / keys | Action |
| -------------- | ------ |
| `:OdinBuild` / `<leader>Ob` | Build current package |
| `:OdinRun` / `<leader>Or` | Build and run |
| `:OdinTest` / `<leader>Ot` | Run `@(test)` procedures |
| `:OdinCheck` / `<leader>Oc` | Type-check, including packages without `main` |
| `:OdinDebug` / `<leader>Od` | Build with debug info; start / continue debugger |
| `<leader>Op` / `<leader>Oq` | Toggle breakpoint / stop debugger |
| `<leader>On` / `<leader>Oi` / `<leader>Oo` | Step over / into / out |
| `<leader>Ov` / `<leader>Oe` | Inspect variables / toggle debug console |
| `<leader>Os` / `<leader>Oh` | Document symbols / toggle parameter hints |
| `:OdinInfo` / `<leader>OI` | Tool paths, OLS attachment, parser status |

Tasks save the current file and compile its **directory as a package**; save
other edited files first. Override the target with `:let b:odin_package = 'src'`
(project-relative or absolute). Working directory: nearest `ols.json` root,
otherwise Git root, otherwise file directory.

Commands accept compiler flags; run/test/debug accept program arguments after
`--`: `:OdinRun -collection:shared=./shared -- hello`.

Build/check errors go to quickfix (`:cnext` / `:cprevious`); run/test open a
terminal (`<C-\><C-n>` leaves terminal mode; Ctrl-C stops the program).
Mason installs CodeLLDB; retry with `:MasonInstall codelldb`. Debug builds use
`-debug -o:none` in Neovim's cache.

Configure collections, `checker_args`, and LSP profiles in
[`ols.json`](https://github.com/DanielGavin/ols#configuration), or editor defaults
via `g:odin_ols_options`. Compiler tasks take flags explicitly.

## Bun, JavaScript/TypeScript, and data files

Install [Bun](https://bun.sh/docs/installation) with `bun fmt` and native
Markdown/JSON linting; tested with `1.4.4-canary.1+447ff870b`.
`~/.bun/bin` is added to Neovim's PATH.

- **Formatting:** JS/TS, JSON/JSONC/JSON5, Markdown/MDX, CSS/SCSS/Less, HTML,
  Vue, Svelte, YAML, TOML, and GraphQL, including selections. Uses project
  settings relative to the file and bypasses package scripts.
- **Linting:** JS/TS, JSON/JSONC/JSON5, and Markdown on open/save using buffer
  contents. Project ESLint configs take precedence; otherwise JSON and Markdown
  use embedded Bun-native rules without extra packages.
- **Language services:** Mason installs `typescript-language-server`, which
  runs on Node.js. For Bun API types, run `bun add --dev @types/bun` in the
  project. JSON/JSONC use `jsonls` for schema validation via `$schema`.

## Optional tools

- **Notebooks:** IPython, tmux, Jupytext; Python cells use `# %%`.
- **Ollama:** `ollama pull mistral`; commands under `<leader>o`.
- **Marp:** Marp CLI for slide previews.
- **Speech:** Piper, an audio player, and `en_GB-alba-medium.onnx` in
  `~/.local/share/piper-voices/`; commands under `<leader>t`.
- **Utilities:** ripgrep, Universal Ctags, a Nerd Font.

## Troubleshooting and checks

Use `:checkhealth`, `:Mason`, `:ConformInfo`, or `:OdinInfo`.
Run integration checks with installed tools/plugins:

```sh
nvim --headless -u NONE -i NONE -l tests/odin_tools.lua
nvim --headless -u NONE -i NONE -l tests/bun_tools.lua
```
