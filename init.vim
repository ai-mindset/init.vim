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

" Local LLM completion
Plug 'ggml-org/llama.vim'                                     " LLM completion

" GitHub Copilot
Plug 'github/copilot.vim'                                     " Neovim plugin for GitHub Copilot
Plug 'CopilotC-Nvim/CopilotChat.nvim'                         " Chat with GitHub Copilot in Neovim


" Quarto
Plug 'quarto-dev/quarto-nvim'                                 " Quarto mode for Neovim
Plug 'jmbuhr/otter.nvim'                                      " provides lsp features and a code completion source for code embedded in other documents

" Rust
Plug 'rust-lang/rust.vim'                                     " Vim configuration for Rust

" Neovim <-> IPython
Plug 'jpalardy/vim-slime'

" CSV viewer
Plug 'hat0uma/csvview.nvim'                                   " A Neovim plugin for CSV file editing.

" Theme
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }                " Catppuccin theme

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
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'preservim/tagbar'                                       " Displays tags in a window, ordered by scope
Plug 'jakobkhansen/journal.nvim'                              " Keep notes
Plug 'folke/which-key.nvim'                                   " Helps you remember your Neovim keymaps
Plug 'norcalli/nvim-colorizer.lua'                            " Colour preview
call plug#end()

""" Catppuccin Theme Configuration with Accessibility Improvements
lua << EOF
require("catppuccin").setup({
  flavour = "mocha",   -- The highest contrast variant
  no_italic = false,
  no_bold = false,     -- Keep bold for structure
  styles = {
    comments = {},
    conditionals = {},
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
  },
  color_overrides = {
    mocha = {
      base = "#000000",  -- Deeper black for better contrast
      text = "#FFFFFF",  -- Brighter text
    },
  },
  integrations = {
    which_key = true,
    treesitter = true,
    mason = true,
    native_lsp = {
      enabled = true,
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        information = { "underline" },
        warnings = { "underline" },
      },
    },
  },
})
EOF

" Set the theme
colorscheme catppuccin

" Additional accessibility improvements
hi CursorLine guibg=#303030 ctermbg=236
hi Comment guifg=#a0a0a0 ctermfg=247
hi Visual guibg=#005f87 ctermbg=24 guifg=#ffffff ctermfg=15
hi Search guibg=#ffaf00 ctermbg=214 guifg=#000000 ctermfg=0
" Make gutter line numbers more accessible
hi LineNr guifg=#CCCCCC ctermfg=252 guibg=#1a1a1a ctermbg=234
hi CursorLineNr guifg=#FFFFFF ctermfg=15 guibg=#303030 ctermbg=236 gui=bold cterm=bold
""" Catppuccin Theme Configuration with Accessibility Improvements


""" Use jq for JSON formatting
" Makes :Format run `:%!jq .`
command! Format %!jq .
""" Use jq for JSON formatting

""" vim-slime configuration for IPython
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": get(split($TMUX, ','), 0), "target_pane": ":.1"}
let g:slime_dont_ask_default = 1
let g:slime_python_ipython = 1

" Keep your existing cell navigation (works perfectly with vim-slime)
" Clear the [c and ]c mappings from gitsigns
silent! unmap [c
silent! unmap ]c

" Your existing FlashCurrentCell function (keep as-is)
function! FlashCurrentCell()
  " Save current CursorLine highlight settings
  let cursorline_enabled = &cursorline
  let hl_cursorline = execute('highlight CursorLine')

  " Enable cursorline and set to bright yellow temporarily
  set cursorline
  highlight CursorLine ctermbg=yellow guibg=#FFFF00

  " Redraw screen to show highlight
  redraw

  " Wait briefly
  sleep 100m

  " Restore original CursorLine settings
  if !cursorline_enabled
    set nocursorline
  else
    " Parse the original highlight command to restore it
    let matches = matchlist(hl_cursorline, 'xxx\s\+\(.*\)')
    if len(matches) > 1
      execute 'highlight CursorLine ' . matches[1]
    else
      " Fallback to a standard style if parsing fails
      highlight CursorLine guibg=#303030 ctermbg=236
    endif
  endif

  " Redraw again to apply restored settings
  redraw
endfunction


" Function to send current cell
function! SlimeSendCell()
  " Save cursor position
  let save_pos = getpos('.')

  " Find cell boundaries
  let cell_start = search("^# %%", "bcnW")
  let cell_end = search("^# %%", "nW")

  if cell_start == 0
    let cell_start = 1
  endif

  if cell_end == 0
    let cell_end = line('$')
  else
    let cell_end = cell_end - 1
  endif

  " Send the cell
  execute cell_start . "," . cell_end . "SlimeSend"

  " Restore cursor position
  call setpos('.', save_pos)

  " Flash the cell
  call FlashCurrentCell()
endfunction
""" vim-slime configuration

