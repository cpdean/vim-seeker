" Vim plugin for Seeker
"
" Borrows heavily from https://github.com/racer-rust/vim-racer
" (by Phil Dawes)
"

if exists('g:loaded_seeker')
  finish
endif

let g:loaded_seeker = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:seeker_cmd')
    let path = escape(expand('<sfile>:p:h'), '\') . '/../target/release/'
    if isdirectory(path)
        let s:pathsep = has("win32") ? ';' : ':'
        let $PATH .= s:pathsep . path
    endif
    let g:seeker_cmd = 'seeker'

    if !(executable(g:seeker_cmd))
      echohl WarningMsg | echomsg "No seeker executable found in $PATH (" . $PATH . ")"
    endif
endif

" want
let g:SEEKERDEBUG = 0
function! SeekerGoToDefinition()
    " save current word to register 's'
    normal! "syiw
    let ccol = col(".")-1
    let cline = line(".")-1
    let fname = expand("%:p")
    let srcdir = "."
    let identifier = expand(@s)

    let cmd = g:seeker_cmd." ".srcdir." ".fname." ".cline." ".ccol." ".identifier
    if(g:SEEKERDEBUG == 1)
        echo cmd
    endif

    let res = system(cmd)
    if(g:SEEKERDEBUG == 1)
        echo res
    endif
    if res =~ "^MATCH"
        let fname = split(res, " ")[1]
        let linenum = split(res,  " ")[2]
        let colnum = split(res, " ")[3]
        call SeekerJumpToLocation(fname, linenum, colnum)
    else
        echo res
    endif
endfunction

function! SeekerJumpToLocation(filename, linenum, colnum)
    if(a:filename != '')
        " Record jump mark
        normal! m`
        if a:filename != bufname('%')
            exec 'keepjumps e ' . fnameescape(a:filename)
        endif
        call cursor(a:linenum+1, a:colnum+1)
        " Center definition on screen
        normal! zz
    endif
endfunction

" /want

autocmd FileType elm nnoremap gd :call SeekerGoToDefinition()<cr>
autocmd FileType elm nnoremap gD :vsplit<cr>:call SeekerGoToDefinition()<cr>

let &cpo = s:save_cpo
unlet s:save_cpo
