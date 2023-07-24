return {
  "kdheepak/lazygit.nvim",
  lazy = true,
  cmd = {
    'LazyGit',
    'LazyGitFilterCurrentFile',
    'LazyGitFilter',
    'LazyGitConfig',
  },
  keys = {
    { '<leader>gvl', ':<c-u>LazyGit<cr>',                  mode = { 'n', 'v', }, silent = true, desc = 'LazyGit' },
    { '<leader>gvf', ':<c-u>LazyGitFilterCurrentFile<cr>', mode = { 'n', 'v', }, silent = true, desc = 'LazyGitFilterCurrentFile' },
    { '<leader>gvg', ':<c-u>LazyGitFilter<cr>',            mode = { 'n', 'v', }, silent = true, desc = 'LazyGitFilter' },
    { '<leader>gvo', ':<c-u>LazyGitConfig<cr>',            mode = { 'n', 'v', }, silent = true, desc = 'LazyGitConfig' },

    { '<leader>gvk', ':<c-u>silent !start lazygit<cr>',    mode = { 'n', 'v', }, silent = true, desc = 'start lazygit' },
    { '<leader>gvj', ':<c-u>Telescope lazygit<cr>',        mode = { 'n', 'v', }, silent = true, desc = 'Telescope lazygit' },
  },
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim"
  },
  config = function()
    require("config.lazygit")
  end,
}
