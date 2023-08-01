return {
  "folke/zen-mode.nvim",
  lazy = true,
  cmd = {
    'ZenMode',
  },
  keys = {
    {
      '<leader>zm',
      '<cmd>ZenMode<cr>',
      mode = { 'n', 'v' },
      silent = true,
      desc = 'ZenMode'
    },
    {
      '<leader><leader><leader>',
      function()
        require("config.zenmode").toggle()
      end,
      mode = { 'n', 'v' },
      silent = true,
      desc = 'ZenMode max width'
    },
  },
  opts = {
    window = {
      width = 0.62,
    },
  }
}
