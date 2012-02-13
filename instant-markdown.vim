function! UpdateMarkdown()
  if (b:last_num_changes == "" || b:last_num_changes != b:changedtick)
    let b:last_num_changes = b:changedtick
    let current_buffer = join(getbufline("%", 1, "$"), "\n")
    silent! exec "silent! !echo " . escape(shellescape(current_buffer), "%!#") . " | curl -X PUT -T - http://localhost:8090/ &>/dev/null &"
  endif
endfunction
function! OpenMarkdown()
  let b:last_num_changes = ""
  silent! exec "silent! !echo " . escape(shellescape(join(getbufline("%", 1, "$"), "\n")), "%!#") . " | instant-markdown-d &>/dev/null &"
endfunction
function! CloseMarkdown()
  silent! exec "silent! !curl -s -X DELETE http://localhost:8090/ &>/dev/null &"
endfunction

autocmd CursorMoved,CursorMovedI,CursorHold,CursorHoldI *.{md,mkd,mkdn,mark*} silent call UpdateMarkdown()
autocmd BufWinLeave *.{md,mkd,mkdn,mark*} silent call CloseMarkdown()
autocmd BufWinEnter *.{md,mkd,mkdn,mark*} silent call OpenMarkdown()
autocmd BufNewFile *.{md,mkd,mkdn,mark*} silent call OpenMarkdown()
