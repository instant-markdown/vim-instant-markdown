" # Configuration
if !exists('g:instant_markdown_slow')
    let g:instant_markdown_slow = 0
endif

if !exists('g:instant_markdown_autostart')
    let g:instant_markdown_autostart = 1
endif

if !exists('g:instant_markdown_open_to_the_world')
    let g:instant_markdown_open_to_the_world = 0
endif

if !exists('g:instant_markdown_allow_unsafe_content')
    let g:instant_markdown_allow_unsafe_content = 0
endif

if !exists('g:instant_markdown_allow_external_content')
    let g:instant_markdown_allow_external_content = 1
endif

if !exists('g:instant_markdown_mathjax')
    let g:instant_markdown_mathjax = 0
endif

if !exists('g:instant_markdown_mermaid')
    let g:instant_markdown_mermaid = 0
endif

if !exists('g:instant_markdown_theme')
    let g:instant_markdown_theme = 'light'
endif



if !exists('g:instant_markdown_logfile')
    let g:instant_markdown_logfile = (has('win32') || has('win64') ? 'NUL' : '/dev/null')
elseif filereadable(g:instant_markdown_logfile)
    "Truncate the log file
    call writefile([''], g:instant_markdown_logfile)
endif

if !exists('g:instant_markdown_autoscroll')
    let g:instant_markdown_autoscroll = 1
endif

if !exists('g:instant_markdown_port')
    let g:instant_markdown_port = 8090
endif

if !exists('g:instant_markdown_python')
    let g:instant_markdown_python = 0
endif


" # Utility Functions
let s:ROOT_DIR = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:shell_redirect = ' 1>> '. g:instant_markdown_logfile . ' 2>&1 '
" Simple system wrapper that ignores empty second args
function! s:system(cmd, stdin)
    if strlen(a:stdin) == 0
        call system(a:cmd)
    else
        call system(a:cmd, a:stdin)
    endif
endfu

" Wrapper function to automatically execute the command asynchronously and
" redirect output in a cross-platform way. Note that stdin must be passed as a
" List of lines.
function! s:systemasync(cmd, stdinLines)
    let cmd = a:cmd . s:shell_redirect
    if has('win32') || has('win64')
        call s:winasync(cmd, a:stdinLines)
    elseif has('nvim')
        let job_id = jobstart(cmd)
        call chansend(job_id, join(a:stdinLines, "\n"))
        call chanclose(job_id, 'stdin')
    else
        let cmd = cmd . ' &'
        call s:system(cmd, join(a:stdinLines, "\n"))
    endif
endfu

" Executes a system command asynchronously on Windows. The List stdinLines will
" be concatenated and passed as stdin to the command. If the List is empty,
" stdin will also be empty.
function! s:winasync(cmd, stdinLines)
    " To execute a command asynchronously on windows, the script must use the
    " "!start" command. However, stdin can't be passed to this command like
    " system(). Instead, the lines are saved to a file and then piped into the
    " command.
    if len(a:stdinLines)
        let tmpfile = tempname()
        call writefile(a:stdinLines, tmpfile)
        let command = 'type ' . tmpfile . ' | ' . a:cmd
    else
        let command = a:cmd
    endif
    exec 'silent !start /b cmd /c ' . command
endfu

function! s:refreshView()
    let bufnr = expand('<bufnr>')
    call s:systemasync("curl -X PUT -T - http://localhost:".g:instant_markdown_port,
                \ s:bufGetLines(bufnr))
endfu

function! s:startDaemon(initialMDLines)
    let env = ''
    let argv = ''
    if !g:instant_markdown_python
        if g:instant_markdown_open_to_the_world
            let env .= 'INSTANT_MARKDOWN_OPEN_TO_THE_WORLD=1 '
        endif
        if g:instant_markdown_allow_unsafe_content
            let env .= 'INSTANT_MARKDOWN_ALLOW_UNSAFE_CONTENT=1 '
        endif
        if !g:instant_markdown_allow_external_content
            let env .= 'INSTANT_MARKDOWN_BLOCK_EXTERNAL=1 '
        endif
        if g:instant_markdown_mathjax
            let argv .= ' --mathjax'
        endif
        if g:instant_markdown_mermaid
            let argv .= ' --mermaid'
        endif
    endif
    if exists('g:instant_markdown_browser')
        let argv .= " --browser '".g:instant_markdown_browser."'"
    endif
    let argv .= ' --port '.g:instant_markdown_port

    if exists('g:instant_markdown_theme')
        let argv .= ' --theme '.g:instant_markdown_theme
    endif

    if g:instant_markdown_python
        call s:systemasync(env.'smdv --stdin'.argv, a:initialMDLines)
    else
        call s:systemasync(env.s:ResolveExecutable(s:ROOT_DIR).argv, a:initialMDLines)
    endif
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
    call s:systemasync("curl -X DELETE -w 'exit status: %{http_code}' http://localhost:".g:instant_markdown_port, [])
