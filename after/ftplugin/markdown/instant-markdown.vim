function! UpdateMarkdown()
  let buf = join(getline(1, "$"), "\n")
  if (b:im_needs_init)
    let b:im_needs_init = 0
    call system("instant-markdown-d &>/dev/null &", buf)
  endif
  if (b:last_number_of_changes == "" || b:last_number_of_changes != b:changedtick)
    let b:last_number_of_changes = b:changedtick
    call system("curl -X PUT -T - http://localhost:8090/ &>/dev/null &", buf)
  endif
endfunction

function! OpenMarkdown()
  let b:last_number_of_changes = ""
  let b:im_needs_init = 1
endfunction

function! CloseMarkdown()
  call system("curl -s -X DELETE http://localhost:8090/ &>/dev/null &")
endfunction

" autocmd CursorMoved,CursorMovedI,CursorHold,CursorHoldI <buffer> silent call UpdateMarkdown()
" autocmd BufWinLeave <buffer> silent call CloseMarkdown()
" autocmd BufWinEnter <buffer> silent call OpenMarkdown()

" BufEnter:
"   Refresh view in case we came from a different markdown file. This should
" only fire if BufWinEnter has already happened; so BufWinEnter and BufWinLeave
" must create and delete the autocmd.
"
" Save implementing it for later.
"
" BufWinEnter:
"   Number of markdown buffers = 0? Start daemon. Add self to list.
" Refresh view.
"
" BufWinLeave:
"   Remove self from view. Number of markdown buffers = 0? Kill daemon.
"
" When it's time, we want to refresh.  What signifies "it is time?" the right
" autocmds, obviously. And they are: CursorMoved, CursorHold

" # UTILITY FUNCTIONS
function! s:refreshView()
    let bufnr = expand('<bufnr>')
    echom "  RefreshView"
    " Add a space to input to avoid complaints
    call system("curl -X PUT -T - http://localhost:8090/ &>/dev/null &",
                \ ' '.s:bufGetContents(bufnr))
endfu

function! s:startDaemon()
    echom "  Starting daemon"
    call system("instant-markdown-d &>/dev/null &", "*Initializing*")
endfu

function! s:initDict()
    echom "  Init s:buffers"
    if !exists('s:buffers')
        let s:buffers = {}
    else
        echom "  s:buffers already exists, "
        for [k, v] in items(s:buffers)
            echom "    " . k . ": " . v
        endfor
    endif
endfu

function! s:pushBuffer(bufnr)
    echom "  Pushing #" . a:bufnr
    call s:initDict()
    let s:buffers[a:bufnr] = 1
endfu

function! s:popBuffer(bufnr)
    echom "  Popping #" . a:bufnr
    call s:initDict()
    call remove(s:buffers, a:bufnr)
endfu

function! s:killDaemon()
    echom "  Killing daemon"
    call system("curl -s -X DELETE http://localhost:8090/ &>/dev/null &")
endfu

function! s:bufGetContents(bufnr)
  return join(getbufline(a:bufnr, 1, "$"), "\n")
endfu

" # Hur we go
fu! s:pushMarkdown()
    call s:initDict()
    if len(s:buffers) == 0
        call s:startDaemon()
    endif
    call s:pushBuffer(expand('<abuf>'))
endfu

aug instant-markdown
    au! * <buffer>
    au BufEnter <buffer> call s:refreshView()
    au CursorHold,CursorHoldI,CursorMoved,CursorMovedI <buffer> call s:refreshView()
    au BufWinLeave <buffer> call s:popMarkdown()
    au BufwinEnter <buffer> call s:pushMarkdown()
aug END

fu! s:popMarkdown()
    let bufnr = expand('<abuf>')
    silent au! instant-markdown * <buffer=abuf>
    call s:popBuffer(bufnr)
    if len(s:buffers) == 0
        call s:killDaemon()
    endif
endfu
