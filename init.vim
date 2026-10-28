" Auto-install vim-plug if not present
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
let s:bootstrap_plugins = empty(glob(data_dir . '/autoload/plug.vim'))
if s:bootstrap_plugins
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  if empty(glob(data_dir . '/autoload/plug.vim'))
    echoerr 'Could not install vim-plug'
    finish
  endif
endif

call plug#begin()
" LSP Support with Mason
Plug 'mason-org/mason.nvim'                                   " Mason
Plug 'neovim/nvim-lspconfig'                                  " LSP Configuration
Plug 'mfussenegger/nvim-lint'                                 " Linting engine
Plug 'stevearc/conform.nvim'                                  " Formatting engine
Plug 'mfussenegger/nvim-dap'                                  " Debug adapter client
Plug 'leoluz/nvim-dap-go'                                     " Delve integration
Plug 'hrsh7th/nvim-cmp'                                       " Completion Engine
Plug 'hrsh7th/cmp-nvim-lsp'                                   " LSP completion
Plug 'hrsh7th/cmp-buffer'                                     " Buffer completion
Plug 'hrsh7th/cmp-cmdline'                                    " Command line completion
Plug 'hrsh7th/cmp-path'                                       " Path completion

" Local LLM completion
Plug 'nomnivore/ollama.nvim'                                  " Ollama AI completion

" Elixir Development
Plug 'elixir-editors/vim-elixir'                              "  Vim configuration files for Elixir

" Common Lisp Development
Plug 'vlime/vlime', { 'rtp': 'vim/', 'for': 'lisp' }           " Vim plugin for Common Lisp (lazy-load)
Plug 'hrsh7th/cmp-omni'

" Neovim <-> IPython
Plug 'jpalardy/vim-slime'

" CSV viewer
Plug 'hat0uma/csvview.nvim'                                   " A Neovim plugin for CSV file editing.

" Theme
Plug 'miikanissi/modus-themes.nvim'                          " High-contrast Modus theme

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
Plug 'sindrets/diffview.nvim'                                 " Easily cycling through diffs for all modified files for any git rev
Plug 'lewis6991/gitsigns.nvim'                                " Git integration for buffers 

" Additional Quality of Life Improvements
Plug 'nvim-treesitter/nvim-treesitter', { 'branch': 'main', 'do': ':TSUpdate' } " Neovim 0.12 API
Plug 'jaseci-labs/tree-sitter-jac'                             " Official Jac grammar, queries, and filetype settings
Plug 'nvim-treesitter/nvim-treesitter-context'                 " Show code context 
Plug 'lukas-reineke/indent-blankline.nvim'                     " Vertical indentation guide lines
Plug 'windwp/nvim-autopairs'                                   " Autopairs for auto closing brackets
Plug 'm00qek/baleia.nvim'                                      " Colourful log messages
Plug 'preservim/tagbar'                                        " Displays tags in a window, ordered by scope
Plug 'jakobkhansen/journal.nvim'                               " Keep notes
Plug 'folke/which-key.nvim'                                    " Helps you remember your Neovim keymaps
Plug 'catgoose/nvim-colorizer.lua'                             " Colour preview
Plug 'MeanderingProgrammer/render-markdown.nvim'               " Better markdown rendering in Neovim 
Plug 'brianhuster/live-preview.nvim'                           " Live Markdown and HTML preview in browser
call plug#end()

" Do not execute plugin configuration until a fresh install has completed.
if s:bootstrap_plugins
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  finish
endif

lua << EOF
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 }) end,
})
EOF

""" Modus Vivendi tinted: high contrast on a softened dark background
set termguicolors
set background=dark
lua << EOF
require("modus-themes").setup({
  style = "modus_vivendi",
  variants = { modus_vivendi = "tinted" },
  styles = { comments = { italic = false }, keywords = { italic = false } },
  on_highlights = function(highlights, colors)
    -- Bold keys remain distinct from values even without colour perception.
    -- Share the palette between Tree-sitter and the built-in JSON syntax.
    highlights["@property.json"] = { fg = colors.magenta, bold = true }
    highlights["@string.json"] = { fg = colors.blue_cooler }
    highlights["@number.json"] = { fg = colors.yellow }
    highlights["@boolean.json"] = { fg = colors.cyan, bold = true }
    highlights["@constant.builtin.json"] = { fg = colors.cyan, bold = true }
    -- These remain readable against the tinted CursorLine background too.
    highlights["@comment.json"] = { fg = colors.fg_alt }
    highlights.jsonKeyword = { link = "@property.json" }
    highlights.jsonString = { link = "@string.json" }
    highlights.jsonNumber = { link = "@number.json" }
    highlights.jsonBoolean = { link = "@boolean.json" }
    highlights.jsonNull = { link = "@constant.builtin.json" }
    highlights.jsonComment = { link = "@comment.json" }
    highlights.jsonLineComment = { link = "@comment.json" }
  end,
})
EOF
colorscheme modus
""" Modus theme

""" Use jq for JSON formatting
" Makes :Format run `:%!jq .`
command! Format %!jq .
""" Use jq for JSON formatting

""" vim-slime configuration for IPython
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": get(split($TMUX, ','), 0), "target_pane": ":.1"}
let g:slime_dont_ask_default = 1
let g:slime_python_ipython = 1
let g:slime_bracketed_paste = 1  " Better paste support for REPLs
let g:slime_send_as_block = 1    " Global setting for proper multi-line selection sending in all REPLs

" Language-specific settings

" Keep your existing cell navigation (works perfectly with vim-slime)
" Clear the [c and ]c mappings from gitsigns
silent! unmap [c
silent! unmap ]c

" Briefly flash the current line with the theme's active-search highlight.
function! FlashCurrentCell() abort
  let l:match = matchaddpos('CurSearch', [line('.')], 20)
  try
    redraw
    sleep 100m
  finally
    call matchdelete(l:match)
    redraw
  endtry
endfunction


" Function to send current cell
function! SlimeSendCell()
  " Save cursor position
  let save_pos = getpos('.')

  " Get the appropriate cell delimiter pattern based on filetype
  let cell_pattern = "^# %%"  " Default for Python

  " Use filetype-specific cell patterns

  " Find cell boundaries using the appropriate pattern
  let cell_start = search(cell_pattern, "bcnW")
  let cell_end = search(cell_pattern, "nW")

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

""" ollama.nvim configuration
lua << EOF
local opts = {
  model = "mistral",
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

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "elixir", "typescript", "javascript" },
  callback = function()
    vim.keymap.set("i", "<C-x><C-o>", function()
      require("cmp").complete({
        config = { sources = { { name = "ollama" }, { name = "path" } } }
      })
    end, { buffer = true })
  end,
})

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
set number
set relativenumber
set expandtab                                   " Use spaces instead of tabs
set tabstop=4                                   " Tab = 4 spaces
set shiftwidth=4                                " Tab = 4 spaces
set softtabstop=4                               " Number of spaces for a tab in insert mode
set autoindent                                  " Auto indent
set nowrap                                      " Source code stays aligned; prose wraps locally
set signcolumn=yes
set updatetime=1000                            " Clear hover highlighting after one second
set completeopt=menu,menuone,noselect
set colorcolumn=90                              " Column indicating 90 characters
set cursorline
set cursorcolumn                                " Track the current alignment column
set ruler                                       " Always show current position
set hlsearch                                    " Highlight search results
set incsearch                                   " Makes search act like search in modern browsers
set encoding=utf8                               " Set utf8 as standard encoding
set ffs=unix,dos,mac                            " Use Unix as the standard file type
set spell                                       " Check spelling in every buffer
set spelllang=en_gb
set clipboard=unnamedplus                       " Clipboard Settings
if $COLORTERM == 'gnome-terminal'
  set t_Co=256                                  " 256 colours