endfu

function! s:bufGetLines(bufnr)
  let lines = getbufline(a:bufnr, 1, "$")

  if g:instant_markdown_autoscroll
    " inject row marker

    " The marker is inserted after an empty line to prevent it from interfering with
    " mathjax/latex equations (which do not allow empty lines). The marker needs to be inserted
    " before a non-empty line. 

    " start of line followed by optional whitespace
    " followed by one of '\r\n', '\r' or '\n' optionally followed by white
    " space followed by non-whitespace '\S'
    let pattern = '^\s*\(\(\r\n\|[\n\r]\).*\S\)\@='

    " search backwards from cursor and don't wrap around and don't move cursor
    let row_num = search(pattern,'bnW')

    " The marker needs to be inserted on new line otherwise two paragraphs might be fused.
    call insert(lines, '<a name="#marker" id="marker"></a>', row_num)
  endif

  return lines
endfu

" I really, really hope there's a better way to do this.
fu! s:myBufNr()
    return str2nr(expand('<abuf>'))
endfu

" # Functions called by autocmds
"
" ## push a new Markdown buffer into the system.
"
" 1. Track it so we know when to garbage collect the daemon
" 2. Start daemon if we're on the first MD buffer.
" 3. Initialize changedtickLast, possibly needlessly(?)
fu! s:pushMarkdown()
    let bufnr = s:myBufNr()
    call s:initDict()
    if len(s:buffers) == 0
        call s:startDaemon(s:bufGetLines(bufnr))
    endif
    call s:pushBuffer(bufnr)
    let b:changedtickLast = b:changedtick
endfu

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

fu! s:previewMarkdown()
  call s:startDaemon(getline(1, '$'))
  aug instant-markdown
    if g:instant_markdown_slow
      au CursorHold,BufWrite,InsertLeave <buffer> call s:temperedRefresh()
    else
      au CursorHold,CursorHoldI,CursorMoved,CursorMovedI <buffer> call s:temperedRefresh()
    endif
    au BufUnload <buffer> call s:cleanUp()
  aug END
endfu

fu! s:cleanUp()
  call s:killDaemon()
  au! instant-markdown * <buffer>
endfu

if g:instant_markdown_autostart
    " # Define the autocmds "
    aug instant-markdown
        au! * <buffer>
        au BufEnter <buffer> call s:refreshView()
        if g:instant_markdown_slow
          au CursorHold,BufWrite,InsertLeave <buffer> call s:temperedRefresh()
        else
          au CursorHold,CursorHoldI,CursorMoved,CursorMovedI <buffer> call s:temperedRefresh()
        endif
        au BufUnload <buffer> call s:popMarkdown()
        au BufWinEnter <buffer> call s:pushMarkdown()
    aug END
endif

" Searches for the existence of a directory accross
" ancestral parents
function! s:TraverseAncestorDirSearch(rootDir) abort
  let l:root = a:rootDir
  let l:dir = 'node_modules'

  while 1
    let l:searchDir = l:root . '/' . l:dir
    if isdirectory(l:searchDir)
      return l:searchDir
    endif

    let l:parent = fnamemodify(l:root, ':h')
    if l:parent == l:root
      return -1
    endif

    let l:root = l:parent
  endwhile
endfunction

function! s:ResolveExecutable(...) abort
  let l:rootDir = a:0 > 0 ? a:1 : 0
  let l:exec = -1

  if executable('instant-markdown-d')
    let l:exec = 'instant-markdown-d'
  elseif isdirectory(l:rootDir)
    let l:dir = s:TraverseAncestorDirSearch(l:rootDir)
    if l:dir != -1
      let l:exec = s:GetExecPath(l:dir)
    endif
  else
    let l:exec = s:GetExecPath()
  endif

  if l:exec == -1
    echoerr "Node.js server instant-markdown-d is unavailable. See https://github.com/instant-markdown/instant-markdown-d for installation instructions"
  endif

  return l:exec
endfunction

function! s:GetExecPath(...) abort
  let l:rootDir = a:0 > 0 ? a:1 : -1
  let l:dir = l:rootDir != -1 ? l:rootDir . '/.bin/' : ''
  let l:path = l:dir . 'instant-markdown-d'
  if executable(l:path)
    return l:path
  else
    return l:dir . 'instant-markdown-d'
  endif
endfunction

function! s:instant_markdown_d_path()
  let l:pluginExec = s:ResolveExecutable(s:ROOT_DIR)
  echom l:pluginExec
endfu

command! -buffer InstantMarkdownPreview call s:previewMarkdown()
command! -buffer InstantMarkdownStop call s:cleanUp()
command! InstantMarkdownDPath call s:instant_markdown_d_path()
