" Auto-install vim-plug if not present
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" LSP Support with Mason
Plug 'williamboman/mason.nvim'                                " Mason
Plug 'williamboman/mason-lspconfig.nvim'                      " Mason LSP Config
Plug 'neovim/nvim-lspconfig'                                  " LSP Configuration
Plug 'mfussenegger/nvim-lint'                                 " Linting engine
Plug 'stevearc/conform.nvim'                                  " Formatting engine
Plug 'hrsh7th/nvim-cmp'                                       " Completion Engine
Plug 'hrsh7th/cmp-nvim-lsp'                                   " LSP completion
Plug 'hrsh7th/cmp-buffer'                                     " Buffer completion 
Plug 'hrsh7th/cmp-cmdline'                                    " Command line completion
Plug 'hrsh7th/cmp-path'                                       " Path completion

" GitHub Copilot
Plug 'github/copilot.vim'                                     " GitHub Copilot

" Clojure Development
Plug 'Olical/conjure'                                         " Clojure REPL 
Plug 'PaterJason/cmp-conjure'                                 " Clojure completion
Plug 'guns/vim-sexp'                                          " Clojure S-Expression 
Plug 'tpope/vim-sexp-mappings-for-regular-people'             " Clojure S-Expression Mappings 

" Theme
Plug 'Mofiqul/vscode.nvim'

" Fuzzy finding and dependencies
Plug 'nvim-lua/plenary.nvim'                                  " Plugin dependency for Telescope
Plug 'nvim-tree/nvim-web-devicons'                            " optional for icons
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }           " optional for the 'fzf' command
Plug 'linrongbin16/fzfx.nvim' ", { 'tag': 'v5.0.0' }          " Fuzzy Finder

" Tim Pope's Essential Plugins
Plug 'tpope/vim-fugitive'                                     " Git integration
Plug 'tpope/vim-surround'                                     " Plugin for surrounding text
Plug 'tpope/vim-commentary'                                   " Commenting plugin 
Plug 'tpope/vim-repeat'                                       " Repeat plugin
Plug 'tpope/vim-unimpaired'                                   " Unimpaired plugin

" Additional Quality of Life Improvements
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}   " Treesitter for syntax highlighting
Plug 'windwp/nvim-autopairs'                                  " Autopairs for auto closing brackets
Plug 'lukas-reineke/indent-blankline.nvim'                    " Indentation lines
Plug 'lewis6991/gitsigns.nvim'                                " Git signs
Plug 'wolandark/vim-piper'                                    " Text to speech
Plug 'machakann/vim-highlightedyank'                          " Highlight yanked text 
Plug 'm00qek/baleia.nvim'                                     " Colourful log messages
call plug#end()

" GitHub Copilot
let g:copilot_telemetry = v:false
let g:copilot_filetypes = {
            \ '*': v:false,
            \ 'python': v:true,
            \ 'typescript': v:true,
            \ 'javascript': v:true,
            \ 'clojure': v:true,
            \ 'sh': v:true,
            \ 'bash': v:true,
            \ 'zsh': v:true,
            \ 'vim': v:true,
            \ }
let g:copilot_model = 'gpt-4o'

" Leader Configuration
let mapleader = " "
let maplocalleader = ","

" Basic Settings
set relativenumber
set expandtab                         " Use spaces instead of tabs
set tabstop=4                         " Tab = 4 spaces
set shiftwidth=4                      " Tab = 4 spaces
set smartindent
set softtabstop=2                     " Number of spaces for a tab in insert mode
set autoindent                        " Auto indent
set smartindent                       " Smart autoindenting when starting a new line
set cindent                           " Stricter indenting rules for C-like languages
set indentexpr=                       " Let cindent handle indenting
set wrap                              " Wrap lines
set termguicolors
set signcolumn=yes
set updatetime=300
set completeopt=menu,menuone,noselect
set colorcolumn=100                   " Column indicating 100 characters
set cursorcolumn                      " Indentation guide
set cursorline
set ruler                             " Always show current position
set hlsearch                          " Highlight search results
set incsearch                         " Makes search act like search in modern browsers
set encoding=utf8                     " Set utf8 as standard encoding
set ffs=unix,dos,mac                  " Use Unix as the standard file type
set spell                             " Enable spell checking
set spelllang=en_gb
set clipboard+=unnamedplus             " Clipboard Settings
set background=dark                  " Set dark background

