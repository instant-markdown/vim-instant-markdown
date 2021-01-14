# Problem summary

## Expected


## Environment Information

 * OS:
 * Vim / Neovim version:
 * Browser:

## Steps to reproduce the issue (required)

Start with command you used to install `instant-markdown-d` Use [a
minimal.vimrc](https://raw.githubusercontent.com/instant-markdown/vim-instant-markdown/master/doc/minimal.vimrc)
to reproduce the issue and open your markdown file as:

```sh
vim -u minimal.vimrc my_markdown_file.md
```

 1.
 2.
 3.


## Provide the debug output (required)

Run `cat my_markdown_file.md | instant-markdown-d --mathjax --debug`. It
generates a `debug.html` file. Also, paste the console output here:

```sh

```


## Generate log files (required)

```
let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
```

 1. Add the above in your `~/.vimrc` or `~/.config/nvim/init.vim`. Modify the
    path if needed and generate the log file.
 1. Minimal vimrc (see above).
 1. `debug.html`


## Screen shot (if possible)


