function! UpdateMarkdown()
  " silent! update! /tmp/lala.md
  if (!exists("last_num_changes") || last_num_changes != b:changedtick)
    let last_num_changes = b:changedtick
    let current_buffer = join(getbufline("%", 1, "$"), "\n")
    silent! exec "silent! !echo \"" . current_buffer . "\" | curl -T - http://localhost:8090/ &>/dev/null &"
  endif
endfunction
" function! RefreshMarkdown()
  " silent! exec "silent! !refresh-vim-markdown /tmp/lala.md &>/dev/null &"
" endfunction
function! OpenMarkdown()
  " silent! exec "!cp " . expand("%") . " /tmp/lala.md"
    silent! exec "silent! !instant-markdown-server &>/dev/null &"
    silent! exec "silent! !curl http://localhost:8090/ &>/dev/null &"
    silent! call UpdateMarkdown()
endfunction
function! CloseMarkdown()
    silent! exec "silent! !curl -X DELETE http://localhost:8090/ &>/dev/null &"
endfunction

autocmd CursorMoved,CursorMovedI,CursorHold,CursorHoldI *.{md,mkd,mkdn,mark*} silent call UpdateMarkdown()
" autocmd BufWritePre *.{md,mkd,mkdn,mark*} silent call RefreshMarkdown()
" autocmd CursorMovedI *.md silent call UpdateMarkdown()
" autocmd CursorHold *.md silent call UpdateMarkdown()
" autocmd CursorHoldI *.md silent call UpdateMarkdown()
autocmd VimLeave *.{md,mkd,mkdn,mark*} silent call CloseMarkdown()
autocmd BufReadPost *.{md,mkd,mkdn,mark*} silent call OpenMarkdown()