" Highlight on hover 
set updatetime=1000
autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
autocmd CursorHold,CursorHoldI * match none

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Code folding
" set foldmethod=indent " choices are: manual|indent|syntax|marker|expr
set foldmethod=expr
  \ foldexpr=lsp#ui#vim#folding#foldexpr()
  \ foldtext=lsp#ui#vim#folding#foldtext()

" Replace all instances selected in Visual mode, using Ctrl+r
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

set laststatus=2                      " Always show the status line
" Current mode
let g:currentmode={
    \ 'n'  : 'NORMAL',
    \ 'no' : 'NORMAL,OP',
    \ 'v'  : 'VISUAL',
    \ 'V'  : 'V-LINE',
    \ '^V' : 'V-BLOCK',
    \ 's'  : 'SELECT',
    \ 'S'  : 'S-LINE',
    \ '^S' : 'S-BLOCK',
    \ 'i'  : 'INSERT',
    \ 'R'  : 'REPLACE',
    \ 'Rv' : 'V-REPLACE',
    \ 'c'  : 'COMMAND',
    \ 'cv' : 'VIM EX',
    \ 'ce' : 'EX',
    \ 'r'  : 'PROMPT',
    \ 'rm' : 'MORE',
    \ 'r?' : 'CONFIRM',
    \ '!'  : 'SHELL',
    \ 't'  : 'TERMINAL'
    \}

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" Format the status line
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Get spell status
function! SpellStatus()
    if &spell
        return 'SPELL '
    endif
    return ''
endfunction

" Get relative CWD
function! GetRelCwd()
    let cwd = getcwd()
    let home = $HOME
    let cwd = substitute(cwd, home, '~', 'g')
    return cwd
endfunction

set statusline=\ %{HasPaste()}%{SpellStatus()}%F%m%r%h\ %w\ \ CWD:\ %r%{GetRelCwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
set statusline+=\ %{g:currentmode[mode()]}\  " The current mode

" piper TTS
let g:piper_bin = 'piperTTS'
let g:piper_voice = '/usr/share/piper-voices/alba.onnx'
nnoremap tw :call SpeakWord()
nnoremap tc :call SpeakCurrentLine()
nnoremap tp :call SpeakCurrentParagraph()
nnoremap tf :call SpeakCurrentFile()
vnoremap tv :call SpeakVisualSelection()

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" Spelling mistakes will be coloured up red.
hi SpellBad cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellLocal cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellRare cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellCap cterm=underline ctermfg=203 guifg=#ff5f5f

" Theme Configuration
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

colorscheme vscode

" Conjure Configuration 
let g:conjure#client#python#stdio#command = 'ipython --matplotlib'
let g:conjure#client#sql#stdio = 'sqlite3'
let g:conjure#log#wrap = 1 
let g:conjure#log#fold#enabled = 1
let g:conjure#preview#sample_limit = 1.0
let g:conjure#log#hud#height = 0.5
let g:conjure#log#hud#border = 0

" Conjure with Baleia Configuration
let g:conjure#log#strip_ansi_escape_sequences_line_limit = 0
let s:baleia = luaeval("require('baleia').setup { line_starts_at = 3 }")
autocmd BufWinEnter conjure-log-* call s:baleia.automatically(bufnr('%'))

" Autopairs Configuration
lua << EOF
require("nvim-autopairs").setup {}
EOF

" Indent Blankline Configuration
lua << EOF
require("ibl").setup()
EOF

" Mason Configuration
lua << EOF
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",                -- Lua
    "clojure_lsp",           -- Clojure
    "pyright",               -- Python
    "denols",                -- Deno
    "dockerls",              -- Docker
    "markdown_oxide",        -- Markdown
    "bashls",                -- Bash
  },
  automatic_installation = true,
})
EOF

