vim-instant-markdown
====================
Want to instantly preview finnicky markdown files, but don't want to leave your favorite editor, or have to do it in some crappy browser textarea? **vim-instant-markdown** is your friend! When you open a markdown file in vim, a browser window will open which shows the compiled markdown in real-time, and closes once you close the file in vim.

As a bonus, [github-flavored-markdown][gfm] is supported, and styles used while previewing are the same as those github uses!

[![Screenshot][ss]][ssbig]

Installation
------------
You first need to have Ruby with RubyGems, and node.js with npm installed. (In the future there might be a version which won't require node.js at all, making installation easier)

- `[sudo] gem install pygments.rb`
- If you're using Ruby 1.9.2 or later, `[sudo] gem install redcarpet`. Otherwise, `[sudo] gem install redcarpet -v 2.3.0`
- `[sudo] npm -g install instant-markdown-d`
- If you're on Linux, the `xdg-utils` package needs to be installed (is installed by default on Ubuntu).
- Copy the `after/ftplugin/markdown/instant-markdown.vim` file from this repo into your `~/.vim/after/ftplugin/markdown/` (creating directories as necessary), or use pathogen.
- Ensure you have the line `filetype plugin on` in your `.vimrc`
- Open a markdown file in vim and enjoy!

Configuration
-------------
### g:instant_markdown_slow

By default, vim-instant-markdown will update the display in realtime.  If that taxes your system too much, you can specify

```
let g:instant_markdown_slow = 1
```

before loading the plugin (for example place that in your `~/.vimrc`). This will cause vim-instant-markdown to only refresh on the following events:

- No keys have been pressed for a while
- A while after you leave insert mode
- You save the file being edited

### g:instant_markdown_autostart
By default, vim-instant-markdown will automatically launch the preview window when you open a markdown file. If you want to manually control this behavior, you can specify

```
let g:instant_markdown_autostart = 0
```

in your .vimrc. You can then manually trigger preview via the command ```:InstantMarkdownPreview```. This command is only available inside markdown buffers and when the autostart option is turned off.

Supported Platforms
-------------------
OSX and Unix/Linuxes*.

<sub>*: One annoyance in Linux is that there's no way to reliably open a browser page in the background, so you'll likely have to manually refocus your vim session everytime you open a Markdown file. If you have ideas on how to address this I'd love to know!</sub>

FAQ
---
> Why don't my `<bla>.md` files trigger this plugin?

By default, vim (7.3 and above) only recognizes files ending with `.markdown`, `.mdown`, and `README.md` as markdown files. If you want `<anything>.md` to be recognized, I recommend installing one of many markdown plugins available, such as [this one][tpope-markdown].

> It's not working!

- Make sure all the dependencies are installed...
  - Make sure `instant-markdown-d` was installed as a global module (e.g. using `npm -g install`)
  - Make sure the ruby gems were installed under your default Ruby (i.e. if you're using RVM, use `gem install` and NOT `sudo gem install` as that might cause the gems to be installed under a non-RVM Ruby)
- If you're on OSX, and are using zsh and rbenv/rvm...
  - Make sure that Vim is using the correct version of ruby. From vim, if ```:!which ruby``` returns an unexpected ruby, then see here for a solution: https://github.com/dotphiles/dotzsh#mac-os-x.

etc.
---
If you're curious, the code for the mini-server component for this plugin can be found at http://github.com/suan/instant-markdown-d. A plugin can easily be written for any editor to interface with the server to get the same functionality found here.


[ss]: http://dl.dropbox.com/u/28956267/instant-markdown-demo_thumb.gif  "Click for bigger preview"
[ssbig]: http://dl.dropbox.com/u/28956267/instant-markdown-demo.gif
[gfm]: http://github.github.com/github-flavored-markdown/
[tpope-markdown]: https://github.com/tpope/vim-markdown
