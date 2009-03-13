" vim comes with a syntax file for asciidoc which applies to all *.txt
" files. However the syntax file contains the line “syn sync fromstart”
" which causes opening large text files to take too long. So we set the
" filetype to something else here instead.
au BufNewFile,BufRead *.txt,README,TODO,CHANGELOG,NOTES  setfiletype text
