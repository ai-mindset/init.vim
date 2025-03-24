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
"Plug 'github/copilot.vim'                                     " GitHub Copilot

" Local LLM completion
Plug 'nomnivore/ollama.nvim'                                  " LLM completion

" Clojure Development
Plug 'Olical/conjure'                                         " Clojure REPL 
Plug 'PaterJason/cmp-conjure'                                 " Clojure completion
Plug 'guns/vim-sexp'                                          " Clojure S-Expression 
Plug 'tpope/vim-sexp-mappings-for-regular-people'             " Clojure S-Expression Mappings 

" Go Development 
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }            " Go development

" Zig development
Plug 'ziglang/zig.vim'                                        " Zig development

" Vim <-> IPython
Plug 'jpalardy/vim-slime', { 'for': 'python' }                " Send to REPL 
Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }         " Vim <-> IPython

" CSV viewer
Plug 'hat0uma/csvview.nvim'                                   " A Neovim plugin for CSV file editing.

" Theme
Plug 'Mofiqul/vscode.nvim'
Plug 'projekt0n/github-nvim-theme'

" Fuzzy finding and dependencies
Plug 'nvim-lua/plenary.nvim'                                  " Plugin dependency
Plug 'nvim-tree/nvim-web-devicons'                            " optional for icons
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }           " optional for the 'fzf' command
Plug 'junegunn/fzf.vim'                                       " fzf vim bindings

" Essential Plugins
Plug 'tpope/vim-surround'                                     " Plugin for surrounding text
Plug 'tpope/vim-commentary'                                   " Commenting plugin 
Plug 'tpope/vim-repeat'                                       " Repeat plugin
Plug 'tpope/vim-unimpaired'                                   " Unimpaired plugin

" Git
Plug 'tpope/vim-fugitive'                                     " Git integration
Plug 'lewis6991/gitsigns.nvim'                                " Git signs
Plug 'sindrets/diffview.nvim'                                 " Easily cycling through diffs for all modified files for any git rev 

" Additional Quality of Life Improvements
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}   " Treesitter for syntax highlighting
Plug 'wellle/context.vim'                                     " Shows the context of the currently visible buffer contents  
Plug 'windwp/nvim-autopairs'                                  " Autopairs for auto closing brackets
Plug 'lukas-reineke/indent-blankline.nvim'                    " Indentation lines
Plug 'wolandark/vim-piper'                                    " Text to speech
Plug 'machakann/vim-highlightedyank'                          " Highlight yanked text 
Plug 'm00qek/baleia.nvim'                                     " Colourful log messages
Plug 'ellisonleao/glow.nvim'                                  " Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'preservim/tagbar'                                       " Displays tags in a window, ordered by scope
Plug 'jakobkhansen/journal.nvim'                              " Keep notes
Plug 'folke/which-key.nvim'                                   " Helps you remember your Neovim keymaps
call plug#end()

""" GitHub Copilot -- leaving in, in case I reactivate Copilot
let g:copilot_enabled = v:false
let g:copilot_telemetry = v:false
let g:copilot_filetypes = {
            \ "*": v:false,
            \ "python": v:true,
            \ "go": v:true,
            \ "javascript": v:true,
            \ "typescript": v:true,
            \ "clojure": v:true,
            \ }
let g:copilot_model = "claude3.5-sonnet" " or "gpt-4o"
""" GitHub Copilot

""" ollama.nvim configuration
lua << EOF
local opts = {
  model = "qwen2.5-coder:14b-instruct-q4_K_M",
  url = "http://127.0.0.1:11434",
  serve = {
    on_start = false,
    command = "ollama",
    args = { "serve" },
    stop_command = "pkill",
    stop_args = { "-SIGTERM", "ollama" },
  }
}
require("ollama").setup(opts)

vim.keymap.set("i", "<C-x><C-o>", function()
    require("cmp").complete({
        config = {
            sources = {
                { name = "ollama" },
                { name = "path"},
            }
        }
    })
end)
EOF
""" ollama.nvim configuration

""" journal.nvim
lua << EOF
local opts = {
    filetype = 'md',                    -- Filetype to use for new journal entries
    root = '~/journal',                 -- Root directory for journal entries
    date_format = '%d/%m/%Y',           -- Date format for `:Journal <date-modifier>`
    autocomplete_date_modifier = "end", -- "always"|"never"|"end". Enable date modifier autocompletion

    -- Configuration for journal entries
    journal = {
        -- Default configuration for `:Journal <date-modifier>`
        format = '%Y/%m-%B/daily/%d-%A',
        template = '# %A %B %d %Y\n',
        frequency = { day = 1 },

        -- Nested configurations for `:Journal <type> <type> ... <date-modifier>`
        entries = {
            day = {
                format = '%Y/%m-%B/daily/%d-%A', -- Format of the journal entry in the filesystem.
                template = '# %A %B %d %Y\n',    -- Optional. Template used when creating a new journal entry
                frequency = { day = 1 },         -- Optional. The frequency of the journal entry. Used for `:Journal next`, `:Journal -2` etc
            },
            week = {
                format = '%Y/%m-%B/weekly/week-%W',
                template = "# Week %W %B %Y\n",
                frequency = { day = 7 },
                date_modifier = "monday" -- Optional. Date modifier applied before other modifier given to `:Journal`
            },
            month = {
                format = '%Y/%m-%B/%B',
                template = "# %B %Y\n",
                frequency = { month = 1 }
            },
            year = {
                format = '%Y/%Y',
                template = "# %Y\n",
                frequency = { year = 1 }
            },
        },
    }
}
require("journal").setup(opts)
EOF
""" journal.nvim

