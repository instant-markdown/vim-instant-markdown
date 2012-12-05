function! UpdateMarkdown()
  if (b:im_needs_init)
    let b:im_needs_init = 0
    let b:last_number_of_changes = b:changedtick
    let current_buffer = join(getbufline("%", 1, "$"), "\n")
    silent! exec "silent! !echo " . escape(shellescape(current_buffer), "%!#") . " | instant-markdown-d &>/dev/null &"
  elseif (b:last_number_of_changes != "" && b:last_number_of_changes != b:changedtick)
    let current_buffer = join(getbufline("%", 1, "$"), "\n")
    silent! exec "silent! !curl -s -X PUT --data-binary " . escape(shellescape(current_buffer), "%!#") . " -H 'Expect:' http://localhost:8090/ &>/dev/null &"
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
autocmd BufWinEnter *.{md,mkd,mkdn,mdown,mark*} silent setf markdown

autocmd CursorMoved,CursorMovedI,CursorHold,CursorHoldI *.{md,mkd,mkdn,mdown,mark*} silent call UpdateMarkdown()
autocmd BufWinLeave *.{md,mkd,mkdn,mdown,mark*} silent call CloseMarkdown()
autocmd BufWinEnter *.{md,mkd,mkdn,mdown,mark*} silent call OpenMarkdown()
