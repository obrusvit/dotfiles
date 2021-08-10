
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Used_by:
"       Vit Obrusnik - @obrusvit
"
" Based_on:
"       Amir Salihefendic — @amix3k
"       basic version of 
"           https://github.com/amix/vimrc
"
" Sections:
"    -> vim-plug setting
"    -> General
"    -> Programming languages
"       -> YouCompleteMe (YCM) related stuff
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files, backups, undo and netrw setup
"    -> File (new) templates
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'

" languages syntax support
Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
Plug 'vim-python/python-syntax', {'for': 'python'}
Plug 'heavenshell/vim-pydocstring', {'for': 'python'}
Plug 'JuliaEditorSupport/julia-vim', {'for': 'julia'}

" Auto Pairs - Insert or delete brackets, parens, quotes in pair.
Plug 'jiangmiao/auto-pairs'

" YCM - see GitHub for correct setup and build
Plug 'ycm-core/YouCompleteMe'
Plug 'ycm-core/lsp-examples'

" UltiSnips engine & snippets
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" better code folding using 'zc' 'zo' commands
Plug 'tmhedberg/SimpylFold'

" fzf (fuzzy finder) & integration
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" :Ranger command
Plug 'francoiscabrol/ranger.vim'

" Solarized colorscheme
Plug 'altercation/vim-colors-solarized'

" Status tabline 
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/vim-airline/vim-airline-themes'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=500

" Set to auto read when a file is changed from the outside
set autoread

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Programming languages
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" prooper PEP 8 indentation for python
au BufNewFile,BufRead *.py;
    \ set tabstop=4 
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

runtime macros/matchit.vim

" vim-commentary, julia commentstring
autocmd FileType julia setlocal commentstring=#\ %s

" disable julia-vim Latex-2-Unicode with <F7>
noremap <expr> <F7> LaTeXtoUnicode#Toggle()
noremap! <expr> <F7> LaTeXtoUnicode#Toggle()


" C++ syntax
let g:cpp_concepts_highlight = 1 

" python syntax
" see for more: https://github.com/vim-python/python-syntax 
let g:python_highlight_all=1
let g:python_highlight_class_vars=1

" SimplyFold Plugin setting
let g:SimpylFold_docstring_preview = 1
" always start editing file with no folds
set foldlevelstart=99

" pydocstring, set to Google Style docstrings and disable mapping <C-l>
" let g:pydocstring_templates_path = '/home/obrusvit/.vim/template_files/pydocstring_google_style'
let g:pydocstring_formatter='google'
let g:pydocstring_enable_mapping = 0

" auto-pairs shortcuts (the default <M-'some'> doesn't work in gnome-terminal)
let g:AutoPairsShortcutToggle = '<C-p>' 
let g:AutoPairsShortcutFastWrap = '<C-e>'

" write long part - delimmiting line comment with <leader>/
if has("autocmd")
    augroup delimitingComments
        autocmd FileType c,cpp,java,kotlin map <leader>/ O<ESC>o<ESC>2i/<ESC>78a-<ESC>
        autocmd FileType python,julia map <leader>/ O<ESC>o<ESC>1i#<ESC>79a=<ESC>
    augroup END
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"=> YouCompleteMe (YCM) related stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set to 1 if you don't want to use YCM
" let g:loaded_youcompleteme = 1

" shortcuts for YCM"
nmap <leader>yg :YcmCompleter GoToDefinitionElseDeclaration<CR>
nmap <leader>yf :YcmCompleter FixIt<CR>
nmap <leader>yd :YcmCompleter GetDoc<CR>
nmap <leader>yr :YcmCompleter RefactorRename <C-R><C-W> 
"ctrl-r, ctrl-w brings the word under cursor

command Fmt YcmCompleter Format
"TODO finish Fmt for range
" function! FormatGivenRange() range
"     echo "firstline ".a:firstline." lastline ".a:lastline
"     " :a:firstline,a:lastline YcmCompleter Format
" endfunction

" command! -range Fmt <line1>,<line2>call FormatGivenRange()

" default fallback for YcmCompleter extra conf file
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

" =0 automatically load .ycm_extra_conf
" WARNING car run malicious code, switch to 1 if not needed
let g:ycm_confirm_extra_conf = 1

" turn off the diagnostics whatsoever
"let g:ycm_show_diagnostics_ui = 0

" turn off the signs (arrows) on the left side of the screen, it moves code :(
let g:ycm_enable_diagnostic_signs = 0

" turn off highlighting in red
"let g:ycm_enable_diagnostic_highlighting = 0

" turn off popup window with arguments suggestions for julia
if has("autocmd")
    augroup juliaWithoutSignatureHelp
        autocmd FileType julia let g:ycm_disable_signature_help = 1
    augroup END
endif
" let g:ycm_max_num_candidates_to_detail = 1

" generated from lsp-examples (run python3 install.py --enable-julia)
" modified to remove debug and empty Dict()
source /home/obrusvit/.vim/plugged/lsp-examples/vimrc.generated

" UltiSnips 
let g:UltiSnipsExpandTrigger="<c-l>"  "Ctrl-L

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display line nums not as absolute but relative to the cursor
set relativenumber

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Avoid garbled characters in Chinese language windows OS
let $LANG='en' 
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the Wild menu
set wildmenu

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
set noerrorbells
set novisualbell
set t_vb=
set tm=500

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable 

" background
set background=dark

" 256 = almost black, dark = katapa blue (default)
" let g:solarized_termcolors='dark' 
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

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" highlight Folded term=bold,underline cterm=bold,underline ctermfg=12 ctermbg=0 guifg=Cyan guibg=DarkGrey
highlight Folded term=bold,underline cterm=bold ctermfg=12 ctermbg=0 guifg=Cyan guibg=DarkGrey

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups, undo and netrw setup
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => File (new) templates
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" vnoremap <silent> <leader>ag :<C-u>call VisualSelection('', '')<CR>:Ag <C-R>=@/<CR><CR>
vnoremap <silent> Ag :<C-u>call VisualSelection('', '')<CR>:Ag <C-R>=@/<CR><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tp :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" The following two are nice for use with default Status line
" Always show the status line
" set laststatus=2
" Format the status line
" set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ Line:%l\ Col:%c

" For use with Airline 
set nosmd   " short for 'showmode', hides '-- INSERT --' etc., Airline shows it
let g:airline_section_c ='%{HasPaste()}%F%m%r%h'      "(bufferline or filename, readonly)
let g:airline_theme='solarized'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.py,*.wiki,*.sh :call CleanExtraSpaces()
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" To solve issues with colors in tmux session
set term=screen-256color-bce

" Write datetime when <F3> is pressed
nmap <F3> i<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<C-R><Esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
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