endif
""" Basic Settings

" Tree-sitter folding is enabled later only for supported filetypes.
set foldlevel=99
set foldlevelstart=99

augroup ProseSettings
    autocmd!
    autocmd FileType markdown,gitcommit,text setlocal wrap linebreak
augroup END

augroup GoSettings
    autocmd!
    autocmd FileType go,gomod,gowork,gosum setlocal nospell noexpandtab tabstop=4 shiftwidth=4 softtabstop=0
augroup END

function! s:SetupJsonBuffer() abort
    let b:undo_ftplugin = get(b:, 'undo_ftplugin', '') .
        \ printf(' | let &l:spell = %d | let &l:conceallevel = %d', &l:spell, &l:conceallevel)
    setlocal nospell conceallevel=0
endfunction

augroup JsonSettings
    autocmd!
    autocmd FileType json,jsonc call <SID>SetupJsonBuffer()
augroup END

lua << EOF
local json_syntax_group = vim.api.nvim_create_augroup("JsonSyntaxHighlights", { clear = true })
vim.api.nvim_create_autocmd("Syntax", {
  group = json_syntax_group,
  pattern = "jsonc",
  callback = function()
    -- Run after the syntax loader, even when :syntax on reorders its handlers.
    vim.schedule(function()
      vim.api.nvim_set_hl(0, "jsonComment", { link = "@comment.json" })
      vim.api.nvim_set_hl(0, "jsonLineComment", { link = "@comment.json" })
    end)
  end,
})
EOF

""" Highlight on hover
function! s:HighlightWordUnderCursor() abort
    let l:word = expand('<cword>')
    if empty(l:word)
        match none
        return
    endif

    execute printf('match Search /\V\<%s\>/', escape(l:word, '/\'))
endfunction

augroup HighlightOnHover
    autocmd!
    autocmd CursorMoved * call <SID>HighlightWordUnderCursor()
    autocmd CursorHold,CursorHoldI * match none
augroup END
""" Highlight on hover

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

" Use the theme's StatusLine highlight throughout.
function! SetupStatusline()
    let &statusline = ' mode:%{CurrentMode()}'
    let &statusline .= ' fmt:%{&ff} state:%{StatusPaste()}%{StatusSpell()}'
    let &statusline .= ' path:%{PWDPath()}'
    let &statusline .= '%{GitInfo()}'
    let &statusline .= ' %{get(g:, ''diagnostic_status'', '''')}'
    let &statusline .= '%='
    let &statusline .= '%{StatusVenv()!=""?(" venv:(".StatusVenv().")"):""}'
    let &statusline .= ' Ln:%l Col:%c %p%% '
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

""" Piper TTS
lua << EOF
if _G.PiperTTS and type(_G.PiperTTS.stop) == "function" then
  _G.PiperTTS.stop(false)
end

local function first_executable(candidates)
  for _, candidate in ipairs(candidates) do
    local path = candidate == "piper" and vim.fn.exepath(candidate) or vim.fn.expand(candidate)
    if path ~= "" and vim.fn.executable(path) == 1 then
      return path
    end
  end
end

local function first_readable(candidates)
  for _, candidate in ipairs(candidates) do
    local path = vim.fn.expand(candidate)
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end
end

local function player_command(path)
  local players = {
    { "aplay", { path } },
    { "pw-play", { path } },
    { "afplay", { path } },
    { "ffplay", { "-nodisp", "-autoexit", "-loglevel", "quiet", path } },
  }
  for _, player in ipairs(players) do
    local executable = vim.fn.exepath(player[1])
    if executable ~= "" then
      return vim.list_extend({ executable }, player[2])
    end
  end
end

local speech = {
  request = 0,
  synthesis = nil,
  playback = nil,
  outputs = {},
}

local function remove_output(path)
  speech.outputs[path] = nil
  pcall(vim.uv.fs_unlink, path)
end

local function terminate(process)
  if process then
    pcall(function()
      process:kill(15)
    end)
  end
end

local function stop(notify)
  local was_active = speech.synthesis ~= nil
    or speech.playback ~= nil
    or next(speech.outputs) ~= nil

  -- Invalidate callbacks before terminating anything. A Piper process that
  -- exits concurrently must not be allowed to start another audio player.
  speech.request = speech.request + 1
  terminate(speech.synthesis)
  terminate(speech.playback)
  speech.synthesis = nil
  speech.playback = nil

  for path in pairs(speech.outputs) do
    remove_output(path)
  end

  if notify ~= false then
    vim.notify(was_active and "Speech stopped" or "No speech is running")
  end
end

local function speak(text)
  if not text or not text:match("%S") then
    return
  end

  -- Speech is deliberately single-owner: a new request replaces any current
  -- synthesis or playback instead of allowing overlapping audio streams.
  stop(false)
  local request = speech.request

  local piper = first_executable({
    "piper",
    "~/.local/bin/piper",
    "~/.local/share/piper/piper",
    "~/.venv/bin/piper",
  })
  local voice = first_readable({
    "~/.local/share/piper-voices/en_GB-alba-medium.onnx",
    "/usr/share/piper-voices/en_GB-alba-medium.onnx",
  })

  if not piper or not voice then
    vim.notify("Piper executable or voice model not found", vim.log.levels.ERROR)
    return
  end

  local output = vim.fn.tempname() .. ".wav"
  speech.outputs[output] = true

  local synthesis
  synthesis = vim.system({ piper, "--model", voice, "--output_file", output }, {
    stdin = text,
    text = true,
  }, function(result)
    vim.schedule(function()
      if speech.synthesis == synthesis then
        speech.synthesis = nil
      end
      if request ~= speech.request then
        remove_output(output)
        return
      end
      if result.code ~= 0 then
        remove_output(output)
        vim.notify("Piper failed: " .. vim.trim(result.stderr or ""), vim.log.levels.ERROR)
        return
      end

      local command = player_command(output)
      if not command then
        remove_output(output)
        vim.notify("No supported audio player found", vim.log.levels.ERROR)
        return
      end

      local playback
      playback = vim.system(command, { text = true }, function(result)
        vim.schedule(function()
          if speech.playback == playback then
            speech.playback = nil
          end
          remove_output(output)
          if request ~= speech.request then
            return
          end
          if result.code ~= 0 then
            vim.notify("Audio playback failed", vim.log.levels.ERROR)
          end
        end)
      end)
      speech.playback = playback
    end)
  end)
  speech.synthesis = synthesis
end

_G.PiperTTS = {
  stop = stop,
  word = function()
    speak(vim.fn.expand("<cword>"))
  end,
  line = function()
    speak(vim.api.nvim_get_current_line())
  end,
  paragraph = function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local first, last = row, row
    while first > 1 and vim.fn.getline(first - 1):match("%S") do
      first = first - 1
    end
    while last < vim.api.nvim_buf_line_count(0) and vim.fn.getline(last + 1):match("%S") do
      last = last + 1
    end
    speak(table.concat(vim.api.nvim_buf_get_lines(0, first - 1, last, false), "\n"))
  end,
  file = function()
    speak(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"))
  end,
  visual = function()
    local region = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), {
      type = vim.fn.mode(),
    })
    speak(table.concat(region, "\n"))
  end,
}

vim.api.nvim_create_user_command("PiperStop", function()
  stop(true)
end, { desc = "Stop Piper speech", force = true })

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("PiperTTS", { clear = true }),
  callback = function()
    stop(false)
  end,
})
EOF
""" Piper TTS


""" TypeScript configuration for Tagbar's Universal Ctags parser
let g:tagbar_ctags_bin = '/usr/bin/ctags-universal'

let g:tagbar_type_typescript = {
  \ 'ctagstype': 'TypeScript',
  \ 'kinds': [
    \ 'n:namespaces',
    \ 'i:interfaces',
    \ 'g:enums',
    \ 'e:enumerators',
    \ 'c:classes',
    \ 'C:constants',
    \ 'f:functions',
    \ 'G:generators',
    \ 'p:properties',
    \ 'v:variables',
    \ 'm:methods',
    \ 'a:type aliases',
  \ ],
  \ 'sro': '.',
  \ 'kind2scope': {
    \ 'c': 'class',
    \ 'i': 'interface',
    \ 'g': 'enum',
    \ 'n': 'namespace',
  \ },
  \ 'scope2kind': {
    \ 'class': 'c',
    \ 'interface': 'i',
    \ 'enum': 'g',
    \ 'namespace': 'n',
  \ },
  \ 'sort': 0
  \ }