""" llama.nvim configuration
let s:default_config = {
    \ "endpoint":           "http://127.0.0.1:8012/infill",
    \ "api_key":            "",
    \ "n_prefix":           256,
    \ "n_suffix":           64,
    \ "n_predict":          128,
    \ "t_max_prompt_ms":    500,
    \ "t_max_predict_ms":   500,
    \ "show_info":          2,
    \ "auto_fim":           v:true,
    \ "max_line_suffix":    8,
    \ "max_cache_keys":     250,
    \ "ring_n_chunks":      16,
    \ "ring_chunk_size":    64,
    \ "ring_scope":         1024,
    \ "ring_update_ms":     1000,
    \ "keymap_trigger":     "<C-F>",
    \ "keymap_accept_full": "<Tab>",
    \ "keymap_accept_line": "<S-Tab>",
    \ "keymap_accept_word": "<C-B>",
    \ }
""" llama.nvim configuration

""" GitHub Copilot
" Enable Copilot for specific languages
let g:copilot_enabled = 1
let g:copilot_filetypes = {
      \ "python": v:true,
      \ "javascript": v:true,
      \ "rust": v:true,
      \ "typescript": v:true,
      \ "sh": v:true,
      \ "zsh": v:true,
      \ "*": v:false,
      \ }
""" GitHub Copilot

""" GitHub Copilot Chat
lua << EOF
require("CopilotChat").setup({
-- Custom mappings are in which-key configuration below
  mappings = {
    -- Disable default keymaps
    chat = {
      open = false,
      accept = false,
      close = false,
    },
    selection = {
      select = false,
    },
    panel = {
      open = false,
    },
  }
})
EOF
""" GitHub Copilot Chat

""" quarto
lua << EOF
-- otter
require("otter").setup{
  lsp = {
    -- `:h events` that cause the diagnostics to update. Set to:
    -- { "BufWritePost", "InsertLeave", "TextChanged" } for less performant
    -- but more instant diagnostic updates
    diagnostic_update_events = { "BufWritePost" },
    -- function to find the root dir where the otter-ls is started
    root_dir = function(_, bufnr)
      return vim.fs.root(bufnr or 0, {
        ".git",
        "_quarto.yml",
        "package.json",
      }) or vim.fn.getcwd(0)
    end,
  },
  -- options related to the otter buffers
  buffers = {
    -- if set to true, the filetype of the otterbuffers will be set.
    -- otherwise only the autocommand of lspconfig that attaches
    -- the language server will be executed without setting the filetype
    --- this setting is deprecated and will default to true in the future
    set_filetype = true,
    -- write <path>.otter.<embedded language extension> files
    -- to disk on save of main buffer.
    -- usefule for some linters that require actual files.
    -- otter files are deleted on quit or main buffer close
    write_to_disk = false,
    -- a table of preambles for each language. The key is the language and the value is a table of strings that will be written to the otter buffer starting on the first line.
    preambles = {},
    -- a table of postambles for each language. The key is the language and the value is a table of strings that will be written to the end of the otter buffer.
    postambles = {},
    -- A table of patterns to ignore for each language. The key is the language and the value is a lua match pattern to ignore.
    -- lua patterns: https://www.lua.org/pil/20.2.html
    ignore_pattern = {
      -- ipython cell magic (lines starting with %) and shell commands (lines starting with !)
      python = "^(%s*[%%!].*)",
    },
  },
  -- list of characters that should be stripped from the beginning and end of the code chunks
  strip_wrapping_quote_characters = { "'", '"', "`" },
  -- remove whitespace from the beginning of the code chunks when writing to the ottter buffers
  -- and calculate it back in when handling lsp requests
  handle_leading_whitespace = true,
  -- mapping of filetypes to extensions for those not already included in otter.tools.extensions
  -- e.g. ["bash"] = "sh"
  extensions = {
  },
  -- add event listeners for LSP events for debugging
  debug = false,
  verbose = { -- set to false to disable all verbose messages
    no_code_found = false -- warn if otter.activate is called, but no injected code was found
  },
}

-- quarto
require('quarto').setup{
  debug = false,
  closePreviewOnExit = true,
  lspFeatures = {
    enabled = true,
    chunks = "curly",
    languages = { "r", "python", "julia", "bash", "html" },
    diagnostics = {
      enabled = true,
      triggers = { "BufWritePost" },
    },
    completion = {
      enabled = true,
    },
  },
  codeRunner = {
    enabled = true,
    default_method = "slime", -- "molten", "slime", "iron" or <function>
    ft_runners = {}, -- filetype to runner, ie. `{ python = "molten" }`.
    -- Takes precedence over `default_method`
    never_run = { 'yaml' }, -- filetypes which are never sent to a code runner
  },
}
EOF
""" quarto

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
set colorcolumn=90                   " Column indicating 90 characters
set cursorcolumn                      " Indentation guide
set cursorline
set ruler                             " Always show current position
set hlsearch                          " Highlight search results
set incsearch                         " Makes search act like search in modern browsers
set encoding=utf8                     " Set utf8 as standard encoding
set ffs=unix,dos,mac                  " Use Unix as the standard file type
set spell                             " Enable spell checking
set spelllang=en_gb
set clipboard=unnamedplus            " Clipboard Settings
set background=dark                   " Set dark background
if $COLORTERM == 'gnome-terminal'
  set t_Co=256                        " 256 colours
