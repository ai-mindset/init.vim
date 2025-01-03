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

" Local LLM completion
Plug 'nomnivore/ollama.nvim'                                  " LLM completion

" Clojure Development
Plug 'Olical/conjure'                                         " Clojure REPL 
Plug 'PaterJason/cmp-conjure'                                 " Clojure completion
Plug 'guns/vim-sexp'                                          " Clojure S-Expression 
Plug 'tpope/vim-sexp-mappings-for-regular-people'             " Clojure S-Expression Mappings 

" Theme
Plug 'Mofiqul/vscode.nvim'

" Fuzzy finding and dependencies
Plug 'nvim-lua/plenary.nvim'                                  " Plugin dependency
Plug 'nvim-tree/nvim-web-devicons'                            " optional for icons
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }           " optional for the 'fzf' command
Plug 'junegunn/fzf.vim'                                       " fzf vim bindings

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
Plug 'ellisonleao/glow.nvim'                                  " Markdown preview
call plug#end()

" GitHub Copilot
let g:copilot_telemetry = v:false
let g:copilot_filetypes = {
            \ "*": v:false,
            \ "python": v:true,
            \ "sh": v:true,
            \ "bash": v:true,
            \ "zsh": v:true,
            \ }
            " \ "clojure": v:true 
            " \ "typescript": v:true,
            " \ "javascript": v:true,
            " }
let g:copilot_model = "claude3.5-sonnet"
" let g:copilot_model = "gpt-4o"