" JavaScript configuration for Tagbar's Universal Ctags parser
let g:tagbar_type_javascript = {
  \ 'ctagstype': 'JavaScript',
  \ 'kinds': [
    \ 'v:global variables',
    \ 'C:constants',
    \ 'c:classes',
    \ 'g:generators',
    \ 'G:getters',
    \ 'S:setters',
    \ 'M:fields',
    \ 'p:properties',
    \ 'm:methods',
    \ 'f:functions',
  \ ],
  \ 'sro': '.',
  \ 'kind2scope': {
    \ 'c': 'class',
    \ 'f': 'function',
    \ 'm': 'method',
    \ 'p': 'property',
  \ },
  \ 'scope2kind': {
    \ 'class': 'c',
    \ 'function': 'f',
  \ },
  \ 'sort': 0
  \ }

""" tagbar
" https://github.com/preservim/tagbar/blob/d55d454bd3d5b027ebf0e8c75b8f88e4eddad8d8/doc/tagbar.txt#L512
let g:tagbar_left = 1
let g:tagbar_autoclose = 0
let g:tagbar_autofocus = 0 " If you set this option the cursor will move to the Tagbar window when it is opened
let g:tagbar_compact = 1 " 0: Show short help and blank lines between top-level scopes
                         " 1: Don't show the short help or the blank lines.
                         " 2: Don't show the short help but show the blank lines.
let g:tagbar_show_data_type = 0
let g:tagbar_show_linenumbers = 1
let g:tagbar_iconchars = ['▶', '▼']  " (default on Linux and Mac OS X)

" Elixir configuration for Tagbar's Universal Ctags parser
let g:tagbar_type_elixir = {
  \ 'ctagstype': 'Elixir',
  \ 'kinds': [
    \ 'f:functions',
    \ 'c:callbacks',
    \ 'd:delegates',
    \ 'e:exceptions',
    \ 'i:implementations',
    \ 'a:macros',
    \ 'm:modules',
    \ 'o:operators',
    \ 'p:protocols',
    \ 'r:records',
    \ 't:tests',
  \ ],
  \ 'sort': 0
  \ }

""" tagbar

""" indent-blankline configuration
lua << EOF
require("ibl").setup({
  indent = {
    char = "│",       -- Solid vertical line character
  },
  scope = {
    enabled = true,   -- Highlight the current scope's indentation level
    show_start = true,
    show_end = false,
  },
  exclude = {
    filetypes = { "help", "dashboard", "lazy", "mason", "tagbar" },
    buftypes  = { "terminal", "nofile" },
  },
})
EOF
""" indent-blankline configuration

" Autopairs Configuration
lua << EOF
require("nvim-autopairs").setup({})
EOF

""" Mason Configuration
lua << EOF
-- Desktop launches may not inherit .zshrc. Include Jac's official install
-- directory and the Go toolchain before configuring language tools.
for _, directory in ipairs({ vim.fn.expand('~/.local/bin'), '/usr/local/go/bin', vim.fn.expand('~/go/bin') }) do
  if vim.fn.isdirectory(directory) == 1 then
    local entries = vim.split(vim.env.PATH or '', ':', { plain = true })
    if not vim.list_contains(entries, directory) then
      vim.env.PATH = directory .. ':' .. (vim.env.PATH or '')
    end
  end
end

require("mason").setup()

-- Use Mason package names here, not nvim-lspconfig server names.
local mason_packages = {
  "actionlint",            -- GitHub Actions linter
  "jedi-language-server",  -- Python LSP
  "pyright",               -- Python type-checking LSP
  "ruff",                  -- Python linter and formatter
  "markdown-oxide",        -- Markdown LSP
  "markdownlint-cli2",     -- Markdown linter
  "tsc",                   -- TypeScript 7 language server for JS/TS
  "prettier",              -- JS/TS, JSON, and Markdown formatter
  "elixir-ls",             -- Elixir LSP
  "gopls",                 -- Go LSP
  "goimports",             -- Go formatter and import organiser
  "delve",                 -- Go debugger
}

-- Mason builds these three packages with Go; wait until the toolchain exists.
local go_packages = { gopls = true, goimports = true, delve = true }
local has_go = vim.fn.executable('go') == 1
local installable_packages = vim.tbl_filter(function(name)
  return has_go or not go_packages[name]
end, mason_packages)

local registry = require("mason-registry")
registry.refresh(vim.schedule_wrap(function(success)
  if not success then
    vim.notify(
      "Could not refresh the Mason registry; tools were not installed",
      vim.log.levels.WARN
    )
    return
  end

  for _, name in ipairs(installable_packages) do
    local package_name = name
    local found, package = pcall(registry.get_package, name)
    if not found then
      vim.notify("Unknown Mason package: " .. name, vim.log.levels.WARN)
    elseif not package:is_installed() and not package:is_installing() then
      package:install({}, vim.schedule_wrap(function(installed, err)
        if not installed then
          vim.notify(
            string.format(
              "Mason could not install %s: %s",
              package_name,
              tostring(err or "unknown error")
            ),
            vim.log.levels.WARN
          )
        end
      end))
    end
  end
end))
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
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
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
    { name = "path" },
    { name = "buffer" },
  })
})

cmp.event:on(
  "confirm_done",
  require("nvim-autopairs.completion.cmp").on_confirm_done()
)

-- Common Lisp: use Vlime's omni completion via cmp-omni
cmp.setup.filetype('lisp', {
  sources = cmp.config.sources({
    { name = "omni" },
    { name = "buffer" },
  })
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = 'buffer' } },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
})

EOF
""" Completion setup