endif
set termguicolors                     " True colour support

""" Basic Settings

"" Highlight on hover
set updatetime=1000
augroup HighlightOnHover
    autocmd!
    autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
    autocmd CursorHold,CursorHoldI * match none
augroup END
"" Highlight on hover



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


""" Spelling mistakes will be coloured up red.
hi SpellBad cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellLocal cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellRare cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellCap cterm=underline ctermfg=203 guifg=#ff5f5f
""" Spelling mistakes will be coloured up red.

""" tagbar
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
    "pyright",               -- Python
    "rust_analyzer",         -- Rust
    "denols",                -- Deno
    "dockerls",              -- Docker
    "markdown_oxide",        -- Markdown
    "bashls",                -- Bash
    "biome",                 -- JSON
    "yamlls",                -- YAML
  },
  automatic_installation = true,
  handlers = {
    -- Pyright
    pyright_ls_type_checker = function()
      require('lspconfig').pyright.setup({
        init_options = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true
              }
            }
          }
        }
      })
      end,

      -- Rust Analyzer
      rust_analyzer = function()
      require('lspconfig').rust_analyzer.setup({
        on_attach = on_attach,
        settings = {
            ["rust-analyzer"] = {
                imports = {
                    granularity = {
                        group = "module",
                    },
                    prefix = "self",
                },
                cargo = {
                    buildScripts = {
                        enable = true,
                    },
                },
                procMacro = {
                    enable = true
                },
            }
        }
      })
      end,

    -- Deno Language Server
    denols = function()
      require("lspconfig").denols.setup({
        root_dir = require("lspconfig.util").root_pattern(
          "deno.json",
          "deno.jsonc"
        ),
        single_file_support = false,

        init_options = {
          lint = true,
          unstable = true,
          suggest = {
            imports = {
              hosts = {
                ["https://deno.land"] = true,
                ["https://cdn.nest.land"] = true,
                ["https://crux.land"] = true,
              },
            },
          },
        },

        settings = {
          deno = {
            enable = true,
            lint = true,
            unstable = true,
            codeLens = {
              references = true,
              referencesAllFunctions = true,
              test = true,
            },
            suggest = {
              imports = {
                hosts = {
                  ["https://deno.land"] = true,
                },
              },
            },
          },
        },

        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,

    -- Docker Language Server
    dockerls = function()
      require("lspconfig").dockerls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "docker-langserver", "--stdio" },
        filetypes = { "Dockerfile", "dockerfile", "Containerfile", "containerfile" },
        root_dir = require("lspconfig").util.root_pattern("Dockerfile", ".git"),
      })
    end,

    -- Markdown Oxide
    markdown_oxide = function()
      require("lspconfig").markdown_oxide.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "markdown", "markdown.mdx" },
        root_dir = require("lspconfig").util.root_pattern(".git"),
      })
    end,

    -- Bash Language Server
    bashls = function()
      require("lspconfig").bashls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "sh", "bash", "zsh" },
        root_dir = require("lspconfig").util.root_pattern(".git"),
      })
    end,

    -- Biome (JSON)
    biome = function()
      require("lspconfig").biome.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,

    -- YAML Language Server
    yamlls = function()
      require("lspconfig").yamlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
  }

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
    { name = "llama" },
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
        print(string.format("Client: %s, Server capabilities:", client.name))
        print(vim.inspect(client.server_capabilities))
    end
