if !exists("g:instant_markdown_slow")
    g:instant_markdown_slow = 0
endif

function! UpdateMarkdown()
  if (b:im_needs_init)
    let b:im_needs_init = 0
    silent! exec "silent! !echo " . escape(shellescape(join(getbufline("%", 1, "$"), "\n")), "%!#") . " | instant-markdown-d &>/dev/null &"
  endif
  if (b:last_number_of_changes == "" || b:last_number_of_changes != b:changedtick)
    let b:last_number_of_changes = b:changedtick
    let current_buffer = join(getbufline("%", 1, "$"), "\n")
    silent! exec "silent! !echo " . escape(shellescape(current_buffer), "%!#") . " | curl -X PUT -T - http://localhost:8090/ &>/dev/null &"
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
  silent! exec "silent! !curl -s -X DELETE http://localhost:8090/ &>/dev/null &"
endfunction

if g:instant_markdown_slow
    autocmd InsertLeave,BufWrite <buffer> silent call UpdateMarkdown()
else
    autocmd CursorMoved,CursorMovedI,CursorHold,CursorHoldI <buffer> silent call UpdateMarkdown()
endif
autocmd BufWinLeave <buffer> silent call CloseMarkdown()
autocmd BufWinEnter <buffer> silent call OpenMarkdown()