""" Jac development
lua << EOF
-- All variants (*.impl.jac, *.test.jac, *.cl.jac, etc.) share this extension.
vim.filetype.add({ extension = { jac = 'jac' } })

local function jac_executable()
  return vim.fn.expand(vim.g.jac_executable or 'jac')
end

local function jac_root(bufnr)
  -- Prefer the nearest Jac project over an enclosing monorepo's Git root.
  return vim.fs.root(bufnr, 'jac.toml')
    or vim.fs.root(bufnr, '.git')
    or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
    or vim.fn.getcwd()
end

local jac_group = vim.api.nvim_create_augroup('UserJac', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = jac_group,
  pattern = 'jac',
  callback = function(args)
    local options = vim.bo[args.buf]
    options.commentstring = '# %s'
    options.expandtab = true
    options.shiftwidth = 4
    options.softtabstop = 4
    options.tabstop = 4
    options.autoindent = true
    -- Brace indentation remains usable while the parser is being installed.
    options.smartindent = true
    options.formatoptions = options.formatoptions:gsub('[cro]', '')
  end,
})

local function jac_terminal(arguments, current_file, extra_arguments)
  local bufnr = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(bufnr)
  if vim.bo[bufnr].filetype ~= 'jac' or file == '' or vim.bo[bufnr].buftype ~= '' then
    vim.notify('Open a saved Jac file first', vim.log.levels.WARN)
    return
  end
  local executable = jac_executable()
  if vim.fn.executable(executable) ~= 1 then
    vim.notify('Jac was not found. Install Jac or set g:jac_executable; see :JacInfo', vim.log.levels.ERROR)
    return
  end

  vim.cmd('update')
  local root = jac_root(bufnr)
  local command = vim.list_extend({ executable }, vim.deepcopy(arguments))
  if current_file then
    table.insert(command, file)
  end
  vim.list_extend(command, extra_arguments)
  -- A split alone shares the source buffer. Starting a terminal in it would
  -- rename that source buffer to term://... while its LSP stays attached.
  vim.cmd('botright 12new')
  vim.fn.jobstart(command, { cwd = root, term = true })
  vim.cmd('startinsert')
end

local tasks = {
  JacRun = { { 'run' }, true, 'Run the current Jac file' },
  JacTest = { { 'test' }, true, 'Test the current Jac module' },
  JacTestProject = { { 'test' }, false, 'Test the Jac project' },
  JacCheck = { { 'check', '.' }, false, 'Type-check the Jac project' },
  JacLint = { { 'check', '.', '--lint' }, false, 'Lint the Jac project' },
  JacDebug = { { 'run', '--debug' }, true, 'Debug the current Jac file in Jdb' },
  JacStart = { { 'run', '--serve', '--dev' }, false, 'Start the Jac project development server' },
}
for name, task in pairs(tasks) do
  vim.api.nvim_create_user_command(name, function(opts)
    jac_terminal(task[1], task[2], opts.fargs)
  end, { nargs = '*', desc = task[3], force = true })
end

vim.api.nvim_create_user_command('JacInfo', function()
  local executable = jac_executable()
  local clients = vim.lsp.get_clients({ bufnr = 0, name = 'jac' })
  local parser_ok, parser = pcall(vim.treesitter.language.add, 'jac')
  local hover_files = vim.api.nvim_get_runtime_file('lua/jac_hover.lua', false)
  vim.notify(table.concat({
    'Jac executable: ' .. (vim.fn.exepath(executable) ~= '' and vim.fn.exepath(executable) or executable),
    'Executable available: ' .. tostring(vim.fn.executable(executable) == 1),
    'Project root: ' .. jac_root(0),
    'Attached Jac servers: ' .. #clients,
    'Tree-sitter parser available: ' .. tostring(parser_ok and parser == true),
    'Hover module: ' .. (hover_files[1] or 'MISSING: run python3 scripts/install.py from the init.vim repository'),
    'Hover lookup details: :JacHoverInfo',
    'LSP details: :checkhealth vim.lsp; parser details: :checkhealth nvim-treesitter',
  }, '\n'))
end, { desc = 'Show Jac tooling status', force = true })

vim.api.nvim_create_user_command('JacHoverInfo', function()
  local ok, hover = pcall(require, 'jac_hover')
  if ok then
    vim.notify(vim.inspect(hover.info()))
  else
    vim.notify('Jac hover module is missing. Run python3 scripts/install.py from the init.vim repository.\n' .. hover,
      vim.log.levels.ERROR)
  end
end, { desc = 'Diagnose Jac hover documentation', force = true })

_G.Jac = { executable = jac_executable, root = jac_root }
EOF
""" Jac development

""" LSP Configuration
lua << EOF
vim.g.markdown_fenced_languages = {
  "py=python",
  "ex=elixir",
  "go",
  "jac",
  "js=javascript",
  "ts=typescript",
}

local function show_signature_help()
  pcall(vim.lsp.buf.signature_help, {
    border = "rounded",
    focusable = true,
    max_width = math.min(100, math.floor(vim.o.columns * 0.6)),
    max_height = math.max(10, math.floor(vim.o.lines * 0.4)),
  })
end

local function show_hover()
  local diagnostic_win = vim.b.auto_diagnostic_float_win
  if diagnostic_win and vim.api.nvim_win_is_valid(diagnostic_win) then
    vim.api.nvim_win_close(diagnostic_win, true)
  end
  vim.b.auto_diagnostic_float_win = nil

  local hover = vim.lsp.buf.hover
  if vim.bo.filetype == 'jac' then
    local ok, jac_hover = pcall(require, 'jac_hover')
    if ok then
      hover = jac_hover.hover
    else
      vim.notify_once('Jac hover files are missing. Run python3 scripts/install.py from the init.vim repository, then restart Neovim.',
        vim.log.levels.WARN)
    end
  end
  hover({
    border = "rounded",
    focusable = true,
    max_width = math.min(100, math.floor(vim.o.columns * 0.6)),
    max_height = math.max(10, math.floor(vim.o.lines * 0.5)),
    wrap = true,
  })
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(ev)
    local bufnr = ev.buf
    local filetype = vim.bo[bufnr].filetype
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- Jedi owns Python navigation/completion/hover. Pyright contributes diagnostics
    -- without presenting duplicate results for the same language features.
    if client and client.name == 'pyright' then
      client.server_capabilities.completionProvider = nil
      client.server_capabilities.hoverProvider = false
      client.server_capabilities.signatureHelpProvider = nil
      client.server_capabilities.definitionProvider = false
      client.server_capabilities.declarationProvider = false
      client.server_capabilities.implementationProvider = false
      client.server_capabilities.referencesProvider = false
      client.server_capabilities.renameProvider = false
      client.server_capabilities.documentSymbolProvider = false
      client.server_capabilities.workspaceSymbolProvider = false
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    -- Don't override omnifunc for Common Lisp (Vlime handles it).
    if filetype ~= 'lisp' then
      vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    end

    vim.keymap.set('n', 'K', show_hover, {
      buffer = bufnr,
      silent = true,
      desc = 'Show hover documentation',
    })

    -- Automatically show Python signature help after '(' or ','.
    if filetype == 'python' and not vim.b[bufnr].lsp_signature_help_configured then
      vim.b[bufnr].lsp_signature_help_configured = true

      vim.api.nvim_create_autocmd('InsertCharPre', {
        buffer = bufnr,
        callback = function()
          if vim.v.char == '(' or vim.v.char == ',' then
            vim.schedule(show_signature_help)
          end
        end,
      })

      vim.api.nvim_create_autocmd('CursorHoldI', {
        buffer = bufnr,
        callback = function()
          local line = vim.api.nvim_get_current_line()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local before_cursor = col > 0 and line:sub(1, col) or ''

          if before_cursor:match('%(') and not before_cursor:match('%)') then
            show_signature_help()
          end
        end,
      })
    end
  end,
})

-- Extend nvim-lspconfig's server defaults with completion capabilities.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_servers = {
  'jedi_language_server',
  'pyright',
  'markdown_oxide',
  'tsc',
  'elixirls',
  'jac',
}

if vim.fn.executable('go') == 1 then
  table.insert(lsp_servers, 'gopls')
end

for _, server in ipairs(lsp_servers) do
  if server ~= 'pyright' then
    vim.lsp.config(server, { capabilities = capabilities })
  end
end

-- Jac ships its own stdio LSP; it does not need a Mason package or Python LSP.
vim.lsp.config('jac', {
  cmd = { _G.Jac.executable(), 'lsp' },
  filetypes = { 'jac' },
  capabilities = capabilities,
  root_dir = function(bufnr, on_dir)
    if vim.bo[bufnr].buftype ~= ''
      or vim.api.nvim_buf_get_name(bufnr):match('^%a[%w+.-]*://') then
      return
    end
    on_dir(_G.Jac.root(bufnr))
  end,
})

-- Define TypeScript 7 explicitly until nvim-lspconfig supplies a tsc config.
vim.lsp.config('tsc', {
  cmd = {
    vim.fs.joinpath(vim.fn.stdpath('data'), 'mason', 'bin', 'tsc'),
    '--lsp', '--stdio',
  },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, {
      'tsconfig.json', 'jsconfig.json', 'package.json', '.git',
    })
    on_dir(root or vim.fn.getcwd())
  end,
})

local function find_node_executable()
  local from_path = vim.fn.exepath('node')
  if from_path ~= '' then
    return from_path
  end

  local candidates = vim.fn.glob(
    vim.fn.expand('~/.asdf/installs/nodejs/*/bin/node'),
    false,
    true
  )
  table.sort(candidates, function(left, right)
    local left_version = vim.version.parse(left:match('/nodejs/([^/]+)/bin/node$') or '')
    local right_version = vim.version.parse(right:match('/nodejs/([^/]+)/bin/node$') or '')
    if left_version and right_version then
      return vim.version.gt(left_version, right_version)
    end
    return left > right
  end)

  for _, candidate in ipairs(candidates) do
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end
end

local pyright_config = {
  capabilities = vim.deepcopy(capabilities),
  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'standard',
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
}

-- Pyright 1.1.411 can dynamically register the pull-diagnostics provider
-- several times with Nvim 0.12. Duplicate empty responses then clear valid
-- results. Let Pyright use its established publishDiagnostics path until the
-- Nvim 0.13 diagnostic client is available.
if vim.fn.has('nvim-0.12') == 1 and vim.fn.has('nvim-0.13') == 0 then
  pyright_config.before_init = function(params)
    if params.capabilities.textDocument then
      params.capabilities.textDocument.diagnostic = nil
    end
    if params.capabilities.workspace then
      params.capabilities.workspace.diagnostics = nil
    end
  end
end

local node = find_node_executable()
if node then
  -- GUI-launched Nvim may not inherit asdf's Node.js path. Mason's npm tools
  -- (Pyright and markdownlint-cli2) need it in their child-process PATH.
  local node_dir = vim.fs.dirname(node)
  local path_separator = package.config:sub(1, 1) == '\\' and ';' or ':'
  local path_entries = vim.split(vim.env.PATH or '', path_separator, { plain = true })
  if not vim.list_contains(path_entries, node_dir) then
    vim.env.PATH = node_dir .. path_separator .. (vim.env.PATH or '')
  end

  pyright_config.cmd = {
    node,
    vim.fs.joinpath(
      vim.fn.stdpath('data'),
      'mason',
      'packages',
      'pyright',
      'node_modules',
      'pyright',
      'langserver.index.js'
    ),
    '--stdio',
  }
else
  vim.notify('Node.js was not found; Pyright cannot start', vim.log.levels.WARN)
end

vim.lsp.config('pyright', pyright_config)

vim.lsp.enable(lsp_servers)
EOF
""" LSP Configuration

