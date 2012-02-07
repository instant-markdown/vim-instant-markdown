Strategy
--------
- on file open, write file, launch node server, open page in new bground window (client will automatically initiate websocket)
  - Open private browsing session
  - On mac, use `open -a safari -g `
  - On Linux, make sure FF opens in background
- on cursormove
  - call `update! /tmp/vim-instant-markdown__<filename>`
  - if getftime differs, curl node server with filepath
- Node server gfm's file and websocket-updates page
- on file close, terminate node server, close browser window
  - Can use JS to close like this: `window.open('', '_self', '');window.close();`
  - On Mac, need to use applescript to close, based on current URL/title
  - On Linux, xdotool or similar
- vim plugin "client" manages files, node server manages browser
 
Need to do the following from applescript(s):

- refresh tab in browser
- close tab in browser
- (opening the page in the bground can be done via `open`)
