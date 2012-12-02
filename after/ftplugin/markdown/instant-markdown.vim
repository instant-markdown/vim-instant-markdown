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

