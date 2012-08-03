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
endfunction
function! CloseMarkdown()
  silent! exec "silent! !curl -s -X DELETE http://localhost:8090/ &>/dev/null &"
endfunction

" Only README.md is recognized by vim as type markdown. Do this to make ALL .md files markdown
autocmd BufWinEnter *.{md,mkd,mkdn,mark*} silent setf markdown

autocmd CursorMoved,CursorMovedI,CursorHold,CursorHoldI *.{md,mkd,mkdn,mark*} silent call UpdateMarkdown()
autocmd BufWinLeave *.{md,mkd,mkdn,mark*} silent call CloseMarkdown()
autocmd BufWinEnter *.{md,mkd,mkdn,mark*} silent call OpenMarkdown()
