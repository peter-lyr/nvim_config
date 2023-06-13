local bufferjump = require('bufferjump')

vim.keymap.set({ 'n', 'v' }, '<leader>wp', '<c-w>p', { silent = true, desc = 'wincmd p' })

vim.keymap.set({ 'n', 'v' }, '<leader>wk', bufferjump.k, { silent = true, desc = 'wincmd k' })
vim.keymap.set({ 'n', 'v' }, '<leader>wj', bufferjump.j, { silent = true, desc = 'wincmd j' })
vim.keymap.set({ 'n', 'v' }, '<leader>wh', '<c-w>h', { silent = true, desc = 'wincmd h' })
vim.keymap.set({ 'n', 'v' }, '<leader>wl', '<c-w>l', { silent = true, desc = 'wincmd l' })