" Leader Configuration
let mapleader = " "
let maplocalleader = ","

""" Basic Settings
set relativenumber
set expandtab                         " Use spaces instead of tabs
set tabstop=4                         " Tab = 4 spaces
set shiftwidth=4                      " Tab = 4 spaces
set softtabstop=2                     " Number of spaces for a tab in insert mode
set autoindent                        " Auto indent
set smartindent                       " Smart autoindenting when starting a new line
set cindent                           " Stricter indenting rules for C-like languages
set indentexpr=                       " Let cindent handle indenting
set wrap                              " Wrap lines
set signcolumn=yes
set updatetime=300
set completeopt=menu,menuone,noselect
set colorcolumn=90                   " Column indicating 100 characters
set cursorcolumn                      " Indentation guide
set cursorline
set ruler                             " Always show current position
set hlsearch                          " Highlight search results
set incsearch                         " Makes search act like search in modern browsers
set encoding=utf8                     " Set utf8 as standard encoding
set ffs=unix,dos,mac                  " Use Unix as the standard file type
set spell                             " Enable spell checking
set spelllang=en_gb
set clipboard+=unnamedplus            " Clipboard Settings
set background=dark                   " Set dark background
set t_Co=256                          " 256 colours
set termguicolors                     " True colour support

colorscheme github_dark_high_contrast


""" Basic Settings

"" Highlight on hover 
set updatetime=1000
autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
autocmd CursorHold,CursorHoldI * match none
"" Highlight on hover 

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>
"
" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>


""" Statusline configuration
set laststatus=3                     " Global statusline (Neovim only)
set noshowmode                       " Don't show mode in command line

" Mode dictionary with simpler names
let g:currentmode = {
    \ 'n'  : 'NORMAL',
    \ 'no' : 'N·OP',
    \ 'v'  : 'VISUAL',
    \ 'V'  : 'V·LINE',
    \ "\<C-V>" : 'V·BLOCK',  
    \ 's'  : 'SELECT',
    \ 'S'  : 'S·LINE',
    \ "\<C-S>" : 'S·BLOCK',  
    \ 'i'  : 'INSERT',
    \ 'R'  : 'REPLACE',
    \ 'Rv' : 'V·REPLACE',
    \ 'c'  : 'COMMAND',
    \ 't'  : 'TERMINAL'
\}

" More reliable mode function that doesn't depend on g:currentmode dictionary
function! CurrentMode()
    let l:mode = mode()
    return get(g:currentmode, l:mode, l:mode)
endfunction

" Simplified helper functions
function! StatusPaste()
    return &paste ? 'PASTE ' : ''
endfunction

function! StatusSpell()
    return &spell ? 'SPELL ' : ''
endfunction

" Cache virtual env name when it doesn't change often
let s:last_venv = ''
let s:venv_name = ''

function! StatusVenv()
    if exists('$VIRTUAL_ENV')
        let l:current_venv = $VIRTUAL_ENV
        if s:last_venv != l:current_venv
            let s:last_venv = l:current_venv
            let l:venv = fnamemodify(l:current_venv, ':t')
            let s:venv_name = l:venv ==# '.venv' ? fnamemodify(l:current_venv, ':h:t') : l:venv
        endif
        return s:venv_name
    endif
    let s:last_venv = ''
    return ''
endfunction

" Display path in ~/project/file.ext format
function! PWDPath()
    let l:full_path = expand('%:p')
    let l:home = $HOME
    
    " Replace home directory with tilde
    if l:full_path =~# '^' . l:home
        return '~' . l:full_path[len(l:home):]
    endif
    
    " If not under home, return the full path
    return l:full_path
endfunction

" More informative git status with branch and changes
function! GitInfo()
    if !exists('*FugitiveHead') || FugitiveHead() == ''
        return ''
    endif
    
    let l:branch = FugitiveHead()
    " Optional: Add status indicators if you have fugitive
    return ' branch:' . l:branch . ' '
endfunction

" Statusline colours - simplified to use a single setup function
function! SetupStatusline()
    " Define base colors
    let l:fg = '#F8F8F2'
    let l:bg_normal = '#005F87'
    let l:bg_insert = '#AF5F00'

    " Apply highlights using variables
    exe 'hi StModeNormal guifg=' . l:fg . ' guibg=' . l:bg_normal . ' gui=bold'

    " Define highlight groups with accessible, harmonious colours
    hi StModeNormal   guifg=#F8F8F2 guibg=#005F87 ctermfg=255 ctermbg=24  gui=bold  " Blue
    hi StModeInsert   guifg=#F8F8F2 guibg=#AF5F00 ctermfg=255 ctermbg=130 gui=bold  " Amber
    hi StModeVisual   guifg=#F8F8F2 guibg=#D70000 ctermfg=255 ctermbg=160 gui=bold  " Red
    hi StModeReplace  guifg=#F8F8F2 guibg=#8700AF ctermfg=255 ctermbg=91  gui=bold  " Purple
    hi StModeCommand  guifg=#F8F8F2 guibg=#005F5F ctermfg=255 ctermbg=23  gui=bold  " Teal
    
    hi StInfo         guifg=#F8F8F2 guibg=#3A3A3A ctermfg=255 ctermbg=237 gui=none  " Dark gray
    hi StPath         guifg=#F8F8F2 guibg=#005F87 ctermfg=255 ctermbg=24  gui=none  " Blue
    hi StGit          guifg=#F8F8F2 guibg=#5F8700 ctermfg=255 ctermbg=64  gui=none  " Green
    hi StVenv         guifg=#F8F8F2 guibg=#5F5F87 ctermfg=255 ctermbg=60  gui=none  " Slate
    hi StPosition     guifg=#F8F8F2 guibg=#3A3A3A ctermfg=255 ctermbg=237 gui=none  " Dark gray
    
    " Update statusline with dynamically coloured mode segment
    let &statusline = ''
    let &statusline .= 'mode:%{%StatuslineMode()%}'                                           " Mode with dynamic colours
    let &statusline .= '%#StInfo# fmt:%{&ff} state:%{StatusPaste()}%{StatusSpell()} '         " Format and states
    let &statusline .= '%#StPath# path:%{PWDPath()} ' " File path relative to home
    let &statusline .= '%#StGit#%{GitInfo()}%*'                                               " Git status
    let &statusline .= '%='                                                                   " Switch sides
    let &statusline .= '%#StVenv#%{StatusVenv()!=""?(" venv:(".StatusVenv().")"):""}'         " Virtual env if exists
    let &statusline .= '%#StPosition# Ln:%l Col:%c %p%% '                                     " Position info (clearer labels)
endfunction

" Dynamic mode colours function - more reliable
function! StatuslineMode()
    let l:mode = mode()
    
    " Set highlight based on mode
    if l:mode =~# '\v(n|no)'
        exe 'hi! link StatusLine StModeNormal'
        return 'NORMAL '
    elseif l:mode =~# '\v(i)'
        exe 'hi! link StatusLine StModeInsert'
        return 'INSERT '
    elseif l:mode =~# '\v(v|V|\<C-v>)'
        exe 'hi! link StatusLine StModeVisual'
        return 'VISUAL '
    elseif l:mode =~# '\v(R)'
        exe 'hi! link StatusLine StModeReplace'
        return 'REPLACE '
    elseif l:mode =~# '\v(c)'
        exe 'hi! link StatusLine StModeCommand'
        return 'COMMAND '
    else
        exe 'hi! link StatusLine StModeNormal'
        return '  ' . get(g:currentmode, l:mode, l:mode) . ' '
    endif
endfunction

" Initialize the statusline when vim starts and ensure it updates properly
augroup StatusLineSetup
    autocmd!
    autocmd VimEnter,ColorScheme * call SetupStatusline()
    
    " Only redraw on more specific events
    autocmd BufEnter,WinEnter,FileType,BufWritePost,TextChanged,InsertLeave * 
          \ if &laststatus > 0 | redrawstatus | endif
augroup END

" Call setup immediately
call SetupStatusline()
""" Statusline Configuration

