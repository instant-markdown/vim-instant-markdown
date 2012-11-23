if !exists("g:instant_markdown_slow")
    g:instant_markdown_slow = 0
endif

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
  if g:instant_markdown_slow
      call UpdateMarkdown()
  endif
endfunction

function! CloseMarkdown()
  call system("curl -s -X DELETE http://localhost:8090/ &>/dev/null &")
endfunction

if g:instant_markdown_slow
    autocmd InsertLeave,BufWrite <buffer> silent call UpdateMarkdown()
else
    autocmd CursorMoved,CursorMovedI,CursorHold,CursorHoldI <buffer> silent call UpdateMarkdown()
endif
autocmd BufWinLeave <buffer> silent call CloseMarkdown()
autocmd BufWinEnter <buffer> silent call OpenMarkdown()