end

-- New way - define signs directly in diagnostic config
vim.diagnostic.config({
    virtual_text = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "✖",
        [vim.diagnostic.severity.WARN] = "⚠",
        [vim.diagnostic.severity.HINT] = "💡",
        [vim.diagnostic.severity.INFO] = "ℹ",
      }
    },
    underline = true,
    update_in_insert = false,
    severity_sort = false,
})
-- Show diagnostics when pressing 'gh'
vim.api.nvim_set_keymap('n', 'gh', ':lua vim.diagnostic.open_float(nil, {focus=true})<CR>', { silent = true })

-- Proper file type detection
vim.cmd([[
  augroup python_lsp
    autocmd!
    autocmd FileType python lua vim.diagnostic.enable(true)
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
                    focusable = true,
                })
            vim.lsp.buf.hover()
        end, opts)
    end,
})

-- Configure signature help handler once (globally, outside on_attach)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = 'rounded',
    close_events = { 'CursorMoved', 'BufHidden', 'InsertCharPre' },
    focusable = true,
  }
)

-- LSP Configuration
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- LSP Keybindings
local on_attach = function(client, bufnr)
  -- Debug print
  print("LSP attached:", client.name)

  -- Common options for most keymaps
  local opts = { noremap = true, silent = true, buffer = bufnr }


  -- Programming filetypes where signature help should auto-trigger
  local programming_filetypes = {'python', 'typescript', 'javascript'}

  -- Set up signature help auto-trigger only for programming files
  if vim.tbl_contains(programming_filetypes, vim.bo.filetype) then
    -- Use InsertCharPre instead of TextChangedI - fires BEFORE character insertion
    vim.api.nvim_create_autocmd('InsertCharPre', {
      buffer = bufnr,
      callback = function()
        local char = vim.v.char
        if char == '(' or char == ',' then
          vim.schedule(function()
            pcall(vim.lsp.buf.signature_help)
          end)
        end
      end,
    })

    -- Backup: CursorHoldI for when pausing inside function calls
    vim.api.nvim_create_autocmd('CursorHoldI', {
      buffer = bufnr,
      callback = function()
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local before_cursor = col > 0 and line:sub(1, col) or ''

        -- Only trigger if we're likely inside a function call
        if before_cursor:match('%(') and not before_cursor:match('%)') then
          pcall(vim.lsp.buf.signature_help)
        end
      end,
    })
  end
end
EOF
""" LSP Configuration

""" Linting and Formatting Configuration
lua << EOF
-- Linting Configuration
local lint = require('lint')

-- Define ruff as the only linter for Python
lint.linters_by_ft = {
  python = {'ruff'},
}

-- Configure ruff to ensure it shows all diagnostics
if lint.linters.ruff then
  -- Keep original settings but add --exit-zero
  local original_args = lint.linters.ruff.args or {}
  table.insert(original_args, 2, "--exit-zero")
  lint.linters.ruff.args = original_args
end