""" piper TTS
let g:piper_bin = 'piperTTS'
let g:piper_voice = '/usr/share/piper-voices/en_GB-alba-medium.onnx'
                    " <space>tw = SpeakWord()
                    " <space>tc = SpeakCurrentLine()
                    " <space>tp = SpeakCurrentParagraph()
                    " <space>tf = SpeakCurrentFile()
                    " <space>tv = SpeakVisualSelection()
""" piper TTS

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

""" Shortcuts using <leader>
map <leader>sn ]s " Next spelling mistake    
map <leader>sp [s " Previous spelling mistake
map <leader>sa zg " Add word to dictionary
map <leader>s? z= " Get suggestions
""" Shortcuts using <leader>

""" Spelling mistakes will be coloured up red.
hi SpellBad cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellLocal cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellRare cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellCap cterm=underline ctermfg=203 guifg=#ff5f5f
""" Spelling mistakes will be coloured up red.

""" Conjure Configuration 
let g:conjure#client#python#stdio#command = "python -iq -m asyncio" " https://github.com/Olical/conjure/issues/545#issuecomment-1878879728
" SQLite
let g:conjure#client#sql#stdio = "sqlite3"
" HUD
let g:conjure#log#wrap = 1 
let g:conjure#log#fold#enabled = 1
let g:conjure#preview#sample_limit = 1.0
let g:conjure#log#hud#height = 0.5
let g:conjure#log#hud#border = 0
""" Conjure Configuration 

""" Conjure with Baleia Configuration
let g:conjure#log#strip_ansi_escape_sequences_line_limit = 0
let s:baleia = luaeval("require('baleia').setup { line_starts_at = 3 }")
autocmd BufWinEnter conjure-log-* call s:baleia.automatically(bufnr('%'))
""" Conjure with Baleia Configuration

""" Glow configurations
lua << EOF
require('glow').setup({
  glow_path = "/usr/bin/glow", -- will be filled automatically with your glow bin in $PATH, if any
  install_path = "/usr/bin", -- default path for installing glow binary
  border = "shadow", -- floating window border config
  style = "dark", -- filled automatically with your current editor background, you can override using glow json style
  pager = false,
  width = 80,
  height = 100,
  width_ratio = 0.7, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
  height_ratio = 0.7,
})
EOF
""" Glow configurations

