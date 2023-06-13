local bufferjump = require('bufferjump')

vim.keymap.set({ 'n', 'v' }, '<leader>wp', '<c-w>p', { silent = true, desc = 'wincmd p' })

vim.keymap.set({ 'n', 'v' }, '<leader>wk', bufferjump.k, { silent = true, desc = 'wincmd k' })
vim.keymap.set({ 'n', 'v' }, '<leader>wj', bufferjump.j, { silent = true, desc = 'wincmd j' })
vim.keymap.set({ 'n', 'v' }, '<leader>wh', '<c-w>h', { silent = true, desc = 'wincmd h' })
vim.keymap.set({ 'n', 'v' }, '<leader>wl', '<c-w>l', { silent = true, desc = 'wincmd l' })

vim.keymap.set({ 'n', 'v' }, '<leader>wo', '<c-w>_', { silent = true, desc = 'wincmd _' })
vim.keymap.set({ 'n', 'v' }, '<leader>wu', '<c-w>|', { silent = true, desc = 'wincmd |' })
vim.keymap.set({ 'n', 'v' }, '<leader>wi', bufferjump.i, { silent = true, desc = 'wincmd =' })

vim.keymap.set({ 'n', 'v' }, '<leader><leader>wi', bufferjump.ii, { silent = true, desc = 'win height auto max disable' })
vim.keymap.set({ 'n', 'v' }, '<leader><leader>wo', bufferjump.oo, { silent = true, desc = 'win height auto max enable' })
