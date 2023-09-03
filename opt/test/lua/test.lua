vim.cmd(string.format([[ call feedkeys("\<esc>:AsyncRun rg --no-heading --with-filename --line-number --column --smart-case --no-ignore -g !*.js [\u4e00-\u9fa5]+ \<c-r>=expand('%:p:h')\<cr>") ]]))