""" tagbar
nmap <F8> :TagbarToggle<CR>
" https://github.com/preservim/tagbar/blob/d55d454bd3d5b027ebf0e8c75b8f88e4eddad8d8/doc/tagbar.txt#L512
let g:tagbar_left = 1
let g:tagbar_autoclose = 0
let g:tagbar_autofocus = 0 " If you set this option the cursor will move to the Tagbar window when it is opened
let g:tagbar_compact = 1 " 0: Show short help and blank lines between top-level scopes
                         " 1: Don't show the short help or the blank lines.
                         " 2: Don't show the short help but show the blank lines.
let g:tagbar_show_data_type = 1
let g:tagbar_show_linenumbers = 1
let g:tagbar_iconchars = ['▶', '▼']  " (default on Linux and Mac OS X)
" let g:tagbar_iconchars = ['▸', '▾']
" let g:tagbar_iconchars = ['▷', '◢']
autocmd BufEnter * nested :call tagbar#autoopen(0) " Auto-open tagbar
""" tagbar

" Autopairs Configuration
lua << EOF
require("nvim-autopairs").setup({})
EOF

" Indent Blankline Configuration
lua << EOF
require("ibl").setup()
EOF

""" Mason Configuration
lua << EOF
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "elixirls",              -- Elixir
    "clojure_lsp",           -- Clojure
    "pyright",               -- Python
    "zls",                   -- Zig
    "denols",                -- Deno
    "dockerls",              -- Docker
    "markdown_oxide",        -- Markdown
    "bashls",                -- Bash
    "biome",                 -- JSON
    "yamlls",               -- YAML
  },
  automatic_installation = true,
})
EOF
""" Mason Configuration

""" Completion setup
lua << EOF
-- Completion Setup
local cmp = require("cmp")
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
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path"},
  })
})
EOF
""" Completion setup

""" LSP Configuration
lua << EOF
vim.lsp.set_log_level("DEBUG")  -- Temporarily enable debug logging
function _G.dump_lsp_client()
    local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
    for _, client in pairs(buf_clients) do
        print(string.format("Client: %s, Resolved capabilities:", client.name))
        print(vim.inspect(client.resolved_capabilities))
    end
end

-- Add better UI for diagnostics
local signs = { Error = "x", Warn = "!", Hint = ">", Info = "i" }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
    globals = {"error", "warn"},
})

-- Show diagnostics when pressing 'gh'
vim.api.nvim_set_keymap('n', 'gh', ':lua vim.diagnostic.open_float(nil, {focus=false})<CR>', { silent = true })

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
  -- Debug print
  print("LSP attached:", client.name)
  
  -- Common options for most keymaps
  local opts = { noremap = true, silent = true }
  
  -- Navigation keymaps
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  
  -- Information keymaps
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  
  -- Editing keymaps
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  
  -- Rename keymaps (remove duplicate)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) 
end
  
-- Language specific Setup
lspconfig.clojure_lsp.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "clojure-lsp" },
  filetypes = { "clojure", "edn" },
  root_dir = lspconfig.util.root_pattern("deps.edn", "project.clj", "project.clj.edn", ".git"),
})

-- lspconfig.pyright.setup({
--   on_attach = function(client, bufnr)
--     print("Pyright attached to buffer:", bufnr)  -- Debug print
--   
--     -- Enable hover explicitly
--     client.server_capabilities.hoverProvider = true
--   
--     -- Call your existing on_attach
--     on_attach(client, bufnr)
--   end,
--   capabilities = capabilities,
--   settings = {
--     python = {
--       analysis = {
--         autoSearchPaths = true,
--         diagnosticMode = "workspace",
--         useLibraryCodeForTypes = true
--       }
--     }
--   },
--   flags = {
--     debounce_text_changes = 150,
--   }
-- })

-- Jedi setup for all Python language features
lspconfig.jedi_language_server.setup({
  on_attach = function(client, bufnr)
    -- Call your existing on_attach
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  init_options = {
    diagnostics = {
      enable = true,  -- Enable Jedi diagnostics
      didOpen = true,
      didChange = true,
      didSave = true,
    },
    completion = {
      disableSnippets = false,
      resolveEagerly = true,
    },
    hover = {
      enable = true,
    },
    jediSettings = {
      autoImportModules = {},  -- Add modules you want auto-imported
      caseInsensitiveCompletion = true,
      debug = false,
    },
  }
})
lspconfig.zls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern("build.zig.zon"),
  init_options = {
    enable = true,
    lint = true,
    unstable = true,
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

lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
EOF
""" LSP Configuration

""" Diagnostics configuration 
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

-- Mapping to manually trigger signature help
vim.keymap.set('n', '<leader>s', function()
  vim.lsp.buf.signature_help()
end, { noremap = true, silent = true })
EOF
""" Diagnostics configuration 

""" Linting and Formatting Configuration
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
    python = { "ruff_organise_imports", "ruff_format" },
    elixir = { "trivy" },
    clojure = { "cljfmt" },
    javascript = { "deno_fmt" },
    typescript = { "deno_fmt" },
    json = { "biome" },
  },

  -- Organise Python imports
    formatters = {
        ruff_organise_imports = {
          command = 'ruff',
          args = {
            'check',
            '--force-exclude',
            '--select=I001',
            '--fix',
            '--exit-zero',
            '--stdin-filename',
            '$FILENAME',
            '-',
          },
          stdin = true,
          cwd = require('conform.util').root_file {
            'pyproject.toml',
            'ruff.toml',
            '.ruff.toml',
          },
        },
      },
  -- Format on save

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

  -- For format on key mapping (optional, if you want manual formatting)
  vim.keymap.set({ "n", "v" }, "==", function()
    require("conform").format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
    })
  end, { desc = "Format file or range" })
EOF
""" Linting, formatting configuration 

