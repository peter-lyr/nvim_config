-- copy_paste

vim.fn.setreg('w', 'reg w empty')

vim.keymap.set({ 'c', 'i', }, '<c-e>', '<c-r>w', { desc = 'paste <cword>', })

vim.keymap.set({ 'c', 'i', }, '<c-d>', '<c-r>"', { desc = 'paste "', })
vim.keymap.set({ 't', }, '<c-d>', '<c-\\><c-n>pi', { desc = 'paste "', })

vim.keymap.set({ 'c', 'i', }, '<c-v>', '<c-r>+', { desc = 'paste +', })
vim.keymap.set({ 't', }, '<c-v>', '<c-\\><c-n>"+pi', { desc = 'paste +', })

vim.api.nvim_create_autocmd({ 'BufLeave', 'CmdlineEnter', }, {
  callback = function()
    local word = vim.fn.expand '<cword>'
    if #word > 0 then
      vim.fn.setreg('w', word)
    end
  end,
})

-- cursor

vim.keymap.set({ 'n', 'v', }, 'k', "(v:count == 0 && &wrap) ? 'gk' : 'k'", { expr = true, silent = true, })
vim.keymap.set({ 'n', 'v', }, 'j', "(v:count == 0 && &wrap) ? 'gj' : 'j'", { expr = true, silent = true, })

vim.keymap.set({ 't', 'c', 'i', }, '<a-k>', '<UP>', { desc = 'up', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-j>', '<DOWN>', { desc = 'down', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-k>', '<UP><UP><UP><UP><UP>', { desc = '5 up', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-j>', '<DOWN><DOWN><DOWN><DOWN><DOWN>', { desc = '5 down', })

vim.keymap.set({ 't', 'c', 'i', }, '<a-i>', '<HOME>', { desc = 'home', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-i>', '<HOME>', { desc = 'home', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-o>', '<END>', { desc = 'end', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-o>', '<END>', { desc = 'end', })

vim.keymap.set({ 't', 'c', 'i', }, '<a-l>', '<RIGHT>', { desc = 'right', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-h>', '<LEFT>', { desc = 'left', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-l>', '<c-RIGHT>', { desc = 'ctrl right', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-h>', '<c-LEFT>', { desc = 'ctrl left', })

vim.keymap.set({ 't', 'c', 'i', }, '<a-w>', '<UP>', { desc = 'up', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s>', '<DOWN>', { desc = 'down', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-w>', '<UP><UP><UP><UP><UP>', { desc = '5 up', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-s>', '<DOWN><DOWN><DOWN><DOWN><DOWN>', { desc = '5 down', })

vim.keymap.set({ 't', 'c', 'i', }, '<a-q>', '<HOME>', { desc = 'home', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-q>', '<HOME>', { desc = 'home', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-e>', '<END>', { desc = 'end', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-e>', '<END>', { desc = 'end', })

vim.keymap.set({ 't', 'c', 'i', }, '<a-d>', '<RIGHT>', { desc = 'right', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-a>', '<LEFT>', { desc = 'left', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-d>', '<c-RIGHT>', { desc = 'ctrl right', })
vim.keymap.set({ 't', 'c', 'i', }, '<a-s-a>', '<c-LEFT>', { desc = 'ctrl left', })

vim.keymap.set({ 'v', }, '<c-l>', 'L', { desc = 'L', })
vim.keymap.set({ 'v', }, '<c-h>', 'H', { desc = 'H', })
vim.keymap.set({ 'v', }, '<c-m>', 'M', { desc = 'M', })
vim.keymap.set({ 'v', }, '<c-u>', 'U', { desc = 'U', })
vim.keymap.set({ 'v', }, '<c-e>', 'E', { desc = 'E', })
vim.keymap.set({ 'v', }, '<c-w>', 'W', { desc = 'W', })
vim.keymap.set({ 'v', }, '<c-b>', 'B', { desc = 'B', })

-- esc

vim.keymap.set({ 'v', }, 'qq', '<esc><esc><esc>', { desc = 'esc', })
vim.keymap.set({ 't', }, '<esc>', '<c-\\><c-n>', { desc = 'esc', })
vim.keymap.set({ 'i', }, 'sf', '<esc><esc>', { desc = 'esc', })
vim.keymap.set({ 't', }, 'sf', '<c-\\><c-n>', { desc = 'esc', })

-- new line

vim.keymap.set({ 'i', }, '<a-z>', '<esc>o', { desc = 'new line', })

-- enter

vim.keymap.set({ 't', 'c', }, '<a-z>', '<cr>', { desc = 'enter', })
