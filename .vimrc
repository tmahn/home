map Q gq
if &t_Co > 2 || has("gui_running")
  syntax on
  vmenu 20.360 &Edit.&Paste<Tab>"*p	"-x:call SelectPaste()<CR>
  vmenu  1.40  PopUp.&Paste		"-x:call SelectPaste()<CR>
  vmenu        ToolBar.Paste		"-x:call SelectPaste()<CR>
  map <M-Space> :simalt ~<CR>
  imap <M-Space> <C-O>:simalt ~<CR>
  cmap <M-Space> <C-C><M-Space>
endif
augroup cprog
  au!
  autocmd BufRead *
	\ set formatoptions=tcql autoindent tw=75 comments&
  autocmd BufRead *.c,*.h set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
augroup END
filetype plugin indent on
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal g`\"" |
	\ endif
map <C-Tab> <C-W>w
map Δ w
map K k
map q: :q
map <C-F4> <C-W>
set directory=$TMP 
" path=.,..,c:/mingw/include,c:/mingw/include/sys,c:\mingw\lib\gcc-lib\mingw32\3.2.1\include 
set path+=/usr/include/mingw,/usr/include/c++/3.3.1,/usr/include/c++/3.3.1/i686-pc-mingw32,/usr/include/w32api
set makeprg=mak
set guioptions-=T ruler scrolloff=3 tabstop=2 shiftwidth=2 shiftround  backspace=2 ffs=unix,dos vb t_vb= hidden incsearch nocompatible nojoinspaces hlsearch backup viminfo='20,\"50,% backupdir=~/misc/bak
set whichwrap+=h,l,<,>,[,] ignorecase
hi PreProc ctermfg=gray
set bg=light
" behave xterm
set sc

" until we switch to something tha t
let &efm="ERROR:\ %f:%l:%c:\ %m," . &efm

set encoding=utf-8
set expandtab

set spell

highlight Search ctermbg=190
set statusline=%<%f\ %h%m%r%=%-14.(%l/%L,%c%V%)\ %P


set t_Co=256 t_Sf=<Esc>[38;5;%p1%m t_Sb=<Esc>[48;5;%p1%m

" I hope this doesn't slow things down too much
runtime! ftplugin/man.vim

autocmd BufNewFile *.txt set tw=75 formatoptions+=t
