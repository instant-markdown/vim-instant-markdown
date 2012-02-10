vim-instant-markdown
====================
Want to instantly preview finnicky markdown files, but don't want to leave your favorite editor, or have to do it in some crappy browser textarea? **vim-instant-markdown** is your friend! When you open a markdown file in vim, a browser window will open which shows the compiled markdown in real-time, and closes once you close the file in vim.

Installation
------------
You first need to have Ruby with RubyGems, and node.js with npm installed. (In the future there might be a version which won't require node.js at all, making installation easier)

- `[sudo] gem install redcarpet pygments.rb`
- `[sudo] npm -g install instant-markdown-d`
- Copy the instant-markdown.vim file from this repo and and place it in your ~/.vim/plugin folder, or use pathogen.
- Open a markdown file in vim and enjoy!

etc.
---
If you're curious, the code for the mini-server component for this plugin can be found at http://github.com/suan/instant-markdown-d. A plugin can easily be written for any editor to interface with the server to get the same functionality found here.
