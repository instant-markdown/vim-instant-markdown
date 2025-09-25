vim-instant-markdown
====================

[![open collective badge](https://opencollective.com/instant-markdown/tiers/backer/badge.svg?label=backer&color=brightgreen)](https://opencollective.com/instant-markdown/)


Want to instantly preview finicky markdown files, but don't want to leave your
favourite editor, or have to do it in some crappy browser text area?
**vim-instant-markdown** is your friend! When you open a markdown file in Vim,
a browser window will open which shows the compiled markdown in real-time, and
closes once you close the file in Vim.

As a bonus, [github-flavored-markdown][gfm] is supported, and styles used while
previewing are the same as those GitHub uses!

[![Screenshot][ss]][ssbig]

> [!TIP]
> Neovim users may want to check out [instant-markdown.nvim](https://github.com/instant-markdown/instant-markdown.nvim) -
> a full Lua rewrite of this plugin, which is compatible with the `instant-markdown-d` mini-server.

Installation
------------
**Quick start** (assuming you have all the necessary dependencies):

- [Install Node.js](https://nodejs.org/en/download)
- Install the mini-server by running either:

  - `[sudo] npm -g install instant-markdown-d`

  or the following command for the Python mini-server (which also requires
  [pandoc][pandoc] to render markdown):

  - `pip install --user smdv`

* Add the following to your `.vimrc`, depending on the plugin manager of your
  choice:

  - [vim-plug][plug]

    ```vim
    Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'npm install'}
    ```

  - [Vundle][vundle]

    ```vim
    Plugin 'instant-markdown/vim-instant-markdown'
    ```
  - Vim8 built-in package manager (Execute the following command instead of adding it to `.vimrc`)

	```shell
    # NOTE:
    # 1. Please check you have git installed.
    # 2. Please replace * with a package name you want.
    git clone https://github.com/instant-markdown/vim-instant-markdown.git ~/.vim/pack/*/start/
	```

**Detailed instructions**

- If you're on Linux, ensure the following packages are installed:
  - `xdg-utils`
  - `curl`
  - `nodejs` (Ensure that you are using a recent stable version. [Install `node` using `n` if needed][n].)
- If you're on Windows, you will need into install [cURL][curl] and put it on your `%PATH%`.
- If you do not use a plugin manager, copy the
  [`ftplugin/markdown/instant-markdown.vim`](ftplugin/markdown/instant-markdown.vim)
  file into `~/.vim/ftplugin/markdown/` (creating directories as
  necessary),
- Open a markdown file in Vim and enjoy!

**Arch-based distributions**
- There is a package available on the AUR that installs the plugin:
    - [vim-instant-markdown](https://aur.archlinux.org/packages/vim-instant-markdown)

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
"let g:instant_markdown_theme = 'dark'
```

After installing the plugin, execute [`:help vim-instant-markdown`](./doc/vim-instant-markdown.txt)
to read more about what the different configuration options imply.


Supported Platforms
-------------------

OSX, Linux^, and Windows^^.

<sub>^ One annoyance in Linux is that there's no way to reliably open a
browser page in the background, so you'll likely have to manually refocus your
Vim session every time you open a Markdown file. If you have ideas on how to
address this I'd love to know!</sub>

<sub>^^ In Windows, there's no easy way to execute commands asynchronously
without popping up a cmd.exe window. Thus, if you run this plugin without
`g:instant_markdown_slow`, you might experience performance issues.</sub>

FAQ
---
1. It's not working!

   - Make sure `instant-markdown-d` was installed and verify using
  `InstantMarkdownDPath`.
   - Try to launch with Vim and [vim-plug][plug] as follows:
     - [Install vim-plug](https://github.com/junegunn/vim-plug?tab=readme-ov-file#installation)
     - Download this [minimal.vimrc](https://raw.githubusercontent.com/instant-markdown/vim-instant-markdown/master/doc/minimal.vimrc).
       (Optional: This minimal file, installs under `/tmp`. Adjust paths from `/tmp` if needed).
     - Run `vim -u minimal.vimrc +PlugInstall +qall`
     - Open any markdown file as `vim -u vim -u minimal.vimrc my_markdown_file.md` and this plugin should activate.
   - If you're on OSX and are using zsh, try to add `set shell=bash\ -i` in your
  `.vimrc` to set interactive bash as the default Vim shell. (See [this
  issue](http://github.com/instant-markdown/vim-instant-markdown/issues/41))

2. How to start it when autostart is off?

   You can use the command `:InstantMarkdownPreview` to manually start the preview. <br>
   BTW, to disable it, use `:InstantMarkdownStop`.

_If you're curious, the code for the mini-server component for this plugin can
be found at http://github.com/instant-markdown/instant-markdown-d. A plugin can
easily be written for any editor to interface with the server to get the same
functionality found here._


[ss]: https://i.imgur.com/r7G6FNA.gif "Click for bigger preview"
[ssbig]: https://i.imgur.com/4Fty7pw.gif
[n]: https://github.com/tj/n
[gfm]: http://github.github.com/github-flavored-markdown/
[curl]: http://curl.haxx.se/download.html
[tpope-markdown]: https://github.com/tpope/vim-markdown
[plug]: https://github.com/junegunn/vim-plug
[vundle]: https://github.com/gmarik/Vundle.vim
[pandoc]: https://pandoc.org/
