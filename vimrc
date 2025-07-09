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

" fzf (fuzzy finder) & integration
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Ranger integration
Plug 'francoiscabrol/ranger.vim'

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

" Disable highlight when <ESC> is pressed
map <silent> <ESC> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer but keep the split
map <leader>bd :b#<bar>bd#<cr>

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

" Airline
"""""""""
set nosmd   " short for 'showmode', hides '-- INSERT --' etc., Airline shows it
let g:airline_section_c ='%{HasPaste()}%F%m%r%h'      "(bufferline or filename, readonly)
let g:airline_theme='solarized'

"sclow
" let g:sclow_block_filetypes = ['netrw', 'nerdtree']
let g:sclow_block_buftypes = ['terminal', 'prompt']
let g:sclow_hide_full_length = 1
set updatetime=2000

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

" Treat SCons files as python
au BufRead,BufNewFile SConstruct set filetype=python

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable 

" To solve issues with colors in tmux session
set term=screen-256color-bce

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
" highlight Folded term=bold,underline cterm=bold ctermfg=12 ctermbg=0 guifg=Cyan guibg=DarkGrey

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