" Completion setup
lua << EOF
-- Completion Setup
local cmp = require('cmp')
cmp.setup({
   snippet = {
     -- REQUIRED - you must specify a snippet engine
     expand = function(args)
     -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
     -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
     -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
     -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
     vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
   end,
   },
   window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  })
})
EOF

" LSP Configuration
lua << EOF
vim.lsp.set_log_level("DEBUG")  -- Temporarily enable debug logging
function _G.dump_lsp_client()
    local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
    for _, client in pairs(buf_clients) do
        print(string.format("Client: %s, Resolved capabilities:", client.name))
        print(vim.inspect(client.resolved_capabilities))
    end
end

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
})

-- Signs for better visibility
local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "🛈" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Proper file type detection
vim.cmd([[
  augroup python_lsp
    autocmd!
    autocmd FileType python lua vim.diagnostic.enable(0)
    autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc
  augroup END
]])

-- Add this before your LSP configurations
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'K', function()
            local winid = require('vim.lsp.util').open_floating_preview(
                {'Fetching documentation...'}, 'markdown', {
                    border = 'rounded',
                    focusable = false,
                })
            vim.lsp.buf.hover()
        end, opts)
    end,
})

-- LSP Configuration
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

-- LSP Keybindings
local on_attach = function(client, bufnr)
  print("LSP attached:", client.name)  -- Debug print
  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

-- Language specific Setup
lspconfig.clojure_lsp.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "clojure-lsp" },
  filetypes = { "clojure", "edn" },
  root_dir = lspconfig.util.root_pattern("deps.edn", "project.clj", "project.clj.edn", ".git"),
})

lspconfig.pyright.setup({
    on_attach = function(client, bufnr)
        print("Pyright attached to buffer:", bufnr)  -- Debug print
        
        -- Enable hover explicitly
        client.server_capabilities.hoverProvider = true
        
        -- Call your existing on_attach
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true
            }
        }
    },
    flags = {
        debounce_text_changes = 150,
    }
})

lspconfig.denols.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
  init_options = {
    enable = true,
    lint = true,
    unstable = true,
    suggest = {
      imports = {
        hosts = {
          ["https://deno.land"] = true,
          ["https://cdn.nest.land"] = true,
          ["https://crux.land"] = true
        }
      }
    }
  }
})

lspconfig.dockerls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "Dockerfile", "dockerfile" },
  root_dir = lspconfig.util.root_pattern("Dockerfile", ".git"),
})

lspconfig.markdown_oxide.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "markdown", "markdown.mdx" },
  root_dir = lspconfig.util.root_pattern(".git"),
})

lspconfig.bashls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "sh", "bash", "zsh" },
  root_dir = lspconfig.util.root_pattern(".git"),
})
EOF

" Configure diagnostic display
lua << EOF
-- Configure diagnostic display
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = true,
    border = "single",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Add better UI for diagnostics
local signs = { Error = "x", Warn = "!", Hint = ">", Info = "i" }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Mapping to manually trigger signature help
vim.keymap.set('n', '<leader>s', function()
  vim.lsp.buf.signature_help()
end, { noremap = true, silent = true })
EOF

" Linting and Formatting Configuration
lua << EOF
-- Linting Configuration
require('lint').linters_by_ft = {
  clojure = {'clj-kondo'},
  python = {'ruff'},
}

-- Auto-trigger linting
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

-- Formatting Configuration
require("conform").setup({
  -- Formatters for your languages
  formatters_by_ft = {
    python = { "ruff_format" },
    clojure = { "cljfmt" },
    javascript = { "deno_fmt" },
    typescript = { "deno_fmt" },
    lua = { "stylua" },
  },

  -- Format on save
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },

  -- For format on key mapping (optional, if you want manual formatting)
  vim.keymap.set({ "n", "v" }, "<leader>f", function()
    require("conform").format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
    })
  end, { desc = "Format file or range" })
})
EOF