augroup lisp_vlime
  autocmd!
  autocmd FileType lisp setlocal omnifunc=vlime#plugin#CompleteFunc
augroup END

""" Go development
lua << EOF
local dap_ready, dap = pcall(require, 'dap')
local dap_go_ready, dap_go = pcall(require, 'dap-go')
if dap_ready and dap_go_ready then
  dap_go.setup()
end

vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticSignWarn' })

local function go_terminal(arguments, current_package)
  local file = vim.api.nvim_buf_get_name(0)
  if vim.bo.filetype ~= 'go' or file == '' then
    vim.notify('Open a saved Go file first', vim.log.levels.WARN)
    return
  end
  if vim.fn.executable('go') ~= 1 then
    vim.notify('Go is not on PATH', vim.log.levels.ERROR)
    return
  end

  vim.cmd('update')
  local cwd = current_package and vim.fs.dirname(file)
    or vim.fs.root(file, { 'go.work', 'go.mod' })
    or vim.fs.dirname(file)
  vim.cmd('botright 12split')
  vim.fn.termopen(vim.list_extend({ 'go' }, arguments), { cwd = cwd })
  vim.cmd('startinsert')
end

vim.api.nvim_create_user_command('GoTest', function()
  go_terminal({ 'test', './...' })
end, {})
vim.api.nvim_create_user_command('GoBuild', function()
  go_terminal({ 'build', './...' })
end, {})
vim.api.nvim_create_user_command('GoVet', function()
  go_terminal({ 'vet', './...' })
end, {})
vim.api.nvim_create_user_command('GoRun', function()
  go_terminal({ 'run', '.' }, true)
end, {})

local function debug_action(callback)
  return function()
    if not dap_ready or not dap_go_ready then
      vim.notify('Install Go debugger plugins with :PlugInstall', vim.log.levels.WARN)
      return
    end
    callback()
  end
end

_G.GoDebug = {
  continue = debug_action(function() dap.continue() end),
  breakpoint = debug_action(function() dap.toggle_breakpoint() end),
  next = debug_action(function() dap.step_over() end),
  into = debug_action(function() dap.step_into() end),
  out = debug_action(function() dap.step_out() end),
  stop = debug_action(function() dap.terminate() end),
  test = debug_action(function() dap_go.debug_test() end),
}
EOF
""" Go development

""" Linting and Formatting Configuration
lua << EOF
-- Linting Configuration
local lint = require('lint')

lint.linters_by_ft = {
  python = {'ruff'},
  elixir = {'credo'},
  markdown = {'markdownlint-cli2'},
}

local function diagnostic_format(diag)
  local code = diag.code and (" [" .. tostring(diag.code) .. "]") or ""
  return diag.message .. code
end

local function diagnostic_list_format(diag)
  local source = diag.source or "diagnostic"
  local code = diag.code and (":" .. tostring(diag.code)) or ""
  return string.format("[%s%s] %s", source, code, diag.message:gsub("\n", " "))
end

_G.UserDiagnostics = {
  jump = function(count, severity)
    local diagnostic = vim.diagnostic.jump({
      count = count,
      severity = severity,
      wrap = true,
    })
    if not diagnostic then
      return
    end

    vim.schedule(function()
      local _, winid = vim.diagnostic.open_float({
        bufnr = diagnostic.bufnr,
        scope = "cursor",
        pos = { diagnostic.lnum, diagnostic.col },
        focusable = false,
        border = "rounded",
        source = true,
        format = diagnostic_format,
        close_events = {
          "BufHidden",
          "CursorMoved",
          "CursorMovedI",
          "InsertEnter",
          "WinLeave",
        },
      })
      vim.b[diagnostic.bufnr].auto_diagnostic_float_win = winid
    end)
  end,
}

-- Show every diagnostic on the current line in a focusable popup.
vim.api.nvim_create_user_command("ShowDiagnostics", function()
  vim.diagnostic.open_float({
    scope = "line",
    border = "rounded",
    focusable = true,
    source = true,
    format = diagnostic_format,
  })
end, {})

-- Function to count diagnostics and update status line
local function update_diagnostics_status(bufnr)
  if bufnr ~= vim.api.nvim_get_current_buf() then
    return
  end

  local diagnostics = vim.diagnostic.get(bufnr)
  local error_count = 0
  local warn_count = 0
  local info_count = 0
  local hint_count = 0
  local first_error
  local first_warning
  local first_info
  local first_hint

  for _, diag in ipairs(diagnostics) do
    if diag.severity == vim.diagnostic.severity.ERROR then
      error_count = error_count + 1
      first_error = math.min(first_error or math.huge, diag.lnum + 1)
    elseif diag.severity == vim.diagnostic.severity.WARN then
      warn_count = warn_count + 1
      first_warning = math.min(first_warning or math.huge, diag.lnum + 1)
    elseif diag.severity == vim.diagnostic.severity.INFO then
      info_count = info_count + 1
      first_info = math.min(first_info or math.huge, diag.lnum + 1)
    elseif diag.severity == vim.diagnostic.severity.HINT then
      hint_count = hint_count + 1
      first_hint = math.min(first_hint or math.huge, diag.lnum + 1)
    end
  end

  local status = {}
  if error_count > 0 then
    table.insert(status, string.format("E:%d@%d", error_count, first_error))
  end
  if warn_count > 0 then
    table.insert(status, string.format("W:%d@%d", warn_count, first_warning))
  end
  if info_count > 0 then
    table.insert(status, string.format("I:%d@%d", info_count, first_info))
  end
  if hint_count > 0 then
    table.insert(status, string.format("H:%d@%d", hint_count, first_hint))
  end
  vim.g.diagnostic_status = table.concat(status, " ")
  vim.cmd.redrawstatus()
end

local diagnostic_group = vim.api.nvim_create_augroup("UserDiagnostics", { clear = true })

local function lint_buffer(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then
    return
  end

  vim.api.nvim_buf_call(bufnr, function()
    local path = vim.api.nvim_buf_get_name(bufnr):gsub("\\", "/")
    local filetype = vim.bo[bufnr].filetype
    if path:match("%.github/workflows/") then
      lint.try_lint("actionlint")
    elseif filetype == "python" then
      lint.try_lint("ruff")
    elseif filetype == "markdown" then
      lint.try_lint("markdownlint-cli2")
    elseif filetype == "elixir" then
      local root = vim.fs.root(bufnr, { "mix.exs" })
      if root then
        lint.try_lint("credo", { cwd = root })
      end
    end
  end)
end

-- LSP diagnostics update while editing; external linters run when a supported
-- file is opened and saved to keep the IDE responsive and results current.
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  group = diagnostic_group,
  pattern = {
    "*.py", "*.ex", "*.exs", "*.md", "*.markdown", "*.yml", "*.yaml",
  },
  callback = function(args)
    lint_buffer(args.buf)
  end,
})

vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufEnter" }, {
  group = diagnostic_group,
  callback = function(args)
    update_diagnostics_status(args.buf)
  end,
})

-- Clean diagnostics: signs + hover popup only
vim.diagnostic.config({
  virtual_text = false,  -- No inline text
  signs = {
    priority = 20,
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.INFO] = "I",
      [vim.diagnostic.severity.HINT] = "H",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticLineNrError",
      [vim.diagnostic.severity.WARN] = "DiagnosticLineNrWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticLineNrInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticLineNrHint",
    },
  },
  underline = true,
  severity_sort = true,
  update_in_insert = false,
  float = {
    border = "rounded",
    source = true,
    format = diagnostic_format,
  },
})

-- Show a non-focus-stealing popup only when the cursor rests on a line with
-- diagnostics. Explicit LSP hover closes it before opening documentation.
vim.api.nvim_create_autocmd("CursorHold", {
  group = diagnostic_group,
  callback = function(args)
    if vim.fn.mode() ~= "n" or #vim.diagnostic.get(args.buf, {
      lnum = vim.api.nvim_win_get_cursor(0)[1] - 1,
    }) == 0 then
      return
    end

    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).relative ~= "" then
        return
      end
    end

    local _, winid = vim.diagnostic.open_float({
      bufnr = args.buf,
      scope = "line",
      focusable = false,
      border = "rounded",
      source = true,
      format = diagnostic_format,
      close_events = {
        "BufHidden",
        "CursorMoved",
        "CursorMovedI",
        "InsertEnter",
        "WinLeave",
      },
    })
    vim.b[args.buf].auto_diagnostic_float_win = winid
  end,
})

-- Put all diagnostics for the current buffer in a navigable location list.
vim.api.nvim_create_user_command("LintLocations", function()
  vim.diagnostic.setloclist({
    open = true,
    title = "Buffer diagnostics",
    format = diagnostic_list_format,
  })
end, {})

vim.api.nvim_create_user_command("DiagnosticsWorkspace", function()
  vim.diagnostic.setqflist({
    open = true,
    title = "Workspace diagnostics",
    format = diagnostic_list_format,
  })
end, {})


require("conform").setup({
  formatters_by_ft = {
    jac = { lsp_format = 'prefer' }, -- The Jac LSP formats the in-memory buffer.
    go = { "goimports" },
    python = { "ruff_organize_imports", "ruff_format" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    markdown = { "prettier" },
    elixir = { "mix" },
    eelixir = { "mix" },
    heex = { "mix" },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
  format_on_save = function(bufnr)
    if vim.bo[bufnr].buftype ~= "" then
      return
    end
    return { timeout_ms = 2000, lsp_format = "fallback" }
  end,
  notify_no_formatters = false,
})

EOF
""" Linting, formatting configuration

