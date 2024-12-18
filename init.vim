" Auto-install vim-plug if not present
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" LSP Support with Mason
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'

" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

" GitHub Copilot
Plug 'github/copilot.vim'

" Clojure Development
Plug 'Olical/conjure'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'

" Theme
Plug 'joshdick/onedark.vim'

" Telescope and dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Tim Pope's Essential Plugins
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'

" Additional Quality of Life Improvements
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'windwp/nvim-autopairs'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'wolandark/vim-piper'
call plug#end()

" GitHub Copilot
let g:copilot_telemetry = v:false
let g:copilot_filetypes = {
            \ '*': v:false,
            \ 'python': v:true,
            \ 'typescript': v:true,
            \ 'javascript': v:true,
            \ 'clojure': v:true,
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

" Clipboard Settings
set clipboard+=unnamedplus

" Highlight on hover 
set updatetime=1000
autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
autocmd CursorHold,CursorHoldI * match none
"
" Code folding
" set foldmethod=indent " choices are: manual|indent|syntax|marker|expr
set foldmethod=expr
  \ foldexpr=lsp#ui#vim#folding#foldexpr()
  \ foldtext=lsp#ui#vim#folding#foldtext()

" Replace all instances selected in Visual mode, using Ctrl+r
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" Always show the status line
set laststatus=2

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

" Spelling mistakes will be colored up red.
hi SpellBad cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellLocal cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellRare cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellCap cterm=underline ctermfg=203 guifg=#ff5f5f

" Theme Configuration
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif
colorscheme onedark

" LSP and Mason Configuration
lua << EOF
-- Mason Setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",         -- Lua
    "clojure_lsp",    -- Clojure
    "pyright",        -- Python
    "denols",         -- Deno
--    "rust_analyzer",  -- Rust
  },
  automatic_installation = true,
})

-- LuaSnip Setup
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()

-- Completion Setup
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
  })
})

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

-- Specific setup for Deno
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

-- Setup other installed LSP servers
local servers = require('mason-lspconfig').get_installed_servers()
for _, lsp in ipairs(servers) do
  if lsp ~= "denols" then  -- Skip denols as it's configured separately
    lspconfig[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end
end
EOF

" Telescope Configuration
lua << EOF
require('telescope').setup{}
local builtin = require('telescope.builtin')
-- File and code navigation
vim.keymap.set('n', '<leader>ff', builtin.find_files)      -- Find files in project
vim.keymap.set('n', '<leader>fg', builtin.live_grep)       -- Search for string in project
vim.keymap.set('n', '<leader>fb', builtin.buffers)         -- Show open buffers
vim.keymap.set('n', '<leader>fh', builtin.help_tags)       -- Search help documentation
vim.keymap.set('n', '<leader>fr', builtin.oldfiles)        -- Show recently opened files
vim.keymap.set('n', '<leader>fw', builtin.grep_string)     -- Search for word under cursor
vim.keymap.set('n', '<leader>fo', builtin.treesitter)      -- Show code outline/structure
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols) -- Show LSP symbols

-- Git operations
vim.keymap.set('n', '<leader>gc', builtin.git_commits)     -- Browse git commits
vim.keymap.set('n', '<leader>gb', builtin.git_branches)    -- Browse git branches
vim.keymap.set('n', '<leader>gs', builtin.git_status)      -- Show git status
vim.keymap.set('n', '<leader>gf', builtin.git_files)       -- Search only git files
EOF
