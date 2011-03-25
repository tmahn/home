" Auto-commands
filetype plugin indent on

augroup cprog
  au!
  autocmd BufRead *
	\ set formatoptions=tcql autoindent tw=75 comments&
  autocmd BufRead *.c,*.h
        \ set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
  autocmd BufRead *.bib
        \ set nocindent
  " autocmd BufRead *.tex
  "       \ setlocal errorformat=%E!\ LaTeX\ %trror:\ %m,
  "           \%E!\ %m,
  "           "\%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#,
  "           \%+W%.%#\ at\ lines\ %l--%*\\d,
  "           "\%WLaTeX\ %.%#Warning:\ %m,
  "           \%Cl.%l\ %m,
  "           \%+C\ \ %m.,
  "           \%+C%.%#-%.%#,
  "           \%+C%.%#[]%.%#,
  "           \%+C[]%.%#,
  "           \%+C%.%#%[{}\\]%.%#,
  "           \%+C<%.%#>%.%#,
  "           \%C\ \ %m,
  "           \%-GSee\ the\ LaTeX%m,
  "           \%-GType\ \ H\ <return>%m,
  "           \%-G\ ...%.%#,
  "           \%-G%.%#\ (C)\ %.%#,
  "           \%-G(see\ the\ transcript%.%#),
  "           \%-G\\s%#,
  "           \%+O(%*[^()])%r,
  "           \%+O%*[^()](%*[^()])%r,
  "           \%+P(%f%r,
  "           \%+P\ %\\=(%f%r,
  "           \%+P%*[^()](%f%r,
  "           \%+P[%\\d%[^()]%#(%f%r,
  "           \%+Q)%r,
  "           \%+Q%*[^()])%r,
  "           \%+Q[%\\d%*[^()])%r
  autocmd BufRead *.tex
        \ let &errorformat="iconv:\ %f:%l:%c:\ %m," . &errorformat
  autocmd BufRead *.tex
        \ syn region texZone
                \ start="\\begin{program}"
                \ end="\\end{program}\|%stopzone\>"
                \ contains=@Spell
  autocmd BufRead *.tex
        \ syn region texZone
                \ start="\\code\*\=\z([^\ta-zA-Z]\)"
                \ end="\z1\|%stopzone\>"
                \ contains=@Spell
  autocmd BufRead,BufNewFile *.rb,Rakefile
        \ set shiftwidth=2 softtabstop=2
augroup END

autocmd BufRead *.kid
        \ setfiletype xml