""" nvim-treesitter Configuration
lua << EOF
local function large_file(bufnr)
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  return ok and stats and stats.size > 200 * 1024
end

local treesitter = require("nvim-treesitter")
treesitter.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

-- On main, queries are installed separately from parsers. Keep the bundled
-- queries available when the CLI cannot run or installation is incomplete.
vim.opt.runtimepath:append(vim.fs.joinpath(vim.g.plugs["nvim-treesitter"].dir, "runtime"))
-- The JSON grammar also accepts comments; use its queries for JSONC buffers.
vim.treesitter.language.register("json", "jsonc")

-- nvim-treesitter MAIN uses a parser table and TSUpdate event, not the old
-- get_parser_configs()/configs.setup() APIs in many Jac setup examples.
local function register_jac_parser()
  require('nvim-treesitter.parsers').jac = {
    install_info = {
      url = 'https://github.com/jaseci-labs/tree-sitter-jac',
      branch = 'main',
      queries = 'queries/jac',
    },
    tier = 2,
  }
end
vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('UserJacParser', { clear = true }),
  pattern = 'TSUpdate',
  callback = register_jac_parser,
})
register_jac_parser()

local ensure_installed = {
  "vim",
  "vimdoc",
  "query",
  "python",
  "jac",
  "go",
  "gomod",
  "gowork",
  "gosum",
  "commonlisp",
  "elixir",
  "eex",
  "heex",
  "typescript",
  "javascript",
  "jsdoc",
  "markdown",
  "markdown_inline",
  "html",
  "yaml",
  "json",
  "toml",
}

-- The rewritten plugin uses tree-sitter-cli to build parsers. executable()
-- alone is insufficient: an incompatible ELF binary can have execute bits but
-- still fail with ENOENT when its program loader is unavailable.
local function tree_sitter_cli_works()
  local executable = vim.fn.exepath("tree-sitter")
  if executable == "" then
    return false
  end

  local ok, result = pcall(function()
    return vim.system({ executable, "--version" }, { text = true }):wait()
  end)
  return ok and result.code == 0
end

if tree_sitter_cli_works() then
  treesitter.install(ensure_installed)
end

local fold_filetypes = {
  jac = true,
  toml = true,
  go = true,
  python = true,
  lisp = true,
  elixir = true,
  eelixir = true,
  heex = true,
  typescript = true,
  javascript = true,
  markdown = true,
  json = true,
  jsonc = true,
  yaml = true,
  vim = true,
}

local treesitter_group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = treesitter_group,
  pattern = "*",
  callback = function(args)
    if large_file(args.buf) or vim.bo[args.buf].buftype ~= "" then
      return
    end

    local filetype = vim.bo[args.buf].filetype
    local language = vim.treesitter.language.get_lang(filetype)
    if not language then
      return
    end

    local loaded, available = pcall(vim.treesitter.language.add, language)
    if not loaded or not available then
      return
    end

    -- Starting without a usable query disables regex syntax but adds no colour.
    -- Leave the built-in syntax active when parsers/queries are unavailable.
    local queried, highlights = pcall(vim.treesitter.query.get, language, "highlights")
    if not queried or not highlights then
      return
    end

    if not pcall(vim.treesitter.start, args.buf, language) then
      return
    end

    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    if fold_filetypes[filetype] then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
  end,
})

-- Incremental selection moved into Neovim 0.12. The public wrapper landed
-- after 0.12.0, so retain a fallback to the implementation shipped in 0.12.0.
local function select_tree(target)
  if vim.treesitter.select then
    vim.treesitter.select(target)
    return
  end

  local select = require("vim.treesitter._select")
  select[target == "parent" and "select_parent" or "select_child"](1)
end

vim.keymap.set("n", "gnn", function() select_tree("child") end,
  { desc = "Initialize Treesitter Selection" })
vim.keymap.set("x", "grn", function() select_tree("parent") end,
  { desc = "Increment Treesitter Selection" })
vim.keymap.set("x", "grc", function() select_tree("parent") end,
  { desc = "Increment Treesitter Scope Selection" })
vim.keymap.set("x", "grm", function() select_tree("child") end,
  { desc = "Decrement Treesitter Selection" })
EOF
""" nvim-treesitter Configuration

" Show context
lua << EOF
require('treesitter-context').setup({
  enable = true,
  max_lines = 5,
  multiline_threshold = 12,
  separator = "─",
})
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
"" Mappings handled by which-key
"" Mappings
"" Completion handled by which-key
" Statusline
augroup FzfStatusline
  autocmd!
  autocmd FileType fzf set laststatus=0 noshowmode noruler
        \| autocmd BufLeave <buffer> set laststatus=3 noshowmode ruler
augroup END
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

