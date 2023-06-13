require("telescope").load_extension("lazygit")

vim.keymap.set({ 'n', }, '<leader>gl', ':<c-u>LazyGit<cr>', { silent = true, desc = 'LazyGit' })
vim.keymap.set({ 'n', }, '<leader>gc', ':<c-u>LazyGitFilterCurrentFile<cr>', { silent = true, desc = 'LazyGitFilterCurrentFile' })
vim.keymap.set({ 'n', }, '<leader>gf', ':<c-u>LazyGitFilter<cr>', { silent = true, desc = 'LazyGitFilter' })
vim.keymap.set({ 'n', }, '<leader>gC', ':<c-u>LazyGitConfig<cr>', { silent = true, desc = 'LazyGitConfig' })

vim.keymap.set({ 'n', }, '<leader>gL', ':<c-u>silent !start lazygit<cr>', { silent = true, desc = 'start lazygit' })
vim.keymap.set({ 'n', }, '<leader>gt', ':<c-u>Telescope lazygit<cr>', { silent = true, desc = 'Telescope lazygit' })
