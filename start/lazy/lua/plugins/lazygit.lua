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
    { '<leader>gll', ':<c-u>LazyGit<cr>',                  mode = { 'n', 'v', }, silent = true, desc = 'LazyGit', },
    { '<leader>glf', ':<c-u>LazyGitFilterCurrentFile<cr>', mode = { 'n', 'v', }, silent = true, desc = 'LazyGitFilterCurrentFile', },
    { '<leader>glg', ':<c-u>LazyGitFilter<cr>',            mode = { 'n', 'v', }, silent = true, desc = 'LazyGitFilter', },
    { '<leader>glo', ':<c-u>LazyGitConfig<cr>',            mode = { 'n', 'v', }, silent = true, desc = 'LazyGitConfig', },

    { '<leader>glk', ':<c-u>silent !start lazygit<cr>',    mode = { 'n', 'v', }, silent = true, desc = 'start lazygit', },
    { '<leader>glj', ':<c-u>Telescope lazygit<cr>',        mode = { 'n', 'v', }, silent = true, desc = 'Telescope lazygit', },
  },
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require "config.lazygit"
  end,
}
