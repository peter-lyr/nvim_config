-- return {
--   'jghauser/shade.nvim',
--   lazy = true,
--   event = { "CursorHold", "CursorHoldI", },
--   config = function()
--     require('shade').setup({
--       overlay_opacity = 50,
--       opacity_step = 1,
--       -- debug = true,
--       keys = {
--         brightness_up   = '<C-Up>',
--         brightness_down = '<C-Down>',
--         toggle          = '<leader>ts',
--       }
--     })
--   end
-- }


return {
  "rosstang/dimit.nvim",
  lazy = true,
  event = { "CursorHold", "CursorHoldI", },
  config = function()
    require("dimit").setup()
  end,
}


-- return {
--   "levouh/tint.nvim",
--   lazy = true,
--   event = { "CursorHold", "CursorHoldI", },
--   config = function()
--     require("tint").setup()
--   end,
-- }
