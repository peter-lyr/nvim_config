return {
  "rcarriga/nvim-notify",
  lazy = true,
  keys = {
    { '<esc>', function() require('notify').dismiss() end, mode = { 'n', }, silent = true, desc = 'dismiss notification'},
  },
  config = function()
    require("notify").setup({
      top_down = false,
    })
  end,
}
