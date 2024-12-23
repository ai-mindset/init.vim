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
Plug 'PaterJason/cmp-conjure'                                 " Clojure completion
Plug 'hrsh7th/cmp-nvim-lsp'                                   " LSP completion
Plug 'hrsh7th/cmp-buffer'                                     " Buffer completion 
Plug 'hrsh7th/cmp-cmdline'                                    " Command line completion
Plug 'hrsh7th/cmp-path'                                       " Path completion

" GitHub Copilot
Plug 'github/copilot.vim'                                     " GitHub Copilot

" Clojure Development
Plug 'Olical/conjure'                                         " Clojure REPL 
Plug 'guns/vim-sexp'                                          " Clojure S-Expression 
Plug 'tpope/vim-sexp-mappings-for-regular-people'             " Clojure S-Expression Mappings 

" Theme
Plug 'Mofiqul/vscode.nvim'

" Telescope and dependencies
Plug 'nvim-lua/plenary.nvim'                                  " Plugin dependency for Telescope
Plug 'nvim-telescope/telescope.nvim'                          " Plugin for fuzzy finding

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

" which-key
Plug 'folke/which-key.nvim'                                   " which-key for keybindings
Plug 'echasnovski/mini.icons'                                 " Mini icons for which-key
Plug 'nvim-tree/nvim-web-devicons'                            " icons for nvim-tree
call plug#end()

" Disable old which-key spec warning
let g:which_key_disable_health_check = 1

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
let mapleader = ","
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
set clipboard=unnamedplus             " Clipboard Settings
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
    "jedi_language_server",  -- Python
    "denols",                -- Deno
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
-- LSP Configuration
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

-- LSP Keybindings
local on_attach = function(client, bufnr)
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

lspconfig.jedi_language_server.setup({
  on_attach = function(client, bufnr)
    -- Print capabilities when server attaches
    -- print("Jedi capabilities:", vim.inspect(client.server_capabilities))
    
    local opts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
  capabilities = capabilities,
  init_options = {
    hover = {
      enabled = true,
    },
    completion = {
      enabled = true,
      include_params = true,
    },
  },
  settings = {
    -- Enable Jedi's hover
    jedi = {
      enable = true,
      hover = {
        enabled = true,
      },
    },
  },
})

-- Create custom hover handler
vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
  config = config or {}
  config.focus = true
  config.border = "single"
  
  if not result or not result.contents then
    -- print for debugging
    print("No hover content received")
    return
  end

  -- print for debugging
  print("Hover content:", vim.inspect(result.contents))
  
  local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
  markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
  
  if vim.tbl_isempty(markdown_lines) then
    -- print for debugging
    print("No markdown lines after conversion")
    return
  end

  return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
end

-- Add a custom hover handler for better formatting
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "single",
    max_width = 80,
    -- Set focus to floating window
    focusable = true,
    -- Position the hover window at cursor
    anchor = "NW",
    -- Prevent the hover window from printing to REPL
    silent = true,
    -- Format the docstring as markdown
    format = function(contents)
      return vim.lsp.util.convert_input_to_markdown_lines(contents)
    end
  }
)

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
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
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


" Telescope + which-key Configuration with mini icons
lua << EOF
-- Define custom icons (with trailing spaces for better spacing)
local icons = {
  File = "📄 ",
  Search = "🔍 ",
  Git = "⎇  ",
  Folder = "📁 ",
  LSP = "⚡ "
}

local wk = require("which-key")

wk.add({
  f = {
    name = icons.File .. "Find/Files",
    f = { "<cmd>Telescope find_files<cr>", icons.File .. "Find files in project" },
    g = { "<cmd>Telescope live_grep<cr>", icons.Search .. "Search for string in project" },
    b = { "<cmd>Telescope buffers<cr>", icons.Folder .. "Show open buffers" },
    h = { "<cmd>Telescope help_tags<cr>", icons.Search .. "Search help documentation" },
    r = { "<cmd>Telescope oldfiles<cr>", icons.File .. "Show recently opened files" },
    w = { "<cmd>Telescope grep_string<cr>", icons.Search .. "Search word under cursor" },
    o = { "<cmd>Telescope treesitter<cr>", icons.LSP .. "Show code outline/structure" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", icons.LSP .. "Show LSP symbols" },
  },
  g = {
    name = icons.Git .. "Git",
    c = { "<cmd>Telescope git_commits<cr>", icons.Git .. "Browse git commits" },
    b = { "<cmd>Telescope git_branches<cr>", icons.Git .. "Browse git branches" },
    s = { "<cmd>Telescope git_status<cr>", icons.Git .. "Show git status" },
    f = { "<cmd>Telescope git_files<cr>", icons.Git .. "Search git files" },
  },
}, { prefix = "<leader>" })

-- Minimal which-key setup without any default icons
wk.setup({
  icons = {
    breadcrumb = "",
    separator = "",
    group = "",
    mappings = false,
    rules = false,
    keys = {
      -- Explicitly set all key icons to empty strings
      Up = "",
      Down = "",
      Left = "",
      Right = "",
      C = "",
      M = "",
      D = "",
      S = "",
      CR = "",
      Esc = "",
      ScrollWheelDown = "",
      ScrollWheelUp = "",
      NL = "",
      BS = "",
      Space = "",
      Tab = "",
      F1 = "",
      F2 = "",
      F3 = "",
      F4 = "",
      F5 = "",
      F6 = "",
      F7 = "",
      F8 = "",
      F9 = "",
      F10 = "",
      F11 = "",
      F12 = ""
    }  
  },
  plugins = {
    presets = false  
  },
  window = {
    border = "single",
    margin = { 1, 0, 1, 0 },
    padding = { 1, 2, 1, 2 },
  },
  layout = {
    align = "left",
  },
})
EOF

