" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2017-08-09
" @Revision:    26


if !exists('g:ttext#tw0_accept_indented_lines')
    let g:ttext#tw0_accept_indented_lines = 0   "{{{2
endif


if !exists('g:ttext#debug')
    let g:ttext#debug = 0   "{{{2
endif

if exists(':Tlibtrace') != 2
    command! -nargs=+ -bang Tlibtrace :
endif


function! ttext#Setup_highlight() abort "{{{3
    Tlibtrace 'ttext', &filetype
    let b:commentStart = '%'
    let b:commentEnd   = ''
    syntax match ttextComment "^%.*"
    hi def link ttextComment Comment
    syntax region ttextString start=+"+ skip=+\\"+ end=+"\|\n+
    hi def link ttextString Constant
    syntax match TToDo /<+TODO+>/
    hi def link TToDo WarningMsg
    " VimTip 206: Highlight doubled word errors in text
    syntax match textDoubleWord "\c\<\(\a\+\)\_s\+\1\>"
    hi def link textDoubleWord Error
    syntax match TWhiteSpace /\_s/ contained containedin=TDoubleWords
    syntax match TDoubleWords /\c\<\(\S\+\)\_s\+\1\ze\_s/ contains=TWhiteSpace
    hi def link TWhiteSpace Normal
    hi def link TDoubleWords ToDo
    let b:ttext_highlight = 1
endf


function! ttext#Detect_tw0() abort "{{{3
    if &tw > 0 && !search('\<\%(vim\?\|ex\):.\{-}\<\%(tw\|textwidth\)=', 'cnw')
        let threshold = &tw + 10
        Tlibtrace 'ttext', threshold
        for lnum in range(1, line('$'))
            if !g:ttext#tw0_accept_indented_lines && indent(lnum) > 0
                continue
            endif
            let line = getline(lnum)
            if strdisplaywidth(line) > threshold
                if g:ttext#debug
                    echom 'TText: long line -> tw=0'
                endif
                setlocal tw=0
                call ttext#Setup_tw0()
                break
            endif
        endfor
    endif
    let b:ttext_detect_tw = 1
endf


function! ttext#Setup_tw0() abort "{{{3
    Tlibtrace 'ttext', &textwidth, &linebreak, &breakat, &wrapmargin, &showbreak, &wrap
    if g:ttext#debug
        echom 'TText: Setup tw == 0'
    endif
    setlocal linebreak
    call ttext#VisualMovements()
    let b:ttext_tw0 = 1
endf


function! ttext#VisualMovements() abort "{{{3
    Tlibtrace 'ttext', &formatoptions
    set formatoptions-=a
    noremap <buffer> j gj
    noremap <buffer> k gk
    noremap <buffer> <Down> gj
    noremap <buffer> <Up>   gk
    inoremap <buffer> <expr> <Down> pumvisible() ? "\<lt>Down>" : "\<lt>C-O>gj"
    inoremap <buffer> <expr> <Up>   pumvisible() ? "\<lt>Up>"   : "\<lt>C-O>gk"
    noremap  <buffer> <Home> g<Home>
    inoremap  <buffer> <Home> <c-\><c-o>g<Home>
    noremap  <buffer> <End> g<End>
    inoremap  <buffer> <End> <c-\><c-o>g<End>
    nnoremap  <buffer> <S-Home> vg0<c-g>
    inoremap  <buffer> <S-Home> <c-\><c-o>vg0<c-g>
    vnoremap <buffer> <S-Home> g0
    nnoremap  <buffer> <S-End> vg$<c-g>
    inoremap  <buffer> <S-End> <c-\><c-o>vg$<c-g>
    vnoremap <buffer> <S-End> g$
    nnoremap  <buffer> <S-Up> vgk<c-g>
    inoremap  <buffer> <S-Up> <c-\><c-o>vgk<c-g>
    vnoremap <buffer> <S-Up> gk
    nnoremap  <buffer> <S-Down> vgj<c-g>
    inoremap  <buffer> <S-Down> <c-\><c-o>vgj<c-g>
    vnoremap <buffer> <S-Down> gj
    let b:ttext_highlight = 1
endf

