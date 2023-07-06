return {
  "folke/zen-mode.nvim",
  lazy = true,
  cmd = {
    'ZenMode',
  },
  keys = {
    { '<leader>zm', '<cmd>ZenMode<cr>', mode = { 'n', 'v' },  silent = true, desc = 'ZenMode' },
  },
  opts = {
    window = {
      width = 0.62,
    },
  }
}
