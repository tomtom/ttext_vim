" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2017-08-01
" @Revision:    16


function! ttext#Setup_highlight() abort "{{{3
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
    let threshold = &tw + 10
    for lnum in range(1, line('$'))
        if strdisplaywidth(getline(lnum)) > threshold
            setlocal tw=0
            call ttext#Setup_tw0()
            break
        endif
    endfor
    let b:ttext_detect_tw = 1
endf


function! ttext#Setup_tw0() abort "{{{3
    setlocal linebreak
    call ttext#VisualMovements()
    let b:ttext_tw0 = 1
endf


function! ttext#VisualMovements() abort "{{{3
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

