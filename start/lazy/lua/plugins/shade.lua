return {
  "rosstang/dimit.nvim",
  lazy = true,
  event = { "CursorHold", "CursorHoldI", },
  config = function()
    require("dimit").setup({
      bgcolor = "#000000",
    })
  end,
}