" nvim-treesitter Configuration
lua << EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        -- Essential ones for Neovim itself
        "vim",
        "vimdoc",
        "query",

        -- Languages you use
        "python",
        "clojure",
        "lua",
        "typescript", -- for Deno/TypeScript
        "javascript", -- for Deno/JavaScript

        -- For documentation/markdown files
        "markdown",
        "markdown_inline"
        },

  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
    additional_vim_regex_highlighting = false,
  },

  -- Optional but recommended
  indent = {
    enable = true,
  },
  
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
EOF


" Fuzzy finding Configuration 
lua << EOF
require('fzfx').setup()
-- ======== files ========
-- by args
vim.keymap.set(
  "n",
  "<space>f",
  "<cmd>FzfxFiles<cr>",
  { silent = true, noremap = true, desc = "Find files" }
)
-- by visual select
vim.keymap.set(
  "x",
  "<space>f",
  "<cmd>FzfxFiles visual<CR>",
  { silent = true, noremap = true, desc = "Find files" }
)
-- by cursor word
vim.keymap.set(
  "n",
  "<space>wf",
  "<cmd>FzfxFiles cword<cr>",
  { silent = true, noremap = true, desc = "Find files by cursor word" }
)
-- by yank text
vim.keymap.set(
  "n",
  "<space>pf",
  "<cmd>FzfxFiles put<cr>",
  { silent = true, noremap = true, desc = "Find files by yank text" }
)
-- by resume
vim.keymap.set(
  "n",
  "<space>rf",
  "<cmd>FzfxFiles resume<cr>",
  { silent = true, noremap = true, desc = "Find files by resume last" }
)

-- ======== live grep ========
-- live grep
vim.keymap.set(
  "n",
  "<space>l",
  "<cmd>FzfxLiveGrep<cr>",
  { silent = true, noremap = true, desc = "Live grep" }
)
-- by visual select
vim.keymap.set(
  "x",
  "<space>l",
  "<cmd>FzfxLiveGrep visual<cr>",
  { silent = true, noremap = true, desc = "Live grep" }
)
-- by cursor word
vim.keymap.set(
  "n",
  "<space>wl",
  "<cmd>FzfxLiveGrep cword<cr>",
  { silent = true, noremap = true, desc = "Live grep by cursor word" }
)
-- by yank text
vim.keymap.set(
  "n",
  "<space>pl",
  "<cmd>FzfxLiveGrep put<cr>",
  { silent = true, noremap = true, desc = "Live grep by yank text" }
)
-- by resume
vim.keymap.set(
  "n",
  "<space>rl",
  "<cmd>FzfxLiveGrep resume<cr>",
  { silent = true, noremap = true, desc = "Live grep by resume last" }
)

-- ======== buffers ========
-- by args
vim.keymap.set(
  "n",
  "<space>bf",
  "<cmd>FzfxBuffers<cr>",
  { silent = true, noremap = true, desc = "Find buffers" }
)

-- ======== git files ========
-- by args
vim.keymap.set(
  "n",
  "<space>gf",
  "<cmd>FzfxGFiles<cr>",
  { silent = true, noremap = true, desc = "Find git files" }
)

-- ======== git live grep ========
-- by args
vim.keymap.set(
  "n",
  "<space>gl",
  "<cmd>FzfxGLiveGrep<cr>",
  { silent = true, noremap = true, desc = "Git live grep" }
)
-- by visual select
vim.keymap.set(
  "x",
  "<space>gl",
  "<cmd>FzfxGLiveGrep visual<cr>",
  { silent = true, noremap = true, desc = "Git live grep" }
)
-- by cursor word
vim.keymap.set(
  "n",
  "<space>wgl",
  "<cmd>FzfxGLiveGrep cword<cr>",
  { silent = true, noremap = true, desc = "Git live grep by cursor word" }
)
-- by yank text
vim.keymap.set(
  "n",
  "<space>pgl",
  "<cmd>FzfxGLiveGrep put<cr>",
  { silent = true, noremap = true, desc = "Git live grep by yank text" }
)
-- by resume
vim.keymap.set(
  "n",
  "<space>rgl",
  "<cmd>FzfxGLiveGrep resume<cr>",
  { silent = true, noremap = true, desc = "Git live grep by resume last" }
)

