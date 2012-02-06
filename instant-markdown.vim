function! UpdateMarkdown()
  silent! update! /tmp/lala.md
  silent! exec "silent! !refresh-vim-markdown /tmp/lala.md &>/dev/null &"
endfunction
function! RevertMarkdown()
  silent! exec "!cp " . expand("%") . " /tmp/lala.md"
  silent! exec "silent! !refresh-vim-markdown /tmp/lala.md &>/dev/null &"
endfunction

autocmd CursorMoved,CursorMovedI,CursorHold,CursorHoldI *.{md,mkd,mkdn,mark*} silent call UpdateMarkdown()
" autocmd CursorMovedI *.md silent call UpdateMarkdown()
" autocmd CursorHold *.md silent call UpdateMarkdown()
" autocmd CursorHoldI *.md silent call UpdateMarkdown()
autocmd VimLeave *.{md,mkd,mkdn,mark*} silent call RevertMarkdown()
