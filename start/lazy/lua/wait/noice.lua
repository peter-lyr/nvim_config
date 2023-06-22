return {
  "folke/noice.nvim",
  lazy = true,
  dependencies = {
    "MunifTanjim/nui.nvim",
    require('wait.notify'),
  },
  config = function()
    require("noice").setup()
  end
}
