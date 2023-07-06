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
    { '<leader>g<c-l>', ':<c-u>LazyGit<cr>',                  mode = { 'n', 'v', }, silent = true, desc = 'LazyGit' },
    { '<leader>g<c-f>', ':<c-u>LazyGitFilterCurrentFile<cr>', mode = { 'n', 'v', }, silent = true, desc = 'LazyGitFilterCurrentFile' },
    { '<leader>g<c-g>', ':<c-u>LazyGitFilter<cr>',            mode = { 'n', 'v', }, silent = true, desc = 'LazyGitFilter' },
    { '<leader>g<c-o>', ':<c-u>LazyGitConfig<cr>',            mode = { 'n', 'v', }, silent = true, desc = 'LazyGitConfig' },

    { '<leader>g<c-k>', ':<c-u>silent !start lazygit<cr>',    mode = { 'n', 'v', }, silent = true, desc = 'start lazygit' },
    { '<leader>g<c-j>', ':<c-u>Telescope lazygit<cr>',        mode = { 'n', 'v', }, silent = true, desc = 'Telescope lazygit' },
  },
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim"
  },
  config = function()
    require("config.lazygit")
  end,
}
