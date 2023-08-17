return {
  'lewis6991/gitsigns.nvim',
  event = { "BufReadPre", "BufNewFile", },
  lazy = true,
  config = function()
    require 'config.gitsigns'
  end,
}