-- ======== git changed files (status) ========
-- by args
vim.keymap.set(
  "n",
  "<space>gs",
  "<cmd>FzfxGStatus<cr>",
  { silent = true, noremap = true, desc = "Find git changed files (status)" }
)

-- ======== git branches ========
-- by args
vim.keymap.set(
  "n",
  "<space>br",
  "<cmd>FzfxGBranches<cr>",
  { silent = true, noremap = true, desc = "Search git branches" }
)

-- ======== git commits ========
-- by args
vim.keymap.set(
  "n",
  "<space>gc",
  "<cmd>FzfxGCommits<cr>",
  { silent = true, noremap = true, desc = "Search git commits" }
)

-- ======== git blame ========
-- by args
vim.keymap.set(
  "n",
  "<space>gb",
  "<cmd>FzfxGBlame<cr>",
  { silent = true, noremap = true, desc = "Search git blame" }
)

-- ======== lsp diagnostics ========
-- by args
vim.keymap.set(
  "n",
  "<space>dg",
  "<cmd>FzfxLspDiagnostics<cr>",
  { silent = true, noremap = true, desc = "Search lsp diagnostics" }
)

-- ======== lsp symbols ========
-- lsp definitions
vim.keymap.set(
  "n",
  "<space>gd",
  "<cmd>FzfxLspDefinitions<cr>",
  { silent = true, noremap = true, desc = "Goto lsp definitions" }
)

-- lsp type definitions
vim.keymap.set(
  "n",
  "<space>gt",
  "<cmd>FzfxLspTypeDefinitions<cr>",
  { silent = true, noremap = true, desc = "Goto lsp type definitions" }
)

-- lsp references
vim.keymap.set(
  "n",
  "<space>gr",
  "<cmd>FzfxLspReferences<cr>",
  { silent = true, noremap = true, desc = "Goto lsp references" }
)

-- lsp implementations
vim.keymap.set(
  "n",
  "<space>gi",
  "<cmd>FzfxLspImplementations<cr>",
  { silent = true, noremap = true, desc = "Goto lsp implementations" }
)

-- lsp incoming calls
vim.keymap.set(
  "n",
  "<space>gI",
  "<cmd>FzfxLspIncomingCalls<cr>",
  { silent = true, noremap = true, desc = "Goto lsp incoming calls" }
)

-- lsp outgoing calls
vim.keymap.set(
  "n",
  "<space>gO",
  "<cmd>FzfxLspOutgoingCalls<cr>",
  { silent = true, noremap = true, desc = "Goto lsp outgoing calls" }
)

-- ======== vim commands ========
-- by args
vim.keymap.set(
  "n",
  "<space>cm",
  "<cmd>FzfxCommands<cr>",
  { silent = true, noremap = true, desc = "Search vim commands" }
)

-- ======== vim key maps ========

-- by args
vim.keymap.set(
  "n",
  "<space>km",
  "<cmd>FzfxKeyMaps<cr>",
  { silent = true, noremap = true, desc = "Search vim keymaps" }
)

-- ======== vim marks ========
-- by args
vim.keymap.set(
  "n",
  "<space>mk",
  "<cmd>FzfxMarks<cr>",
  { silent = true, noremap = true, desc = "Search vim marks" }
)

-- ======== file explorer ========
-- by args
vim.keymap.set(
  "n",
  "<space>xp",
  "<cmd>FzfxFileExplorer<cr>",
  { silent = true, noremap = true, desc = "File explorer" }
)
EOF

