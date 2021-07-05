" tabs 2
"set sw=2 ts=2
" tabs 4
set sw=4 ts=4
" spaces 2
"set et sw=2 "sts=2
" spaces 4
"set et sw=4 "sts=4

" rm trailing whitespace
autocmd BufWritePre * %s/\s\+$//e