" ollama.nvim configuration
lua << EOF
opts = {
  model = "granite3.1-dense:8b",
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

vim.keymap.set('i', '<C-x><C-o>', function()
    require('cmp').complete({
        config = {
            sources = {
                { name = 'ollama' }
            }
        }
    })
end)
EOF

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
set clipboard+=unnamedplus            " Clipboard Settings
set background=dark                   " Set dark background
" set t_Co=256                          " 256 colours
set termguicolors                     " True colour support

colorscheme vscode                    " Theme Configuration

" Highlight on hover 
set updatetime=1000
autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
autocmd CursorHold,CursorHoldI * match none

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Code folding
" choices are: manual|indent|syntax|marker|expr
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

" Get active virtual environment
function! VirtualEnv()
    if exists('$VIRTUAL_ENV')
        " Get the actual environment name from pyenv or virtualenv
        let venv_path = $VIRTUAL_ENV
        let venv_name = venv_path
        
        " Handle .venv directory case
        if fnamemodify(venv_path, ':t') == '.venv'
            let venv_name = fnamemodify(venv_path, ':h:t')
        endif
        
        return 'venv:(' . venv_name . ') '
    endif
    return ''
endfunction

""" Statusline Configuration
function! SetStatusLineColors()
    " Default statusline colors
    hi StatusLine guifg=#C0C0C0 guibg=#1A1A1A ctermfg=white ctermbg=234 gui=none
    hi StatusLineNC guifg=#808080 guibg=#141414 ctermfg=gray ctermbg=233 gui=none

    " All statusline sections
    hi User1 guifg=#FFFFFF guibg=#2E7D32 ctermfg=white ctermbg=green gui=none
    hi User2 guifg=#FFFFFF guibg=#37474F ctermfg=white ctermbg=238 gui=none
    hi User3 guifg=#FFFFFF guibg=#0D47A1 ctermfg=white ctermbg=26 gui=none
    hi User4 guifg=#FFFFFF guibg=#4A148C ctermfg=white ctermbg=90 gui=none
    hi User5 guifg=#FFFFFF guibg=#00695C ctermfg=white ctermbg=29 gui=none
    hi User6 guifg=#FFFFFF guibg=#283593 ctermfg=white ctermbg=18 gui=none
endfunction

function! SetModeColors()
    if mode() =~# '\v(n|no)'
        hi User1 guifg=#FFFFFF guibg=#2E7D32 ctermfg=white ctermbg=green gui=none
    elseif mode() =~# '\v(i|R)'
        hi User1 guifg=#FFFFFF guibg=#5E35B1 ctermfg=white ctermbg=magenta gui=bold
    elseif mode() =~# '\v(v|V|\<C-v>)'
        hi User1 guifg=#FFFFFF guibg=#C62828 ctermfg=white ctermbg=red gui=bold
    endif
endfunction

augroup StatusLineColors
    autocmd!
    " Set initial colors
    autocmd VimEnter * call SetStatusLineColors()
    
    " Maintain colors after save
    autocmd BufWritePre * let g:colors_before_save = g:currentmode[mode()]
    autocmd BufWritePost * call SetStatusLineColors()
    autocmd BufWritePost * call SetModeColors()
    
    " Mode changes
    autocmd InsertEnter * hi User1 guifg=#FFFFFF guibg=#5E35B1 ctermfg=white ctermbg=magenta gui=bold
    autocmd InsertLeave * hi User1 guifg=#FFFFFF guibg=#2E7D32 ctermfg=white ctermbg=green gui=none
    autocmd ModeChanged *:[vV\x16]* hi User1 guifg=#FFFFFF guibg=#C62828 ctermfg=white ctermbg=red gui=bold
    autocmd ModeChanged [vV\x16]*:* hi User1 guifg=#FFFFFF guibg=#2E7D32 ctermfg=white ctermbg=green gui=none
augroup END

set statusline=
set statusline+=\ %1*%{g:currentmode[mode()]}%*                 " Mode
set statusline+=\ %{&ff}\                                       " File format
set statusline+=\ %2*%{HasPaste()}\ %{SpellStatus()}%*          " File states
set statusline+=\ %2*%F%m%r%h\ %w%*                             " Filename and flags
set statusline+=\ %3*CWD:%{GetRelCwd()}%*                     " CWD without label
set statusline+=%4*%{fugitive#statusline()}%*                   " Git status
set statusline+=%=                                              " Switch sides
set statusline+=%5*%{VirtualEnv()}%*                            " Virtual env
set statusline+=\ C:%c\ L:%l\ %p%%\ \                           " Position info

" Initialize colours when vim starts
call SetStatusLineColors()
""" Statusline Configuration

" piper TTS
let g:piper_bin = 'piperTTS'
let g:piper_voice = '/usr/share/piper-voices/alba.onnx'
" <space>tw = SpeakWord()
" <space>tc = SpeakCurrentLine()
" <space>tp = SpeakCurrentParagraph()
" <space>tf = SpeakCurrentFile()
" <space>tv = SpeakVisualSelection()

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s " Next spelling mistake    
map <leader>sp [s " Previous spelling mistake
map <leader>sa zg " Add word to dictionary
map <leader>s? z= " Get suggestions

" Spelling mistakes will be coloured up red.
hi SpellBad cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellLocal cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellRare cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellCap cterm=underline ctermfg=203 guifg=#ff5f5f

" Conjure Configuration 
let g:conjure#client#python#stdio#command = "python -iq -m asyncio" " https://github.com/Olical/conjure/issues/545#issuecomment-1878879728
let g:conjure#client#sql#stdio = "sqlite3"
let g:conjure#log#wrap = 1 
let g:conjure#log#fold#enabled = 1
let g:conjure#preview#sample_limit = 1.0
let g:conjure#log#hud#height = 0.5
let g:conjure#log#hud#border = 0

" Conjure with Baleia Configuration
let g:conjure#log#strip_ansi_escape_sequences_line_limit = 0
let s:baleia = luaeval("require('baleia').setup { line_starts_at = 3 }")
autocmd BufWinEnter conjure-log-* call s:baleia.automatically(bufnr('%'))

" Glow configurations
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
  -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
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
  vim.keymap.set({ "n", "v" }, "==", function()
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
