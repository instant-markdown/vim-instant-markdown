vim-instant-markdown
====================

[![open collective badge](https://opencollective.com/instant-markdown/tiers/backer/badge.svg?label=backer&color=brightgreen)](https://opencollective.com/instant-markdown/)

Want to instantly preview finicky markdown files, but don't want to leave your
favourite editor, or have to do it in some crappy browser text area?
**vim-instant-markdown** is your friend! When you open a markdown file in vim,
a browser window will open which shows the compiled markdown in real-time, and
closes once you close the file in vim.

As a bonus, [github-flavored-markdown][gfm] is supported, and styles used while
previewing are the same as those GitHub uses!

[![Screenshot][ss]][ssbig]

Installation
------------
**Quick start** (assuming you have all the necessary dependencies):

- Install the mini-server by running either:

  - `[sudo] npm -g install instant-markdown-d` or, for the pre-release version:
  - `[sudo] npm -g install instant-markdown-d@next`

  or the following command for the Python mini-server (which also requires
  [pandoc][pandoc] to render markdown):

  - `pip install --user smdv`

* Add the following to your `.vimrc`, depending on the plugin manager of your
  choice:

  - [vim-plug][plug]

    ```vim
    Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}
    ```

  - [Vundle][vundle]

    ```vim
    Plugin 'instant-markdown/vim-instant-markdown'
    ```

**Detailed instructions**

- If you're on Linux, ensure the following packages are installed:
  - `xdg-utils`
  - `curl`
  - `nodejs`
- If you're on Windows, you will need into install [cURL][curl] and put it on your `%PATH%`.
- If you do not use a plugin manager, copy the
  [`ftplugin/markdown/instant-markdown.vim`](ftplugin/markdown/instant-markdown.vim)
  file into `~/.vim/ftplugin/markdown/` (creating directories as
  necessary),
- Open a markdown file in vim and enjoy!


Configuration
-------------

Minimal default configuration:

```vim
filetype plugin on
"Uncomment to override defaults:
"let g:instant_markdown_slow = 1
"let g:instant_markdown_autostart = 0
"let g:instant_markdown_open_to_the_world = 1
"let g:instant_markdown_allow_unsafe_content = 1
"let g:instant_markdown_allow_external_content = 0
"let g:instant_markdown_mathjax = 1
"let g:instant_markdown_mermaid = 1
"let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
"let g:instant_markdown_autoscroll = 0
"let g:instant_markdown_port = 8888
"let g:instant_markdown_python = 1
```

After installing the plugin, execute [`:help vim-instant-markdown-configuration`](./doc/vim-instant-markdown.txt)
to read more about what the different configuration options imply.

Supported Platforms
-------------------
OSX, Unix/Linuxes*, and Windows**.

<sub>*: One annoyance in Linux is that there's no way to reliably open a
browser page in the background, so you'll likely have to manually refocus your
vim session everytime you open a Markdown file. If you have ideas on how to
address this I'd love to know!</sub>

<sub>**: In Windows, there's no easy way to execute commands asynchronously
without popping up a cmd.exe window. Thus, if you run this plugin without
`g:instant_markdown_slow`, you might experience performance issues.</sub>

FAQ
---
> It's not working!

- Make sure `instant-markdown-d` was installed as a global module (e.g. using
  `npm -g install`)
- Try to launch with Vim and [vim-plug][plug] and this
  [minimal.vimrc](https://raw.githubusercontent.com/instant-markdown/vim-instant-markdown/master/doc/minimal.vimrc)
  as `vim -u vim -u minimal.vimrc my_markdown_file.md`
- If you're on OSX and are using zsh, try to add `set shell=bash\ -i` in your
  `.vimrc` to set interactive bash as the default Vim shell. (See [this
  issue](http://github.com/instant-markdown/vim-instant-markdown/issues/41))

_If you're curious, the code for the mini-server component for this plugin can
be found at http://github.com/instant-markdown/instant-markdown-d. A plugin can
easily be written for any editor to interface with the server to get the same
functionality found here._


[ss]: https://i.imgur.com/r7G6FNA.gif "Click for bigger preview"
[ssbig]: https://i.imgur.com/4Fty7pw.gif
[gfm]: http://github.github.com/github-flavored-markdown/
[curl]: http://curl.haxx.se/download.html
[tpope-markdown]: https://github.com/tpope/vim-markdown
[plug]: https://github.com/junegunn/vim-plug
[vundle]: https://github.com/gmarik/Vundle.vim
[pandoc]: https://pandoc.org/
