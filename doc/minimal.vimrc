set nocompatible
filetype off

call plug#begin('/tmp/instant-markdown-plugged/')
Plug 'junegunn/vim-plug'
Plug 'instant-markdown/vim-instant-markdown', {'for': ['markdown', 'markdown.pandoc'], 'do': 'npm install'}
call plug#end()

filetype plugin indent on
syntax enable
set nomore
set noswapfile
set viminfo=

let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
"Uncomment to override defaults:
"let g:instant_markdown_slow = 1
"let g:instant_markdown_autostart = 0
"let g:instant_markdown_open_to_the_world = 1
"let g:instant_markdown_allow_unsafe_content = 1
"let g:instant_markdown_allow_external_content = 0
let g:instant_markdown_mathjax = 1
let g:instant_markdown_mermaid = 1
"let g:instant_markdown_autoscroll = 0
"let g:instant_markdown_port = 8888
"let g:instant_markdown_python = 1
"let g:instant_markdown_theme = 'dark'
