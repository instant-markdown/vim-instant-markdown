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
    " Add a space to input to avoid complaints
    call system("curl -X PUT -T - http://localhost:8090/ &>/dev/null &",
                \ ' '.s:bufGetContents(bufnr))
endfu

function! s:startDaemon(initialMD)
    " Add a space to input to avoid complaints
    call system("instant-markdown-d &>/dev/null &", ' '.a:initialMD)
endfu

function! s:initDict()
    if !exists('s:buffers')
        let s:buffers = {}
    endif
endfu

function! s:pushBuffer(bufnr)
    call s:initDict()
    let s:buffers[a:bufnr] = 1
endfu

function! s:popBuffer(bufnr)
    call s:initDict()
    call remove(s:buffers, a:bufnr)
endfu

function! s:killDaemon()
    call system("curl -s -X DELETE http://localhost:8090/ &>/dev/null &")
endfu

function! s:bufGetContents(bufnr)
  return join(getbufline(a:bufnr, 1, "$"), "\n")
endfu

" ## Refresh if there's something new worth showing
"
" 'All things in moderation'
fu! s:temperedRefresh()
    if !exists('b:changedtickLast')
        let b:changedtickLast = b:changedtick
    elseif b:changedtickLast != b:changedtick
        let b:changedtickLast = b:changedtick
        call s:refreshView()
    endif
endfu

" I really, really hope there's a better way to do this.
fu! s:myBufNr()
    return str2nr(expand('<abuf>'))
endfu

" # Hur we go
" ## push a new Markdown buffer into the system.
"
" 1. Track it so we know when to garbage collect the daemon
" 2. Start daemon if we're on the first MD buffer.
" 3. Initialize changedtickLast, possibly needlessly(?)
fu! s:pushMarkdown()
    let bufnr = s:myBufNr()
    call s:initDict()
    if len(s:buffers) == 0
        call s:startDaemon(s:bufGetContents(bufnr))
    endif
    call s:pushBuffer(bufnr)
    let b:changedtickLast = b:changedtick
endfu

aug instant-markdown
    au! * <buffer>
    au BufEnter <buffer> call s:refreshView()
    au CursorHold,CursorHoldI,CursorMoved,CursorMovedI <buffer> call s:temperedRefresh()
    au BufWinLeave <buffer> call s:popMarkdown()
    au BufwinEnter <buffer> call s:pushMarkdown()
aug END

" ## pop a Markdown buffer
"
" 1. Pop the buffer reference
" 2. Garbage collection
"     * daemon
"     * autocmds
fu! s:popMarkdown()
    let bufnr = s:myBufNr()
    silent au! instant-markdown * <buffer=abuf>
    call s:popBuffer(bufnr)
    if len(s:buffers) == 0
        call s:killDaemon()
    endif
endfu