-- Function to count diagnostics and update status line
local function update_diagnostics_status()
  local diagnostics = vim.diagnostic.get(0)
  local error_count = 0
  local warn_count = 0
  local error_lines = {}
  local warn_lines = {}

  for _, diag in ipairs(diagnostics) do
    if diag.severity == vim.diagnostic.severity.ERROR then
      error_count = error_count + 1
      table.insert(error_lines, diag.lnum + 1)  -- +1 to convert to 1-based line numbers
    elseif diag.severity == vim.diagnostic.severity.WARN then
      warn_count = warn_count + 1
      table.insert(warn_lines, diag.lnum + 1)  -- +1 to convert to 1-based line numbers
    end
  end

  -- Sort line numbers
  table.sort(error_lines)
  table.sort(warn_lines)

  -- Prepare location strings (with up to 3 line numbers shown)
  local error_loc = #error_lines > 0 and
    " [Lines: " .. table.concat(error_lines, ",", 1, math.min(3, #error_lines)) ..
    (#error_lines > 3 and "..." or "") .. "]" or ""

  local warn_loc = #warn_lines > 0 and
    " [Lines: " .. table.concat(warn_lines, ",", 1, math.min(3, #warn_lines)) ..
    (#warn_lines > 3 and "..." or "") .. "]" or ""

  -- Display diagnostic count in command line with locations
  if error_count > 0 or warn_count > 0 then
    local msg = string.format("Linting: %d errors%s, %d warnings%s",
      error_count, error_loc, warn_count, warn_loc)
    vim.api.nvim_echo({{msg, "WarningMsg"}}, false, {})
  end

  -- Update statusline variable
  vim.g.linting_status = ""
  if error_count > 0 then
    vim.g.linting_status = vim.g.linting_status .. "E:" .. error_count
    if #error_lines > 0 then
      -- Show first error location
      vim.g.linting_status = vim.g.linting_status .. "@" .. error_lines[1]
    end
    vim.g.linting_status = vim.g.linting_status .. " "
  end
  if warn_count > 0 then
    vim.g.linting_status = vim.g.linting_status .. "W:" .. warn_count
    if #warn_lines > 0 then
      -- Show first warning location
      vim.g.linting_status = vim.g.linting_status .. "@" .. warn_lines[1]
    end
    vim.g.linting_status = vim.g.linting_status .. " "
  end
end

-- Set up linting on file save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.py" },
  callback = function()
    require("lint").try_lint()
    -- Update status after a short delay to ensure diagnostics are processed
    vim.defer_fn(update_diagnostics_status, 100)
  end,
})

-- Define visible diagnostic signs in the gutter
-- New way - define signs directly in diagnostic config
vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✖",
      [vim.diagnostic.severity.WARN] = "⚠",
      [vim.diagnostic.severity.HINT] = "💡",
      [vim.diagnostic.severity.INFO] = "ℹ",
    }
  },
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Set up keymapping to show diagnostics on hover
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {focus=true})
  end
})

-- Add linting status to your statusline
vim.o.statusline = vim.o.statusline .. " %{get(g:, 'linting_status', '')}"

-- Add command to show all diagnostics with their locations
vim.api.nvim_create_user_command("LintLocations", function()
  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics == 0 then
    print("No linting issues found")
    return
  end

  -- Sort diagnostics by line number
  table.sort(diagnostics, function(a, b) return a.lnum < b.lnum end)

  -- Display all diagnostics in a nice format
  local output = {"Linting issues:"}
  for _, diag in ipairs(diagnostics) do
    local severity = "Info"
    if diag.severity == vim.diagnostic.severity.ERROR then
      severity = "Error"
    elseif diag.severity == vim.diagnostic.severity.WARN then
      severity = "Warning"
    elseif diag.severity == vim.diagnostic.severity.HINT then
      severity = "Hint"
    end

    table.insert(output, string.format("Line %d: [%s] %s",
      diag.lnum + 1, severity, diag.message))
  end

  vim.api.nvim_echo(vim.tbl_map(function(line)
    return {line, "Normal"}
  end, output), true, {})
end, {})