""" nvim-treesitter Configuration
lua << EOF
require("nvim-treesitter.configs").setup {
    ensure_installed = {
        -- Essential ones for Neovim itself
        "vim",
        "vimdoc",
        "query",

        -- Languages you use
        "python",
        "clojure",
        "typescript", -- for Deno/TypeScript
        "javascript", -- for Deno/JavaScript

        -- For documentation/markdown files
        "markdown",
        "markdown_inline",
        
        -- For Yaml files
        "yaml"
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
  fold = {
      enable = true 
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

-- Code folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Start with all folds closed 
vim.opt.foldenable = false 
vim.opt.foldlevel = 99

-- Customize fold appearance (optional)
vim.opt.fillchars = "fold: "
vim.opt.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... '.trim(getline(v:foldend))]]
EOF
""" nvim-treesitter Configuration

""" context Configuration
let g:context_enabled = 1
""" context Configuration


""" Fuzzy finding Configuration 
let g:fzf_vim = {}
" This is the default option:
"   - Preview window on the right with 50% width
"   - CTRL-/ will toggle preview window.
let g:fzf_vim.preview_window = ['right,50%', 'ctrl-/']
" [Buffers] Jump to the existing window if possible (default: 0)
let g:fzf_vim.buffers_jump = 1
" [[B]Commits] Customize the options used by 'git log':
let g:fzf_vim.commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
"" Mappings
" Mapping selecting mappings
nmap <leader>k <plug>(fzf-maps-n)
xmap <leader>k <plug>(fzf-maps-x)
omap <leader>k <plug>(fzf-maps-o)
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
" files
nnoremap <leader>f :Files<cr>
"" Mappings
"" Completion
" Path completion with custom source command
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd')
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')
" Word completion with custom spec with popup layout option
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})
" Replace the default dictionary completion with fzf-based fuzzy completion
" inoremap <expr> <c-x><c-k> fzf#vim#complete('cat /usr/share/dict/words')
" Global line completion (not just open buffers. ripgrep required.)
inoremap <expr> <c-x><c-l> fzf#vim#complete(fzf#wrap({
  \ 'prefix': '^.*$',
  \ 'source': 'rg -n ^ --color always',
  \ 'options': '--ansi --delimiter : --nth 3..',
  \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))
"" Completion
" Statusline
autocmd! FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
""" Fuzzy finding Configuration 

""" vim-ipython-cell
"------------------------------------------------------------------------------
" slime configuration 
"------------------------------------------------------------------------------
" always use tmux
let g:slime_target = 'tmux'

" fix paste issues in ipython
let g:slime_python_ipython = 1

" always send text to the top-right pane in the current tmux tab without asking
let g:slime_default_config = {
            \ 'socket_name': get(split($TMUX, ','), 0),
            \ 'target_pane': '{top-right}' }

let g:slime_dont_ask_default = 1

"------------------------------------------------------------------------------
" ipython-cell configuration
"------------------------------------------------------------------------------
" Keyboard mappings. <Leader> is \ (backslash) by default

" map <Leader>s to start IPython
nnoremap <Leader>s :SlimeSend1 ipython --matplotlib<CR>

" map <Leader>r to run script
nnoremap <Leader>r :IPythonCellRun<CR>

" map <Leader>R to run script and time the execution
nnoremap <Leader>R :IPythonCellRunTime<CR>

" map <Leader>c to execute the current cell
nnoremap <Leader>c :IPythonCellExecuteCell<CR>

" map <Leader>C to execute the current cell and jump to the next cell
nnoremap <Leader>C :IPythonCellExecuteCellJump<CR>

" map <Leader>l to clear IPython screen
nnoremap <Leader>l :IPythonCellClear<CR>

" map <Leader>x to close all Matplotlib figure windows
nnoremap <Leader>x :IPythonCellClose<CR>

" map [c and ]c to jump to the previous and next cell header
nnoremap [c :IPythonCellPrevCell<CR>
nnoremap ]c :IPythonCellNextCell<CR>

" map <Leader>h to send the current line or current selection to IPython
nmap <Leader>h <Plug>SlimeLineSend
xmap <Leader>h <Plug>SlimeRegionSend

" map <Leader>p to run the previous command
nnoremap <Leader>p :IPythonCellPrevCommand<CR>

" map <Leader>Q to restart ipython
nnoremap <Leader>Q :IPythonCellRestart<CR>

" map <Leader>d to start debug mode
nnoremap <Leader>d :SlimeSend1 %debug<CR>

" map <Leader>q to exit debug mode or IPython
nnoremap <Leader>q :SlimeSend1 exit<CR>

" map <F9> and <F10> to insert a cell header tag above/below and enter insert mode
nmap <F9> :IPythonCellInsertAbove<CR>a
nmap <F10> :IPythonCellInsertBelow<CR>a

" also make <F9> and <F10> work in insert mode
imap <F9> <C-o>:IPythonCellInsertAbove<CR>
imap <F10> <C-o>:IPythonCellInsertBelow<CR>
""" vim-ipython-cell

