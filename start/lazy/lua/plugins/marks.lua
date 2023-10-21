return {
  -- 'chentoast/marks.nvim',
  'peter-lyr/marks.nvim',
  lazy = true,
  event = { 'BufReadPost', 'BufNewFile', },
  keys = {
    { 'mq', '<cmd>MarksQFListBuf<cr>', mode = { 'n', 'v', }, silent = true, desc = 'MarksQFListBuf', },
  },
  config = function()
    require 'config.marks'
  end,
}