-- Formatting Configuration
-- https://questions.deno.com/m/1233267429656891495
require("conform").setup({
  -- Formatters for your languages
  formatters_by_ft = {
    python = { "ruff_organise_imports", "ruff_format" },
    css = { "deno_fmt" },
    html = { "deno_fmt" },
    javascript = { "deno_fmt" },
    typescript = { "deno_fmt" },
    json = { "deno_fmt" },
    jsonc = { "deno_fmt" },
    javascriptreact = { "deno_fmt" },
    typescriptreact = { "deno_fmt" },
    markdown = { "deno_fmt" },
    json = { "biome" },
    rust = { "rustfmt" },
    ["*"] = { "trim_whitespace" },
  },

  -- Organise Python imports
    formatters = {
        ruff_organise_imports = {
          command = "ruff",
          args = {
            "check",
            "--force-exclude",
            "--select=I001",
            "--fix",
            "--exit-zero",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
          stdin = true,
          cwd = require("conform.util").root_file {
            "pyproject.toml",
            "ruff.toml",
            ".ruff.toml",
          },
        },
        deno_fmt = {
            command = "deno",
            args = {
                "fmt",
                "--prose-wrap=never",
                "--line-width=10000",
                "-" -- For stdin
            },
            stdin = true,
        },
      },
  -- Format on save

  format_on_save = {
    -- These options will be passed to conform.format()
    enabled = true,
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
        "javascript",
        "typescript",
        "rust",

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
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"


-- Start with all folds closed
vim.opt.foldenable = true
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
"" Mappings handled by which-key
"" Mappings
"" Completion handled by which-key
" Statusline
autocmd! FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
""" Fuzzy finding Configuration

""" CSV view
lua << EOF
require('csvview').setup({
  view = {
    display_mode = "border", -- Replace delimiters with vertical borders (│)
    header_lnum = true,  -- Auto-detect header (default)
    sticky_header = {
      enabled = true,
      separator = "─",  -- Separator line character
    },
  },
})
EOF
""" CSV view

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

""" FZF key mappings
" Key mapping for FZF maps browser - needs to be defined outside which-key
nmap <leader>k <plug>(fzf-maps-n)
xmap <leader>k <plug>(fzf-maps-x)
omap <leader>k <plug>(fzf-maps-o)
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

-- Normal mode mappings using new API format
wk.add({
  -- Copy path
  { "<leader>Y", group = "Copy path" },
  { "<leader>Yf", "<cmd>let @+=expand('%:p')<cr>", desc = "Copy full path" },
  { "<leader>Yr", "<cmd>let @+=expand('%')<cr>", desc = "Copy relative path" },
  { "<leader>Yn", "<cmd>let @+=expand('%:t')<cr>", desc = "Copy filename only" },

  -- Spelling
  { "<leader>s", group = "Spelling" },
  { "<leader>ss", "<cmd>setlocal spell!<cr>", desc = "Toggle spell checking" },
  { "<leader>sn", "]s", desc = "Next misspelled word" },
  { "<leader>sp", "[s", desc = "Previous misspelled word" },
  { "<leader>sa", "zg", desc = "Add word to dictionary" },
  { "<leader>s?", "z=", desc = "Suggest corrections" },

  -- Toggle paste mode
  { "<leader>pp", "<cmd>setlocal paste!<cr>", desc = "Toggle paste mode" },

  -- FZF
  { "<leader>f", "<cmd>Files<CR>", desc = "Find Files" },
  -- { "<leader>k", "<Plug>(fzf-maps-n)", desc = "Show key mappings" }, -- Not working with which-key

  -- LSP actions
  { "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code Action" },
  { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename Symbol" },

  -- IPython/Slime integration
  { "<localleader>c", "<cmd>call SlimeSendCell()<CR>", desc = "Send Cell to IPython" },
  { "<localleader>l", "<cmd>SlimeSendCurrentLine<CR>", desc = "Send Line to IPython" },
  { "<localleader>v", "<cmd>SlimeSend<CR>", desc = "Send to IPython" },

  -- Format
  { "<leader>==", "<cmd>lua require('conform').format({ lsp_fallback = true })<CR>", desc = "Format file or selection" },
  { "<leader>j", "<cmd>Format<CR>", desc = "Format JSON with jq"},

  -- Text-to-Speech group
  { "<leader>t", group = "Text-to-Speech" },
  { "<leader>tw", "<cmd>call SpeakWord()<CR>", desc = "Speak Word" },
  { "<leader>tc", "<cmd>call SpeakCurrentLine()<CR>", desc = "Speak Current Line" },
  { "<leader>tp", "<cmd>call SpeakCurrentParagraph()<CR>", desc = "Speak Paragraph" },
  { "<leader>tf", "<cmd>call SpeakCurrentFile()<CR>", desc = "Speak File" },
  { "<leader>tv", "<cmd>call SpeakVisualSelection()<CR>", desc = "Speak Selection" },

  -- Git operations with conflict resolution
  { "<leader>g", group = "Git" },
  { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diff View" },
  { "<leader>gm", "<cmd>DiffviewOpen --merge<CR>", desc = "Merge Conflicts View" },
  { "<leader>gc", "<cmd>lua _G.conflict.open_conflicts()<CR>", desc = "Open Conflicts" },
  { "<leader>gx", "<cmd>DiffviewClose<CR>", desc = "Close Diff View" },
  { "<leader>go", "<cmd>lua _G.conflict.accept_current()<CR>", desc = "Accept Current Changes" },
  { "<leader>gt", "<cmd>lua _G.conflict.accept_incoming()<CR>", desc = "Accept Incoming Changes" },
  { "<leader>gb", "<cmd>lua _G.conflict.accept_both()<CR>", desc = "Accept Both Changes" },

  -- Git hunk operations
  { "<leader>hs", "<cmd>lua require('gitsigns').stage_hunk()<CR>", desc = "Stage Hunk" },
  { "<leader>hr", "<cmd>lua require('gitsigns').reset_hunk()<CR>", desc = "Reset Hunk" },
  { "<leader>hp", "<cmd>lua require('gitsigns').preview_hunk()<CR>", desc = "Preview Hunk" },

  -- Space prefix mappings
  { "<space>t", group = "Text-to-Speech" },
  { "<space>tw", "<cmd>call SpeakWord()<CR>", desc = "Speak Word" },
  { "<space>tc", "<cmd>call SpeakCurrentLine()<CR>", desc = "Speak Current Line" },
  { "<space>tp", "<cmd>call SpeakCurrentParagraph()<CR>", desc = "Speak Paragraph" },
  { "<space>tf", "<cmd>call SpeakCurrentFile()<CR>", desc = "Speak File" },
  { "<space>tv", "<cmd>call SpeakVisualSelection()<CR>", desc = "Speak Selection" },

  -- g prefix mappings
  { "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Go to Declaration" },
  { "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Go to Definition" },
  { "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Go to Implementation" },
  { "gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "Find References" },
  { "gh", "<cmd>lua vim.diagnostic.open_float(nil, {focus=true})<CR>", desc = "Show Diagnostics" },
  { "gnn", "Initialize Treesitter Selection" },

  -- [ and ] mappings
  { "[c",
    "<cmd>call search('^# %%', 'bW')<CR><cmd>call FlashCurrentCell()<CR>",
    desc = "Previous Cell (highlighted)"
  },
  { "]c",
    "<cmd>call search('^# %%', 'W')<CR><cmd>call FlashCurrentCell()<CR>",
    desc = "Next Cell (highlighted)"
  },
  { "[g", "<cmd>lua _G.conflict.prev()<CR>", desc = "Previous Conflict" },
  { "]g", "<cmd>lua _G.conflict.next()<CR>", desc = "Next Conflict" },

  -- Hunk navigation
  { "<c", "<cmd>lua require('gitsigns').prev_hunk()<CR>", desc = "Previous Hunk" },
  { ">c", "<cmd>lua require('gitsigns').next_hunk()<CR>", desc = "Next Hunk" },

  -- Function key mappings
  { "<F8>", "<cmd>TagbarToggle<CR>", desc = "Toggle Tagbar" },
  { "<F9>", "i# %%<CR><ESC>", desc = "Insert Cell Above" },
  { "<F10>", "o# %%<CR>", desc = "Insert Cell Below" },

  -- GitHub CopilotChat
  { "<leader>c", group = "Code & Copilot" },
  { "<leader>cp", "<cmd>CopilotChat<CR>", desc = "Open Copilot Chat" },
  { "<leader>cpt", "<cmd>CopilotChatToggle<CR>", desc = "Toggle Copilot Chat" },
  { "<leader>cpf", "<cmd>CopilotChatFixDiagnostic<CR>", desc = "Fix Diagnostic" },
  { "<leader>cpe", "<cmd>CopilotChatExplain<CR>", desc = "Explain Code" },
}, { mode = "n" })

-- Insert mode mappings
wk.add({
  -- Signature help
  { "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", desc = "Show Signature Help" },

  -- FZF completions
  { "<C-x>", group = "Completions" },
  { "<C-x><C-k>", "<Cmd>lua vim.api.nvim_input('<C-r>=fzf#vim#complete#word({\"window\": { \"width\": 0.2, \"height\": 0.9, \"xoffset\": 1 }})<CR>')", desc = "Complete Word" },
  { "<C-x><C-f>", "<Cmd>lua vim.api.nvim_input('<C-r>=fzf#vim#complete#path(\"rg --files\")<CR>')", desc = "Complete Path" },
  { "<C-x><C-l>", "<Cmd>lua vim.api.nvim_input('<C-r>=fzf#vim#complete(fzf#wrap({\"prefix\": \"^.*$\", \"source\": \"rg -n ^ --color always\", \"options\": \"--ansi --delimiter : --nth 3..\", \"reducer\": { lines -> join(split(lines[0], \":\\\\zs\")[2:], \"\") }}))<CR>')", desc = "Complete Line" },

  -- llama.vim
  { "<C-F>", desc = "Trigger llama AI completion" },
  { "<Tab>", desc = "Accept full llama AI completion" },
  { "<S-Tab>", desc = "Accept line llama AI completion" },
  { "<C-B>", desc = "Accept word llama AI completion" },

  -- IPython
  { "<F9>", "<C-o>i# %%<CR>", desc = "Insert Cell Above" },
  { "<F10>", "<C-o>o# %%<CR>", desc = "Insert Cell Below" },
}, { mode = "i" })

-- Visual mode mappings
wk.add({
  -- IPython
  { "<localleader>v", ":'<,'>SlimeSend<CR>", desc = "Send Selection to IPython" },

  -- FZF mappings handled outside which-key
  -- { "<leader>k", "<plug>(fzf-maps-x)", desc = "Show key mappings" },

  -- Rust crates
  { "<leader>cku", "<cmd>lua require('crates').update_crates()<CR>", desc = "Update Selected Crates" },
  { "<leader>ckU", "<cmd>lua require('crates').upgrade_crates()<CR>", desc = "Upgrade Selected Crates" },

  -- GitHub CopilotChat
  { "<leader>cp", "<cmd>CopilotChatVisual<CR>", desc = "Copilot Chat Selection" },
  { "<leader>cpe", "<cmd>CopilotChatExplainVisual<CR>", desc = "Explain Selected Code" },
  { "<leader>cpt", "<cmd>CopilotChatTests<CR>", desc = "Generate Tests" },
}, { mode = "v" })

-- Operator pending mode mappings
wk.add({
  -- FZF mappings handled outside which-key
  -- { "<leader>k", "<plug>(fzf-maps-o)", desc = "Show key mappings"}
}, { mode = "o" })
EOF
""" which-key configuration

""" Jupyter notebook
" ─────────────────────────────────────────────────────────────
" 1) autocommand group to intercept *.ipynb reads/writes
augroup NotebookInplace
  autocmd!
  autocmd BufReadPost  *.ipynb call s:OpenNotebook(expand('<afile>'))
  autocmd BufWritePre *.ipynb call s:SaveNotebook()
augroup END

" ─────────────────────────────────────────────────────────────
" 2) Convert .ipynb → percent-formatted lines in current buffer
function! s:OpenNotebook(path) abort
  " read the raw JSON and pipe through jupytext (stdin→stdout)
  " percent format keeps #%% cell markers
  let l:json = join(readfile(a:path), "\n")
  let l:py   = system('jupytext --to py:percent --from ipynb -', l:json)

  " wipe out the buffer and replace with the py:percent lines
  execute 'setlocal buftype='
  execute 'setlocal filetype=python'
  silent 0delete _
  call append(0, split(l:py, "\n"))
  " remember the real path in a buffer-local var
  let b:__real_ipynb = a:path
  setlocal buftype=acwrite       " trigger BufWritePre
  setlocal bufhidden=wipe        " no leftover if aborted
  file    `=fnamemodify(a:path, ':t')`  " show correct name in status
endfunction

" ─────────────────────────────────────────────────────────────
" 3) On write, convert buffer → JSON and overwrite the real .ipynb
function! s:SaveNotebook() abort
  if !exists('b:__real_ipynb')
    return
  endif
  " grab all lines in the buffer
  let l:cells = join(getbufline('%', 1, '$'), "\n")
  " pipe them to jupytext to re-encode as notebook JSON
  let l:json  = system('jupytext --to ipynb --from py:percent -', l:cells)
  " overwrite the real notebook
  call writefile(split(l:json, "\n"), b:__real_ipynb)
  " prevent Vim thinking we still need to write this buffer
  setlocal nomodified
endfunction
""" Jupyter notebook

""" nvim-colorizer
lua << EOF
require("colorizer").setup()
EOF
""" nvim-colorizer
