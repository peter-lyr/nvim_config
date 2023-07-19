-- return {
--   "rosstang/dimit.nvim",
--   lazy = true,
--   event = { "CursorHold", "CursorHoldI", },
--   config = function()
--     require("dimit").setup()
--   end,
-- }

return {
  "levouh/tint.nvim",
  lazy = true,
  event = { "CursorHold", "CursorHoldI", },
  config = function()
    require("tint").setup()
  end,
}
