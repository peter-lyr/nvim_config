return {
  "folke/zen-mode.nvim",
  lazy = true,
  cmd = {
    'ZenMode',
  },
  keys = {
    { '<leader>zm', '<cmd>ZenMode<cr>', mode = { 'n', 'v' },  silent = true, desc = 'ZenMode' },
    { '<leader>zz', function() require("zen-mode").toggle({ window = { width = 1 } }) end, mode = { 'n', 'v' },  silent = true, desc = 'ZenMode max width' },
  },
  opts = {
    window = {
      width = 0.62,
    },
  }
}