" Jump to last visited location in file
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal g`\"" |
	\ endif
" Check spelling everywhere
if v:version>=700
    autocmd BufReadPost *
            \ syntax spell toplevel
endif

" Wrap when editing brand-new text files
autocmd BufNewFile *.txt set tw=75 formatoptions+=t

" Vim tip 911; but read the comments on that tip before using it
au BufReadPost * let b:reloadcheck=1
au BufWinEnter *
    \ if exists('b:reloadcheck') |
        \ unlet b:reloadcheck |
        \ if &modified && &fileencoding != "" |
            \ exec 'e! ++enc=' . &fileencoding

"" Syntax highlighting

syntax enable

if &term == "xterm" || &term == "xterm-256color"
    set background=light
    " Turn on 256 colours for xterms
    set t_Co=256 t_Sf=<Esc>[38;5;%p1%m t_Sb=<Esc>[48;5;%p1%m
    " Very bright search highlighting
    highlight Search ctermbg=190
    highlight Visual ctermbg=183
endif
if &term == "xterm-color"
    " test: collr color. colour 
    set background=light
    highlight SpellBad ctermbg=NONE ctermfg=magenta cterm=NONE
    highlight SpellCap ctermbg=NONE ctermfg=cyan cterm=NONE
    highlight SpellLocal ctermbg=NONE ctermfg=cyan cterm=NONE
endif
if &term == "cygwin"
    highlight Search ctermbg=Black ctermfg=Yellow cterm=reverse,bold
endif

" Highlight trailing spaces, too-long lines in red in source code
" the cino+= thing sets (mostly) Two Sigma indent rules
" if your shiftwidth and tabstop and friends are set correctly
" set verbose=9
autocmd BufReadPost *.cc,*.cpp,*.cxx,*.C,*.java,*.c
    \ set cino+=(s,W1,U1,u0
autocmd BufReadPost *.java
    \ syntax region javaComment start=+/\*+ end=+\*/+
    \ contains=@javaCommentSpecial,javaTodo,@Spell,Error
if $VIM_HIGHLIGHT_LONG_LINES != ""
    highlight TooLongLineError ctermbg=198 ctermfg=190
    autocmd BufReadPost * match TooLongLineError /\%>80v/
endif
highlight TrailingSpaceError ctermbg=196
if v:version>=700
    autocmd BufReadPost * 2match TrailingSpaceError /\s\+$/
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                 Test lines               
""""""""""""			""""""""""""""""""""""""""""""""""""""""""""""""""

"" Key mappings
map Q gq

" Windows-style shortcuts for moving around multiple windows
map <C-Tab> <C-W>w
map <C-F4> <C-W>c

" Uncomment to turn off man search (too easy to hit accidentally)
map K k

" Uncomment to turn off command window (too easy to open accidentally)
" map q: :q

" Thanks http://www.shallowsky.com/blog/index.cgi/linux/editors/index.html
imap <Nul> <Space>

" This makes shift-backspace act the same as backspace
imap <Esc>[3;2~ <C-h>
cmap <Esc>[3;2~ <C-h>

" This makes tab and shift-tab indent and unindent
" You might need to add \"Shift<Key>Tab: string(\033[Z) \n\" to your VT100
" translations for S-Tab to work in an xterm
" nnoremap <Tab> >>
nnoremap <S-Tab> <LT><LT>
" vnoremap <Tab> >
vnoremap <S-Tab> <LT>
" Tab should indent (jump up to the next indent increment multiple), and
" shift-tab should unindent
"inoremap <Tab> <C-T>
inoremap <S-Tab> <C-D>

" Emacs compatibility
nnoremap <C-x>o <C-w>w
nnoremap <C-x>1 :only<return>
nnoremap <C-x>0 :close<return>
" Don't know how to get this in search of command mode...
inoremap <Esc><Backspace> <Esc>ldBi

"Ctrl-home/end
noremap <Esc>[1;5H gg
noremap <Esc>[1;5F G

"" Terminal stuff
" Misc backspace/delete stuff
set t_kD=[3~
set t_kb=
set t_ks=[?1h t_ke=[?1l

" make numpad keys work in linux, and turn off screen blinking when it
" thinks it should beep
set <k0>=Op <k1>=Oq <k2>=Or
set <k3>=Os <k4>=Ot <k5>=Ou
set <k6>=Ov <k7>=Ow <k8>=Ox
set <k9>=Oy <kPoint>=On
set <Home>=[H <End>=Ow
set <kPlus>=Ol <kMinus>=OS
set <kDivide>=OQ <kMultiply>=OR
set <kEnter>=OM

set <kPlus>=Ok
set <kMinus>=Om
set <kMultiply>=Oj
set <kDivide>=Oo

"" Settings
set backspace=2
set backup
set backupdir=~/misc/bak
set directory=~/.vimtmp
set encoding=utf-8
set expandtab
set ffs=unix,dos
set guioptions-=T
set hidden
set hlsearch
set ignorecase
set incsearch
set modelines=5
set mouse=a
set nocompatible
set nojoinspaces
set ruler
set scrolloff=3
set shiftround
set shiftwidth=4
set showcmd
set smartcase
set softtabstop=4
set statusline=%<%f\ %h%m%r%=%-14.(%l/%L,%c%V%)\ %P
set t_vb=
set tabstop=8
set title
set vb
set viminfo='20,\"50,%
set visualbell t_vb=
set whichwrap+=h,l,<,>,[,]

" I hope this doesn't slow things down too much
runtime! ftplugin/man.vim


"" Error formats
" Guile
let &errorformat="ERROR:\ %f:%l:%c:\ %m," . &errorformat
let &errorformat="iconv:\ %f:%l:%c:\ %m," . &errorformat
let &errorformat="l.%l \ %m," . &errorformat
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
set path+=/opt/local/include
set path+=/opt/local/Library/Frameworks/Python.framework/Versions/2.6/include/python2.6
set path+=/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Headers

autocmd GUIEnter * set t_vb=

if v:version>=700
    set spell
    set spelllang=en_ca
    set spellfile=~/.vimspell.en.utf-8.add,~/.vimspell.extra.add
endif

" For browsing by regexes...
" nmap <Esc>n nz<CR>
" nmap <Esc>N Nz<CR>

let perl_include_pod = 1
