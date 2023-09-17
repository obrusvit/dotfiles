" Sections:
"    -> vim-plug setting
"    -> General
"    -> Command improvements
"    -> Plugins setting
"    -> Files browsing and netrw
"    -> Colors and Fonts
"    -> Helper functions

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" install vim-plug if not there
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

" languages support
Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install', 'for': 'python' }
" A.L.E. for linting
Plug 'dense-analysis/ale'
" YouCompleteMe
Plug 'ycm-core/YouCompleteMe'
Plug 'ycm-core/lsp-examples'
" vimspector - debugger
Plug 'puremourning/vimspector'
" UltiSnips engine & snippets
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" better code folding using 'zc' 'zo' commands
Plug 'tmhedberg/SimpylFold'

" fzf (fuzzy finder) & integration
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Auto Pairs - Insert or delete brackets, parens, quotes in pair.
Plug 'jiangmiao/auto-pairs'

" Solarized colorscheme
Plug 'altercation/vim-colors-solarized'

" Status tabline 
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/vim-airline/vim-airline-themes'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

" Sets how many lines of history VIM has to remember (default is 50)
set history=500

" Set to auto read when a file is changed from the outside
set autoread

" Display line nums not as absolute but relative to the cursor
set relativenumber

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the Wild menu
set wildmenu
set wildmode=longest:full,full

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch 

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set belloff=all

" Add a bit extra margin to the left
set foldcolumn=1

" Show line numbers
set nu 

" Set vim to use system clipboard, copied text from vim can
" be pasted with CTRL+v elsewhere and copied text with 
" CTRL+c from elsewhere can be pasted to vim with 'p'
set clipboard=unnamed
set clipboard=unnamedplus

" see the command you're typing (bottom right)
set showcmd

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

" indent
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
    
" Set utf8 as standard encoding
set encoding=utf8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Command improvements
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" leader
let mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>
" :W sudo saves the file (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" Remap VIM 0 to first non-blank character
map 0 ^

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tl :tabnext<cr>
map <leader>th :tabprev<cr>
map <leader>tm :tabmove 
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" vnoremap <silent> <leader>ag :<C-u>call VisualSelection('', '')<CR>:Ag <C-R>=@/<CR><CR>
vnoremap <silent> Ag :<C-u>call VisualSelection('', '')<CR>:Ag <C-R>=@/<CR><CR>

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" write long part - delimmiting line comment with <leader>/
if has("autocmd")
    augroup delimitingComments
        autocmd FileType c,cpp,java,kotlin map <leader>/ O<ESC>o<ESC>2i/<ESC>78a-<ESC>
        autocmd FileType python,julia map <leader>/ O<ESC>o<ESC>1i# <ESC>79a=<ESC>
    augroup END
endif

" remove trailing spaces on save
if has("autocmd")
    autocmd BufWritePre *.txt,*.py,*.wiki,*.sh :call CleanExtraSpaces()
endif

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" spellchecing shortcuts
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" YouCompleteMe (YCM)
"""""""""""""""""""""
" set to 1 if you don't want to use YCM
" let g:loaded_youcompleteme = 1

" commands for YCM
" NOTE: ctrl-r, ctrl-w brings the word under cursor
nmap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
nmap <leader>yg :YcmCompleter GoToDefinitionElseDeclaration<CR>
nmap <leader>yo :YcmCompleter GoToDocumentOutline<CR>
nmap <leader>yq :YcmCompleter GoToReferences<CR>
nmap <leader>yc :YcmCompleter GoToCallers<CR>
nmap <leader>yf :YcmCompleter FixIt<CR>
nmap <leader>yd :YcmCompleter GetDoc<CR>
nmap <leader>yr :YcmCompleter RefactorRename <C-R><C-W> 

command Fmt YcmCompleter Format

" settings for YCM
" default fallback for YcmCompleter extra conf file
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

" =0 automatically load .ycm_extra_conf
" WARNING car run malicious code, switch to 1 if not needed
let g:ycm_confirm_extra_conf = 1

" turn off the diagnostics whatsoever
"let g:ycm_show_diagnostics_ui = 0

" turn off the signs (arrows) on the left side of the screen (it can shift code to the right)
"let g:ycm_enable_diagnostic_signs = 0
"set signcolumn=no " other option"

" turn off highlighting in red (it can reduce syntax to grey underlined)
let g:ycm_enable_diagnostic_highlighting = 0

"
let g:ycm_update_diagnostics_in_insert_mode = 1
" let g:ycm_echo_current_diagnostic = 1
" Or, when you have Vim supporting virtual text
let g:ycm_echo_current_diagnostic = 'virtual-text'

" let g:ycm_max_num_candidates_to_detail = 1

" Vimspector
"""""""""""""
set mouse=a
let g:vimspector_enable_mappings = 'HUMAN'

" UltiSnips 
"""""""""""""
let g:UltiSnipsExpandTrigger="<c-l>"  "Ctrl-L

" SimplyFold
"""""""""""""
let g:SimpylFold_docstring_preview = 1
" always start editing file with no folds
set foldlevelstart=99

" Auto-Pairs
"""""""""""""
let g:AutoPairsShortcutToggle = '<C-p>' 
let g:AutoPairsShortcutFastWrap = '<C-e>'

" Airline
"""""""""
let g:AutoPairsShortcutToggle = '<C-p>' 
set nosmd   " short for 'showmode', hides '-- INSERT --' etc., Airline shows it
let g:airline_section_c ='%{HasPaste()}%F%m%r%h'      "(bufferline or filename, readonly)
let g:airline_theme='solarized'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files browsing and netrw
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Netrw setup
"let g:netrw_banner = 0 
" let g:netrw_liststyle = 3 "change liststyle with 'i'
let g:netrw_browse_split = 0 "  1-new horz split
                             "  2-new vert split
                             "  3-new tab
                             "  4-open in prev windows
let g:netrw_altv = 1 "not sure what is this
let g:netrw_winsize = 50 "half of a winsize
let g:netrw_fastbrowse = 0 "fixes some bug
" Per default, netrw leaves unmodified buffers open. This autocommand
" deletes netrw's buffer once it's hidden (using ':q', for example)
autocmd FileType netrw setl bufhidden=delete

if has("autocmd")
    augroup templateFiles
        autocmd BufNewFile *.py 0r ~/.vim/template_files/python.py
        autocmd BufNewFile *.jl 0r ~/.vim/template_files/julia.jl
        autocmd BufNewFile *.sh 0r ~/.vim/template_files/shellscript.sh
        autocmd BufNewFile *.cpp 0r ~/.vim/template_files/cpp_source.cpp
        autocmd BufNewFile *.hpp 0r ~/.vim/template_files/cpp_header.hpp
    augroup END
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable 

" To solve issues with colors in tmux session
" set term=screen-256color-bce

" background {dark/light}
set background=dark

" 256 = almost black, dark = katapa blue (default)
let g:solarized_termcolors='dark' 
"
" Default colorscheme
colorscheme solarized 

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" highlight Folded term=bold,underline cterm=bold,underline ctermfg=12 ctermbg=0 guifg=Cyan guibg=DarkGrey
highlight Folded term=bold,underline cterm=bold ctermfg=12 ctermbg=0 guifg=Cyan guibg=DarkGrey
" highlight YcmErrorLine cterm=bold,underline ctermbg=3f0000
" highlight YcmWarningLine cterm=bold,underline

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
