" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2017-08-15
" @Revision:    17
" GetLatestVimScripts: 0 0 :AutoInstall: ttext.vim

if &cp || exists('g:loaded_ttext')
    finish
endif
let g:loaded_ttext = 1

let s:save_cpo = &cpo
set cpo&vim


if !exists('g:ttext_detect_longlines_pattern')
    " Filetype for which ttext tries to determine whether to set 'tw' to 
    " 0.
    let g:ttext_detect_longlines_pattern = '*.txt,*.md,*.viki'   "{{{2
endif


if !exists('g:ttext_handle_longlines_pattern')
    " Pattern for the autocommand -- see |autocmd-patterns|.
    let g:ttext_handle_longlines_pattern = '*'   "{{{2
endif


if !exists('g:ttext_highlight_filetype_rx')
    " Enable some minimal highlighting for filetypes matching this 
    " |regexp|.
    let g:ttext_highlight_filetype_rx = '^text$'   "{{{2
endif


augroup TText
    autocmd!
    exec 'autocmd BufWinEnter' g:ttext_handle_longlines_pattern 'if !exists(''b:ttext_longlines'') && &tw == 0 | call ttext#Setup_longlines() | endif'
    exec 'autocmd BufWinEnter' g:ttext_detect_longlines_pattern 'if !exists(''b:ttext_detect_longlines'') && &tw > 0 | call ttext#Detect_longlines() | endif'
    autocmd BufWinEnter * if !exists('b:ttext_highlight') && &filetype =~? g:ttext_highlight_filetype_rx | call ttext#Setup_highlight() | endif
    if exists('#OptionSet')
        autocmd OptionSet textwidth if v:option_new == 0 && !exists('b:ttext_longlines') | call ttext#Setup_longlines() | endif
    endif
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo
