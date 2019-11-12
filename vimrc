"=============================================================================
" vimrc --- Entry file for vim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" Note: Skip initialization for vim-tiny or vim-small.
if 1
    let g:_spacevim_if_lua = 0
    if has('lua')
        let s:plugin_dir = fnamemodify(expand('<sfile>'), ':h').'\lua'
        let s:str = s:plugin_dir . '\?.lua;' . s:plugin_dir . '\?\init.lua;'
        silent! lua package.path=vim.eval("s:str") .. package.path
        if empty(v:errmsg)
            let g:_spacevim_if_lua = 1
        endif
    endif
    execute 'source' fnamemodify(expand('<sfile>'), ':h').'/config/main.vim'
endif

" tabs
"set sw=4 ts=4
" spaces
set et sw=2 sts=2 
" rm trailing whitespace
autocmd BufWritePre * %s/\s\+$//e
