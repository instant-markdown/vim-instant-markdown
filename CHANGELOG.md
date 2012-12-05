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
