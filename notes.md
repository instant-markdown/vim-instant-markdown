Strategy
--------
- Use Docter as-is (install it, but just call the Ruby binary)
- on file open, write file, launch node server, open page in new bground window (client will automatically initiate websocket)
  - Open private browsing session
  - On mac, use `open -a safari -g `
  - On Linux, make sure FF opens in background
- on cursormove
  - try using changedtick
      - To pipe buffer into command, do `let current_buffer = getbufline("%", 1, "$")`, then...
      - `exec !cat . current_buffer | gfm`
      - This way we avoid writing to disk
  - if too taxing, try BufWritePre with update
  - call `update! /tmp/vim-instant-markdown__<filename>`
  - if too taxing, do: if getftime differs, curl node server with filepath
- Node server gfm's file and websocket-updates page
- on file close, terminate node server, close browser window
  - Can use JS to close like this: `window.open('', '_self', '');window.close();`
- vim plugin "client" manages files, node server manages browser
 
Need to do the following from applescript(s):

- refresh tab in browser
- close tab in browser
- (opening the page in the bground can be done via `open`)
