require("diffview").setup()

vim.keymap.set({ 'n', 'v' }, '<leader>gi', ':<c-u>DiffviewFileHistory<cr>', { silent = true, desc = 'diffview filehistory' })
vim.keymap.set({ 'n', 'v' }, '<leader>go', ':<c-u>DiffviewOpen -u<cr>', { silent = true, desc = 'diffview open' })
vim.keymap.set({ 'n', 'v' }, '<leader>gq', ':<c-u>DiffviewClose<cr>', { silent = true, desc = 'diffview quit' })

vim.keymap.set({ 'n', 'v' }, '<leader>ge', ':<c-u>DiffviewRefresh<cr>', { silent = true, desc = 'DiffviewRefresh' })
vim.keymap.set({ 'n', 'v' }, '<leader>gl', ':<c-u>DiffviewToggleFiles<cr>', { silent = true, desc = 'DiffviewToggleFiles' })

vim.keymap.set({ 'n', 'v' }, '<leader>xt', ':<c-u>tabclose<cr>', { silent = true, desc = 'tabclose' })