""" CSV viewer  
lua << EOF
require('csvview').setup()
EOF
""" CSV viewer  

""" Align sentences
lua << EOF
function _G.align_sentences(start_line, end_line)
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local all_parts = {}
  local max_lengths = {}
  
  -- Step 1: Split each line and analyze lengths
  for _, line in ipairs(lines) do
    local parts = {}
    local pos = 1
    local part_start = 1
    
    -- Split by period followed by whitespace
    while true do
      local period_pos = line:find('%.[%s]+', pos)
      if not period_pos then break end
      
      local part = line:sub(part_start, period_pos)
      table.insert(parts, part)
      
      pos = period_pos + 2
      part_start = pos
    end
    
    -- Add the final part if it exists
    if part_start <= #line then
      table.insert(parts, line:sub(part_start))
    end
    
    table.insert(all_parts, parts)
    
    -- Track maximum length for each column
    for i, part in ipairs(parts) do
      max_lengths[i] = math.max(max_lengths[i] or 0, vim.fn.strwidth(part) + 1)
    end
  end
  
  -- Step 2: Format each line with proper padding
  local result_lines = {}
  for _, parts in ipairs(all_parts) do
    local formatted = ""
    
    for i, part in ipairs(parts) do
      -- Add period if it doesn't end with one
      if not part:match('%.%s*$') then
        part = part .. '.'
      end
      
      -- Add appropriate padding except for the last column
      if i < #parts then
        local padding = max_lengths[i] - vim.fn.strwidth(part)
        formatted = formatted .. part .. string.rep(' ', padding + 1)
      else
        formatted = formatted .. part
      end
    end
    
    table.insert(result_lines, formatted)
  end
  
  -- Step 3: Replace the original lines
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, result_lines)
end

-- Create a command to call the Lua function
vim.cmd([[
  command! -range AlignSentences lua _G.align_sentences(<line1>, <line2>)
]])
EOF
""" Align sentences 

""" Git 
lua << EOF
require('gitsigns').setup({
  current_line_blame = true,
  signs = {
    add = { text = '│' },
    change = { text = '│' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    
    -- Navigation between hunks
    vim.keymap.set('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true, buffer=bufnr})
    
    vim.keymap.set('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true, buffer=bufnr})
    
    -- Actions
    vim.keymap.set('n', '<leader>hs', gs.stage_hunk)
    vim.keymap.set('n', '<leader>hr', gs.reset_hunk)
    vim.keymap.set('n', '<leader>hp', gs.preview_hunk)
  end
})

require('diffview').setup({
  enhanced_diff_hl = true,
  use_icons = true,
  view = {
    default = {
      layout = "diff2_horizontal",
    },
    merge_tool = {
      layout = "diff3_horizontal",
      disable_diagnostics = true,
    },
  },
  keymaps = {
    view = {
      ["<tab>"] = function() vim.cmd("DiffviewToggleFiles") end,
      ["co"] = "<Cmd>DiffviewOpen<CR>",            -- Open diffview
      ["cc"] = "<Cmd>DiffviewClose<CR>",           -- Close diffview
    },
    file_panel = {
      ["co"] = "open",                             -- Open
      ["cc"] = "close",                            -- Close
    },
    file_history_panel = {
      ["co"] = "open",                             -- Open
      ["cc"] = "close",                            -- Close
    },
  },
})
EOF
""" Git 

