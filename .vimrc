map Q gq

" Auto-commands
filetype plugin indent on

augroup cprog
  au!
  autocmd BufRead *
	\ set formatoptions=tcql autoindent tw=75 comments&
  autocmd BufRead *.c,*.h set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
augroup END

" Jump to last place in file
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal g`\"" |
	\ endif

" Wrap when editing brand-new text files
autocmd BufNewFile *.txt set tw=75 formatoptions+=t


"" Syntax highlighting

syntax on

set background=light

" Very bright search highlighting
highlight Search ctermbg=190
" Turn on 256 colours for xterms
set t_Co=256 t_Sf=<Esc>[38;5;%p1%m t_Sb=<Esc>[48;5;%p1%m

" Highlight trailing spaces in red in source code
autocmd BufReadPost *.cc,*.cpp,*.cxx,*.C,*.java,*.c
    \ set cino+=(s,W1,U1,u0 | syntax match Error /\s\+$/
autocmd BufReadPost *.java
    \ syntax region javaComment start=+/\*+ end=+\*/+
    \ contains=@javaCommentSpecial,javaTodo,@Spell,Error
match Error /\s\+$/


"" Key mappings

" Windows-style shortcuts for moving around multiple windows
map <C-Tab> <C-W>w
map <C-F4> <C-W>c

" Uncomment to turn off man search (too easy to hit accidentally)
" map K k

" Uncomment to turn off command window (too easy to open accidentally)
map q: :q

" Thanks http://www.shallowsky.com/blog/index.cgi/linux/editors/index.html
imap <Nul> <Space>

" This makes shift-backspace act the same as backspace
imap <Esc>[3;2~ <C-h>
cmap <Esc>[3;2~ <C-h>


"" Terminal stuff
" Misc backspace/delete stuff
set t_kD=<Esc>[3~
set t_kb=
set t_ks=<Esc>[?1h t_ke=<Esc>[?1l

" make numpad keys work in linux, and turn off screen blinking when it
" thinks it should beep
set <k0>=<Esc>Op <k1>=<Esc>Oq <k2>=<Esc>Or
set <k3>=<Esc>Os <k4>=<Esc>Ot <k5>=<Esc>Ou
set <k6>=<Esc>Ov <k7>=<Esc>Ow <k8>=<Esc>Ox
set <k9>=<Esc>Oy <kPoint>=<Esc>On
set <Home>=<Esc>[H <End>=<Esc>Ow
set <kPlus>=<Esc>Ol <kMinus>=<Esc>OS
set <kDivide>=<Esc>OQ <kMultiply>=<Esc>OR
set <kEnter>=<Esc>OM

set <kPlus>=<Esc>Ok
set <kMinus>=<Esc>Om
set <kMultiply>=<Esc>Oj
set <kDivide>=<Esc>Oo
set <k7>=<Esc>Ow
set t_KJ=<Esc>Ow


"" Settings
set title
set smartcase
set mouse=a
set showcmd
set encoding=utf-8
set expandtab
set directory=$TMP
set whichwrap+=h,l,<,>,[,] ignorecase
set statusline=%<%f\ %h%m%r%=%-14.(%l/%L,%c%V%)\ %P
set backup backupdir=~/misc/bak
set softtabstop=4 shiftwidth=4 tabstop=8
set visualbell t_vb=

" I hope this doesn't slow things down too much
runtime! ftplugin/man.vim


"" Error formats
" Guile
let &errorformat="ERROR:\ %f:%l:%c:\ %m," . &errorformat
" Error formats for pathscale compilers (or maybe icc... don't remember)
set errorformat+=%E%f(%l):\ error\ #%n:\ %m
set errorformat+=%E%f(%l):\ error:\ %m,%-Z%p^,%-C%.%#
" This isn't quite right, but will be helpful for perl.
set errorformat+=%m\ at\ %f\ line\ %l\\,\ near\ \"%.%#\"
set errorformat+=%m\ at\ %f\ line\ %l\\,%.%#
set errorformat+=%m\ at\ %f\ line\ %l.


"" Paths
set path+=/usr/include/g++-3
set path+=/usr/include/linux
set path+=/usr/lib/gcc-lib/i386-redhat-linux/3.2/include
set path+=/usr/X11R6/include/X11
set path+=/usr/include/w32api
set path+=/usr/include/mingw
set path+=/usr/include/c++/3.3.1
set path+=/usr/include/c++/3.3.1/i686-pc-mingw32

autocmd GUIEnter * set t_vb=
if v:version>=700
    set spell
endif
