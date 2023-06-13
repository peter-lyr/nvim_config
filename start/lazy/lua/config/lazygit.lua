require("telescope").load_extension("lazygit")

vim.keymap.set({ 'n', }, '<leader>gl', ':<c-u>LazyGit<cr>', { silent = true })

vim.keymap.set({ 'n', }, '<leader>gt', ':<c-u>Telescope lazygit<cr>', { silent = true })
