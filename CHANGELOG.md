### 0.0.2 (03-27-2012)
All changes for this release were made in the backend. Do `[sudo] npm -g update instant-markdown-d` to get them.

- Updated to the latest github styles!
- Performance should be slightly better as CSS is no longer generated at every update.

### 0.0.3 (04-26-2012)
Some changes for this release were made in the backend. Do `[sudo] npm -g update instant-markdown-d` to get them.

- Delay starting the `instant-markdown-d` server. This fixed the plugin for a few people who were getting empty browser windows.
- Display a message with configuration instructions when the preview window can't be closed due to Firefox restrictions.

### 0.0.4 (12-05-2012)
All these changes courtesy of @chreekat, THANKS!

- Is now an `after/ftplugin` plugin. Markdown filetype detection is left to Vim itself, or other plugins.
- Behavior when multiple markdown files are open has been improved
- No more weird characters taking over the status/command bar while editing
- Internals have been completely rewritten and are much more cleaner and adhere to vim script best practices

### 0.0.5 (12-05-2012)
These changes are _also_ courtesy of @chreekat!

- Plugin no longer breaks vim mouse scrolling
- No longer errors upon opening an empty markdown file
- `instant_markdown_slow` option to update preview less frequently

### 0.0.6 (03-02-2013)
All changes for this release were made in the backend. Do `[sudo] npm -g update instant-markdown-d` to get them.

- Fix for systems (such as Ubuntu, Debian) which use the `nodejs` executable instead of `node`.

### 0.0.7 (10-31-2013)
thanks to @terryma!

- Added option to only start previewing markdown on demand

### 0.0.8 (01-17-2015)
All changes for this release were made in the backend. Do `[sudo] npm -g update instant-markdown-d` to get them. All thanks to the awesome work of @euclio!

- Ruby dependencies (pygments.rb and redcarpet) are no longer required! `instant-markdown-d` is now the only dependency
- Plugin should be _much_ more performant and stable. Should be able to edit at brisk typing speed without slowdowns or crashes.
- Updated to the latest github styles!
  - Due to github not fully open-sourcing their current syntax highlighting pipeline, syntax highlighting colors are _slightly_ different.

### 0.0.9 (12-13-2017)
Changes proposed by @twidxuga:

- Implemented math rendering with Katex 0.8.3 (in instant-markdown-d). Note that a newer branch of markdown-it-katex was added as a dependency, since it works well with newer versions of Katex (master only goes up to 0.7.1).
- It is now possible to server all files starting from the folder containing the markdown file being edited if the new option  `g:instant_markdown_serve_folder_tree = 0` is specified in a user's .vimrc/init.vim (default value is set to 0). This allows serving images, pdf files, svg files, etc. without restriction by format. 
- Fixed issue (at least with Neovim and Linux) by which environment variables set in the vim plugin were not passed onto the instant-markdown-d server.
- Re-factored all CSS and font files under the sames folder `imd_static` (Perhaps the Katex fonts and its CSS could be referenced from the node_modules directory in future, as an improvement)