""" which-key configuration
lua << EOF
-- Which-Key Configuration
local wk = require("which-key")

-- Basic setup with corrected delay configuration
wk.setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = false,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },

  replace = {
    ["<space>"] = "SPC",
    ["<cr>"] = "RET",
    ["<tab>"] = "TAB",
  },

  win = {
    border = "single",
    padding = { 2, 2, 2, 2 },
  },
  layout = {
    height = { min = 4, max = 25 },
    width = { min = 20, max = 50 },
    spacing = 3,
    align = "center",
  },

  -- FIX: Simple delay setting
  delay = 100
})

-- Define conflict resolution functions in global scope
_G.conflict = {}

-- Open conflicts in diffview
_G.conflict.open_conflicts = function()
  if vim.fn.search('<<<<<<< ', 'n') > 0 then
    vim.cmd('DiffviewOpen --merge')
  else
    vim.notify('No merge conflicts found', vim.log.levels.INFO)
  end
end

-- More reliable method to handle conflict resolution
_G.conflict.accept_current = function()
  -- Find conflict markers
  local pos = vim.fn.getpos(".")
  local start = vim.fn.search('<<<<<<< ', 'bcn')
  
  if start <= 0 then
    start = vim.fn.search('<<<<<<< ', 'cn')
    if start <= 0 then
      vim.notify('No conflict marker found', vim.log.levels.ERROR)
      return
    end
  end
  
  local middle = vim.fn.search('=======', 'cn')
  local end_marker = vim.fn.search('>>>>>>> ', 'cn')
  
  if start > 0 and middle > 0 and end_marker > 0 then
    -- Keep the current changes (lines between <<<<<<< and =======)
    local ours = vim.fn.getline(start + 1, middle - 1)
    
    -- Delete the entire conflict block
    vim.fn.deletebufline(vim.fn.bufnr(), start, end_marker)
    
    -- Insert our changes
    if #ours > 0 then
      vim.fn.append(start - 1, ours)
    end
    
    -- Restore cursor position as best we can
    vim.fn.setpos(".", pos)
    vim.notify('Kept current changes', vim.log.levels.INFO)
  else
    vim.notify('Conflict markers not found in expected format', vim.log.levels.ERROR)
  end
end

-- Accept incoming changes
_G.conflict.accept_incoming = function()
  -- Find conflict markers
  local pos = vim.fn.getpos(".")
  local start = vim.fn.search('<<<<<<< ', 'bcn')
  
  if start <= 0 then
    start = vim.fn.search('<<<<<<< ', 'cn')
    if start <= 0 then
      vim.notify('No conflict marker found', vim.log.levels.ERROR)
      return
    end
  end
  
  local middle = vim.fn.search('=======', 'cn')
  local end_marker = vim.fn.search('>>>>>>> ', 'cn')
  
  if start > 0 and middle > 0 and end_marker > 0 then
    -- Keep the incoming changes (lines between ======= and >>>>>>>)
    local theirs = vim.fn.getline(middle + 1, end_marker - 1)
    
    -- Delete the entire conflict block
    vim.fn.deletebufline(vim.fn.bufnr(), start, end_marker)
    
    -- Insert their changes
    if #theirs > 0 then
      vim.fn.append(start - 1, theirs)
    end
    
    -- Restore cursor position as best we can
    vim.fn.setpos(".", pos)
    vim.notify('Kept incoming changes', vim.log.levels.INFO)
  else
    vim.notify('Conflict markers not found in expected format', vim.log.levels.ERROR)
  end
end

-- Accept both changes
_G.conflict.accept_both = function()
  -- Find conflict markers
  local pos = vim.fn.getpos(".")
  local start = vim.fn.search('<<<<<<< ', 'bcn')
  
  if start <= 0 then
    start = vim.fn.search('<<<<<<< ', 'cn')
    if start <= 0 then
      vim.notify('No conflict marker found', vim.log.levels.ERROR)
      return
    end
  end
  
  local middle = vim.fn.search('=======', 'cn')
  local end_marker = vim.fn.search('>>>>>>> ', 'cn')
  
  if start > 0 and middle > 0 and end_marker > 0 then
    -- Get both parts
    local ours = vim.fn.getline(start + 1, middle - 1)
    local theirs = vim.fn.getline(middle + 1, end_marker - 1)
    
    -- Delete the conflict markers and insert both changes
    vim.fn.deletebufline(vim.fn.bufnr(), start, end_marker)
    
    -- Add both changes
    if #theirs > 0 then
      vim.fn.append(start - 1, theirs)
    end
    if #ours > 0 then
      vim.fn.append(start - 1, ours)
    end
    
    -- Restore cursor position as best we can
    vim.fn.setpos(".", pos)
    vim.notify('Kept both changes', vim.log.levels.INFO)
  else
    vim.notify('Conflict markers not found in expected format', vim.log.levels.ERROR)
  end
end

-- Jump to previous conflict
_G.conflict.prev = function()
  local result = vim.fn.search('<<<<<<< ', 'bW')
  if result == 0 then
    vim.notify('No previous conflict found', vim.log.levels.INFO)
  end
  return result
end

-- Jump to next conflict
_G.conflict.next = function()
  local result = vim.fn.search('<<<<<<< ', 'W')
  if result == 0 then
    vim.notify('No next conflict found', vim.log.levels.INFO)
  end
  return result
end

-- Normal mode mappings
wk.register({
  ["<leader><cr>"] = { "<cmd>noh<cr>", "Clear search highlight" },
  ["<leader>pp"] = { "<cmd>setlocal paste!<cr>", "Toggle paste mode" },
  
  -- Spelling
  ["<leader>ss"] = { "<cmd>setlocal spell!<cr>", "Toggle spell checking" },
  ["<leader>sn"] = { "]s", "Next misspelled word" },
  ["<leader>sp"] = { "[s", "Previous misspelled word" },
  ["<leader>sa"] = { "zg", "Add word to dictionary" },
  ["<leader>s?"] = { "z=", "Suggest corrections" },
  
  -- FZF
  ["<leader>f"] = { "<cmd>Files<CR>", "Find Files" },
  ["<leader>k"] = { "<Plug>(fzf-maps-n)", "Show key mappings" },
  
  -- LSP actions
  ["<leader>ca"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
  ["<leader>rn"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename Symbol" },
  
  -- IPython cell mappings
  ["<leader>s"] = { "<cmd>SlimeSend1 ipython --matplotlib<CR>", "Start IPython" },
  ["<leader>r"] = { "<cmd>IPythonCellRun<CR>", "Run Script" },
  ["<leader>R"] = { "<cmd>IPythonCellRunTime<CR>", "Run Script (timed)" },
  ["<leader>c"] = { "<cmd>IPythonCellExecuteCell<CR>", "Execute Cell" },
  ["<leader>C"] = { "<cmd>IPythonCellExecuteCellJump<CR>", "Execute Cell & Jump" },
  ["<leader>l"] = { "<cmd>IPythonCellClear<CR>", "Clear IPython Screen" },
  ["<leader>x"] = { "<cmd>IPythonCellClose<CR>", "Close Matplotlib Windows" },
  ["<leader>h"] = { "<Plug>SlimeLineSend", "Send Line to IPython" },
  ["<leader>p"] = { "<cmd>IPythonCellPrevCommand<CR>", "Run Previous Command" },
  ["<leader>Q"] = { "<cmd>IPythonCellRestart<CR>", "Restart IPython" },
  ["<leader>d"] = { "<cmd>SlimeSend1 %debug<CR>", "Start Debug Mode" },
  ["<leader>q"] = { "<cmd>SlimeSend1 exit<CR>", "Exit Debug/IPython" },
  
  -- Format
  ["<leader>=="] = { "<cmd>lua require('conform').format({ lsp_fallback = true })<CR>", "Format file or selection" },
  
  -- Text-to-Speech group
  ["<leader>t"] = { name = "Text-to-Speech" },
  ["<leader>tw"] = { "<cmd>call SpeakWord()<CR>", "Speak Word" },
  ["<leader>tc"] = { "<cmd>call SpeakCurrentLine()<CR>", "Speak Current Line" },
  ["<leader>tp"] = { "<cmd>call SpeakCurrentParagraph()<CR>", "Speak Paragraph" },
  ["<leader>tf"] = { "<cmd>call SpeakCurrentFile()<CR>", "Speak File" },
  ["<leader>tv"] = { "<cmd>call SpeakVisualSelection()<CR>", "Speak Selection" },
  
  -- Git operations with conflict resolution
  ["<leader>g"] = { name = "Git" },
  ["<leader>gd"] = { "<cmd>DiffviewOpen<CR>", "Diff View" },
  ["<leader>gm"] = { "<cmd>DiffviewOpen --merge<CR>", "Merge Conflicts View" },
  ["<leader>gc"] = { "<cmd>lua _G.conflict.open_conflicts()<CR>", "Open Conflicts" },
  ["<leader>gx"] = { "<cmd>DiffviewClose<CR>", "Close Diff View" },
  ["<leader>go"] = { "<cmd>lua _G.conflict.accept_current()<CR>", "Accept Current Changes" },
  ["<leader>gt"] = { "<cmd>lua _G.conflict.accept_incoming()<CR>", "Accept Incoming Changes" },
  ["<leader>gb"] = { "<cmd>lua _G.conflict.accept_both()<CR>", "Accept Both Changes" },
  
  -- Space prefix mappings
  ["<space>t"] = { name = "Text-to-Speech" },
  ["<space>tw"] = { "<cmd>call SpeakWord()<CR>", "Speak Word" },
  ["<space>tc"] = { "<cmd>call SpeakCurrentLine()<CR>", "Speak Current Line" },
  ["<space>tp"] = { "<cmd>call SpeakCurrentParagraph()<CR>", "Speak Paragraph" },
  ["<space>tf"] = { "<cmd>call SpeakCurrentFile()<CR>", "Speak File" },
  ["<space>tv"] = { "<cmd>call SpeakVisualSelection()<CR>", "Speak Selection" },
  
  -- g prefix mappings
  ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to Declaration" },
  ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to Definition" },
  ["gi"] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to Implementation" },
  ["gr"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "Find References" },
  ["gh"] = { "<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<CR>", "Show Diagnostics" },
  ["gnn"] = { "Initialize Treesitter Selection" },
  
  -- [ and ] mappings
  ["[c"] = { "<cmd>IPythonCellPrevCell<CR>", "Previous Cell" },
  ["]c"] = { "<cmd>IPythonCellNextCell<CR>", "Next Cell" },
  ["[g"] = { "<cmd>lua _G.conflict.prev()<CR>", "Previous Conflict" },
  ["]g"] = { "<cmd>lua _G.conflict.next()<CR>", "Next Conflict" },
  
  -- Function key mappings
  ["<F8>"] = { "<cmd>TagbarToggle<CR>", "Toggle Tagbar" },
  ["<F9>"] = { "<cmd>IPythonCellInsertAbove<CR>a", "Insert Cell Above" },
  ["<F10>"] = { "<cmd>IPythonCellInsertBelow<CR>a", "Insert Cell Below" },
}, { mode = "n" })  -- Explicitly set normal mode

-- Insert mode mappings
wk.register({
  ["<C-k>"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Show Signature Help" },
  ["<C-x>"] = { name = "Completions" },
  ["<C-x><C-k>"] = { "<Plug>(fzf-complete-word)", "Complete Word" },
  ["<C-x><C-f>"] = { "<Plug>(fzf-complete-path)", "Complete Path" },
  ["<C-x><C-l>"] = { "<Plug>(fzf-complete-line)", "Complete Line" },
  ["<C-x><C-o>"] = { "Ollama AI completion" },
  ["<F9>"] = { "<C-o>:IPythonCellInsertAbove<CR>", "Insert Cell Above" },
  ["<F10>"] = { "<C-o>:IPythonCellInsertBelow<CR>", "Insert Cell Below" },
}, { mode = "i" })  -- Insert mode

-- Visual mode mappings
wk.register({
  ["<leader>h"] = { "<Plug>SlimeRegionSend", "Send Selection to IPython" },
  ["k"] = { "<plug>(fzf-maps-x)", "Show key mappings" },
}, { mode = "v" })  -- Visual mode

-- Operator pending mode mappings
wk.register({
  ["k"] = { "<plug>(fzf-maps-o)", "Show key mappings" },
}, { mode = "o" })  -- Operator-pending mode
EOF
""" which-key configuration
