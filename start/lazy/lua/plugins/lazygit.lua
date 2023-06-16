return {
  "kdheepak/lazygit.nvim",
  lazy = true,
  keys = {
    { '<leader>gl', ':<c-u>LazyGit<cr>',                  mode = { 'n', 'v', }, silent = true, desc = 'LazyGit' },
    { '<leader>gc', ':<c-u>LazyGitFilterCurrentFile<cr>', mode = { 'n', 'v', }, silent = true, desc = 'LazyGitFilterCurrentFile' },
    { '<leader>gf', ':<c-u>LazyGitFilter<cr>',            mode = { 'n', 'v', }, silent = true, desc = 'LazyGitFilter' },
    { '<leader>gC', ':<c-u>LazyGitConfig<cr>',            mode = { 'n', 'v', }, silent = true, desc = 'LazyGitConfig' },

    { '<leader>gL', ':<c-u>silent !start lazygit<cr>',    mode = { 'n', 'v', }, silent = true, desc = 'start lazygit' },
    { '<leader>gt', ':<c-u>Telescope lazygit<cr>',        mode = { 'n', 'v', }, silent = true, desc = 'Telescope lazygit' },
  },
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim"
  },
  config = function()
    require("config.lazygit")
  end,
}
