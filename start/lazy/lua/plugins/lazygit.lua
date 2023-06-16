return {
  "kdheepak/lazygit.nvim",
  lazy = true,
  keys = {
    { '<a-g>l', ':<c-u>LazyGit<cr>',                  mode = { 'n', 'v', }, silent = true, desc = 'LazyGit' },
    { '<a-g>c', ':<c-u>LazyGitFilterCurrentFile<cr>', mode = { 'n', 'v', }, silent = true, desc = 'LazyGitFilterCurrentFile' },
    { '<a-g>f', ':<c-u>LazyGitFilter<cr>',            mode = { 'n', 'v', }, silent = true, desc = 'LazyGitFilter' },
    { '<a-g>C', ':<c-u>LazyGitConfig<cr>',            mode = { 'n', 'v', }, silent = true, desc = 'LazyGitConfig' },

    { '<a-g>L', ':<c-u>silent !start lazygit<cr>',    mode = { 'n', 'v', }, silent = true, desc = 'start lazygit' },
    { '<a-g>t', ':<c-u>Telescope lazygit<cr>',        mode = { 'n', 'v', }, silent = true, desc = 'Telescope lazygit' },
  },
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim"
  },
  config = function()
    require("config.lazygit")
  end,
}