""" gitsigns.nvim
lua << EOF
require('gitsigns').setup({
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
  },
  preview_config = {
    border = 'shadow',
    style = 'minimal',
  },
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 500,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> (<abbrev_sha>) • <summary>',
})
EOF

nnoremap <leader>hp <cmd>Gitsigns preview_hunk<CR>
nnoremap <leader>hb <cmd>Gitsigns toggle_current_line_blame<CR>
nnoremap ]h <cmd>Gitsigns next_hunk<CR>
nnoremap [h <cmd>Gitsigns prev_hunk<CR>
""" gitsigns.nvim

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
    key = {
      { "<Space>", "SPC" },
      { "<CR>", "RET" },
      { "<Tab>", "TAB" },
    },
  },

  win = {
    border = "shadow",
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

local git_conflict_heads = {
  "MERGE_HEAD",
  "REBASE_HEAD",
  "REVERT_HEAD",
  "CHERRY_PICK_HEAD",
}

local function git_command(cwd, args)
  local command = { "git", "-C", cwd }
  vim.list_extend(command, args)
  return vim.system(command, { text = true }):wait()
end

local function current_git_root()
  local cwd = vim.fn.expand("%:p:h")
  if cwd == "" or vim.fn.isdirectory(cwd) == 0 then
    cwd = vim.uv.cwd()
  end

  local result = git_command(cwd, { "rev-parse", "--show-toplevel" })
  if result.code ~= 0 then
    return nil
  end

  return vim.trim(result.stdout)
end

local function missing_merge_base(root)
  for _, head in ipairs(git_conflict_heads) do
    local exists = git_command(root, { "rev-parse", "--verify", "--quiet", head })
    if exists.code == 0 then
      local merge_base = git_command(root, { "merge-base", "HEAD", head })
      if merge_base.code ~= 0 then
        return head
      end
      return nil
    end
  end
end

local function open_fugitive_conflict(root, conflicts, conflict_head)
  local current_file = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
  local selected_file = conflicts[1]

  for _, path in ipairs(conflicts) do
    if current_file == vim.fs.normalize(root .. "/" .. path) then
      selected_file = path
      break
    end
  end

  local selected_path = vim.fs.normalize(root .. "/" .. selected_file)
  if current_file ~= selected_path then
    vim.cmd("tabedit " .. vim.fn.fnameescape(selected_path))
  end

  vim.notify(
    string.format("No merge base for %s; using Fugitive's index-stage conflict view", conflict_head),
    vim.log.levels.WARN
  )
  vim.cmd("Gdiffsplit!")
end

-- Open Git's unmerged files, falling back when Diffview cannot find a merge base.
_G.conflict.open_conflicts = function()
  local root = current_git_root()
  if not root then
    vim.notify("Current buffer is not in a Git repository", vim.log.levels.ERROR)
    return
  end

  local result = git_command(root, { "diff", "--name-only", "--diff-filter=U", "-z" })
  if result.code ~= 0 then
    local message = vim.trim(result.stderr or "")
    vim.notify(message ~= "" and message or "Could not inspect Git conflicts", vim.log.levels.ERROR)
    return
  end

  local conflicts = vim.split(result.stdout, "\0", { plain = true, trimempty = true })
  if #conflicts == 0 then
    vim.notify("No merge conflicts found", vim.log.levels.INFO)
    return
  end

  local conflict_head = missing_merge_base(root)
  if conflict_head then
    open_fugitive_conflict(root, conflicts, conflict_head)
    return
  end

  vim.cmd("DiffviewOpen")
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

  -- LSP actions
  { "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code Action" },
  { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename Symbol" },

  -- LSP diagnostics
  { "<leader>l", group = "LSP / Diagnostics" },
  { "<leader>ld", "<cmd>LintLocations<CR>", desc = "List buffer diagnostics" },
  { "<leader>lD", "<cmd>DiagnosticsWorkspace<CR>", desc = "List workspace diagnostics" },
  { "<leader>lh", "<cmd>ShowDiagnostics<CR>", desc = "Show line diagnostics" },
  { "<leader>ln", function()
      _G.UserDiagnostics.jump(1)
    end, desc = "Next diagnostic" },
  { "<leader>lp", function()
      _G.UserDiagnostics.jump(-1)
    end, desc = "Previous diagnostic" },
  { "<leader>le", function()
      _G.UserDiagnostics.jump(1, vim.diagnostic.severity.ERROR)
    end, desc = "Next error" },
  { "<leader>lE", function()
      _G.UserDiagnostics.jump(-1, vim.diagnostic.severity.ERROR)
    end, desc = "Previous error" },
  { "<leader>lw", function()
      _G.UserDiagnostics.jump(1, vim.diagnostic.severity.WARN)
    end, desc = "Next warning" },
  { "<leader>lW", function()
      _G.UserDiagnostics.jump(-1, vim.diagnostic.severity.WARN)
    end, desc = "Previous warning" },
  { "[d", function()
      _G.UserDiagnostics.jump(-1)
    end, desc = "Previous diagnostic" },
  { "]d", function()
      _G.UserDiagnostics.jump(1)
    end, desc = "Next diagnostic" },

  -- IPython/Slime integration
  { "<localleader>c", "<cmd>call SlimeSendCell()<CR>", desc = "Send Cell to IPython" },
  { "<localleader>l", "<cmd>SlimeSendCurrentLine<CR>", desc = "Send Line to IPython" },
  { "<localleader>v", "<cmd>SlimeSend<CR>", desc = "Send to IPython" },

  -- Format
  { "<leader>==", function()
      require('conform').format({ lsp_format = "fallback" })
    end, desc = "Format file" },
  { "<leader>=j", "<cmd>Format<CR>", desc = "Format JSON with jq"},

  -- Text-to-Speech group
  { "<leader>t", group = "Text-to-Speech" },
  { "<leader>ts", _G.PiperTTS.stop, desc = "Stop Speech" },
  { "<leader>tw", _G.PiperTTS.word, desc = "Speak Word" },
  { "<leader>tc", _G.PiperTTS.line, desc = "Speak Current Line" },
  { "<leader>tp", _G.PiperTTS.paragraph, desc = "Speak Paragraph" },
  { "<leader>tf", _G.PiperTTS.file, desc = "Speak File" },

  -- Markdown and Marp
  { "<leader>m", group = "Markdown / Marp" },
  { "<leader>mp", function() _G.ToggleMarpPreview() end, desc = "Toggle Marp Preview" },
  { "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle Markdown Rendering" },
  { "<leader>mv", "<cmd>LivePreview start<CR>", desc = "Preview Markdown in Browser" },

  -- Git operations with conflict resolution
  { "<leader>g", group = "Git" },
  { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diff View" },
  { "<leader>gm", "<cmd>lua _G.conflict.open_conflicts()<CR>", desc = "Merge Conflicts View" },
  { "<leader>gc", "<cmd>lua _G.conflict.open_conflicts()<CR>", desc = "Open Conflicts" },
  { "<leader>gx", "<cmd>DiffviewClose<CR>", desc = "Close Diff View" },
  { "<leader>go", "<cmd>lua _G.conflict.accept_current()<CR>", desc = "Accept Current Changes" },
  { "<leader>gt", "<cmd>lua _G.conflict.accept_incoming()<CR>", desc = "Accept Incoming Changes" },
  { "<leader>gb", "<cmd>lua _G.conflict.accept_both()<CR>", desc = "Accept Both Changes" },
  { "<leader>gh", group = "Hunk" },
  { "<leader>ghp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview Hunk" },
  { "<leader>ghb", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Blame" },

  -- Git hunk navigation (use :Gdiffsplit, :Gblame, etc. from fugitive)
  { "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Go to Declaration" },
  { "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Go to Definition" },
  { "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Go to Implementation" },
  { "gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "Find References" },
  { "gh", "<cmd>ShowDiagnostics<CR>", desc = "Show Diagnostics" },
  { "gnn", desc = "Initialize Treesitter Selection" },

  -- [ and ] mappings
  { "[c", "<cmd>?^# %%<CR>", desc = "Previous Cell" },
  { "]c", "<cmd>/^# %%<CR>", desc = "Next Cell" },
  { "[g", "<cmd>lua _G.conflict.prev()<CR>", desc = "Previous Conflict" },
  { "]g", "<cmd>lua _G.conflict.next()<CR>", desc = "Next Conflict" },

  -- Function key mappings
  { "<F8>", "<cmd>TagbarToggle<CR>", desc = "Toggle Tagbar" },
  { "<F9>", "i# %%<CR><ESC>", desc = "Insert Cell Above" },
  { "<F10>", "o# %%<CR>", desc = "Insert Cell Below" },

  -- Ollama commands
  { "<leader>o", group = "Ollama" },
  { "<leader>os", "<cmd>lua require('ollama').serve_start()<CR>", desc = "Start Ollama Server" },
  { "<leader>ox", "<cmd>lua require('ollama').serve_stop()<CR>", desc = "Stop Ollama Server" },

  -- Jac commands (shared LSP mappings provide hover, navigation, rename, etc.).
  { "<leader>j", group = "Jac" },
  { "<leader>jr", "<cmd>JacRun<CR>", desc = "Run current file" },
  { "<leader>jt", "<cmd>JacTest<CR>", desc = "Test current module" },
  { "<leader>jT", "<cmd>JacTestProject<CR>", desc = "Test project" },
  { "<leader>jc", "<cmd>JacCheck<CR>", desc = "Type-check project" },
  { "<leader>jl", "<cmd>JacLint<CR>", desc = "Lint project" },
  { "<leader>jd", "<cmd>JacDebug<CR>", desc = "Debug current file (Jdb)" },
  { "<leader>jS", "<cmd>JacStart<CR>", desc = "Start development server" },
  { "<leader>js", vim.lsp.buf.document_symbol, desc = "Document symbols" },
  { "<leader>ji", "<cmd>JacInfo<CR>", desc = "Jac tooling status" },

  -- Elixir commands
  { "<leader>e", group = "Elixir" },
  { "<leader>ef", "<cmd>!mix format %<CR>", desc = "Format current file" },
  { "<leader>et", "<cmd>!mix test<CR>", desc = "Run all tests" },
  { "<leader>ec", "<cmd>!mix compile<CR>", desc = "Compile project" },
  { "<leader>er", "<cmd>LspRestart elixirls<CR>", desc = "Restart Elixir LS" },
  { "<leader>eq", "<cmd>!mix credo suggest<CR>", desc = "Run Credo analysis" },

  -- Go build, test, and Delve debugging
  { "<leader>G", group = "Go" },
  { "<leader>Gt", "<cmd>GoTest<CR>", desc = "Test all packages" },
  { "<leader>Gb", "<cmd>GoBuild<CR>", desc = "Build all packages" },
  { "<leader>Gr", "<cmd>GoRun<CR>", desc = "Run current package" },
  { "<leader>Gv", "<cmd>GoVet<CR>", desc = "Vet all packages" },
  { "<leader>Gc", _G.GoDebug.continue, desc = "Start or continue debugger" },
  { "<leader>Gp", _G.GoDebug.breakpoint, desc = "Toggle breakpoint" },
  { "<leader>Gn", _G.GoDebug.next, desc = "Step over" },
  { "<leader>Gi", _G.GoDebug.into, desc = "Step into" },
  { "<leader>Go", _G.GoDebug.out, desc = "Step out" },
  { "<leader>Gq", _G.GoDebug.stop, desc = "Stop debugger" },
  { "<leader>Gd", _G.GoDebug.test, desc = "Debug nearest test" },

  -- Common Lisp / Vlime
  { "<localleader>r", group = "SWANK Server" },
  { "<localleader>s", group = "Eval / Send" },
  { "<localleader>d", group = "Describe / Doc" },
  { "<localleader>w", group = "Window" },
  { "<localleader>I", group = "Inspect" },

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

  -- Ollama keybindings
  { "<C-x><C-o>", desc = "Ollama AI completion" },

  -- IPython
  { "<F9>", "<C-o>i# %%<CR>", desc = "Insert Cell Above" },
  { "<F10>", "<C-o>o# %%<CR>", desc = "Insert Cell Below" },
}, { mode = "i" })

-- Visual mode mappings
wk.add({
  mode = "x",
  -- IPython
  { "<localleader>v", ":'<,'>SlimeSend<CR>", desc = "Send Selection to IPython" },
  { "<leader>==", function()
      require('conform').format({ lsp_format = "fallback" })
    end, desc = "Format selection" },
  { "<leader>t", group = "Text-to-Speech" },
  { "<leader>ts", _G.PiperTTS.stop, desc = "Stop Speech" },
  { "<leader>tv", _G.PiperTTS.visual, desc = "Speak Selection" },
})

-- Operator pending mode mappings
wk.add({}, { mode = "o" })
EOF
""" which-key configuration

""" Jupyter notebook
augroup NotebookInplace
  autocmd!
  autocmd BufReadCmd *.ipynb call s:OpenNotebook(fnamemodify(expand('<amatch>'), ':p'))
  autocmd BufWriteCmd *.ipynb call s:SaveNotebook()
augroup END

function! s:OpenNotebook(path) abort
  if !executable('jupytext')
    echoerr 'jupytext is required to open notebooks'
    return
  endif

  let l:json = join(readfile(a:path), "\n")
  let l:py = system(['jupytext', '--to', 'py:percent', '--from', 'ipynb', '-'], l:json)
  if v:shell_error != 0
    echoerr 'jupytext could not convert ' . a:path
    return
  endif

  silent %delete _
  call setline(1, split(l:py, "\n", 1))
  let b:__real_ipynb = a:path
  setlocal buftype=acwrite
  setlocal bufhidden=hide
  setlocal filetype=python
  setlocal noswapfile
  setlocal nomodified
endfunction

function! s:SaveNotebook() abort
  if !exists('b:__real_ipynb')
    echoerr 'Notebook path is unavailable'
    return
  endif

  let l:cells = join(getbufline('%', 1, '$'), "\n")
  let l:json = system(['jupytext', '--to', 'ipynb', '--from', 'py:percent', '-'], l:cells)
  if v:shell_error != 0
    echoerr 'jupytext could not convert this notebook; the original was not changed'
    return
  endif

  try
    call json_decode(l:json)
  catch
    echoerr 'jupytext returned invalid notebook JSON; the original was not changed'
    return
  endtry

  if writefile(split(l:json, "\n"), b:__real_ipynb) != 0
    echoerr 'Could not write notebook: ' . b:__real_ipynb
    return
  endif
  setlocal nomodified
endfunction
""" Jupyter notebook

""" nvim-colorizer
lua << EOF
require("colorizer").setup()
EOF
""" nvim-colorizer

""" Markdown and Marp
lua << EOF
require('render-markdown').setup({
  completions = { lsp = { enabled = true } },
})

local marp_process
local stopping_marp = false

local function marp_executable()
  local from_path = vim.fn.exepath("marp")
  if from_path ~= "" then
    return from_path
  end
  for _, candidate in ipairs({ "~/AppImages/marp", "~/.local/bin/marp" }) do
    local path = vim.fn.expand(candidate)
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
end

_G.ToggleMarpPreview = function()
  if marp_process then
    if stopping_marp then
      vim.notify("Marp preview is still stopping")
      return
    end
    stopping_marp = true
    marp_process:kill(15)
    vim.notify("Marp preview stopped")
    return
  end

  local executable = marp_executable()
  local file = vim.api.nvim_buf_get_name(0)
  if not executable then
    vim.notify("Marp executable not found", vim.log.levels.ERROR)
    return
  elseif vim.bo.filetype ~= "markdown" or file == "" then
    vim.notify("Marp preview requires a saved Markdown file", vim.log.levels.ERROR)
    return
  end

  stopping_marp = false
  local process
  process = vim.system({ executable, "--preview", file }, { text = true }, function(result)
    vim.schedule(function()
      if marp_process == process then
        marp_process = nil
      end
      if result.code ~= 0 and not stopping_marp then
        vim.notify("Marp preview failed: " .. vim.trim(result.stderr or ""), vim.log.levels.ERROR)
      end
      stopping_marp = false
    end)
  end)
  marp_process = process
  vim.notify("Marp preview started")
end
EOF
""" Markdown and Marp
