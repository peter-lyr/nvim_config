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
    vim.api.nvim_create_autocmd({ "CursorHold", }, {
      callback = function()
        require("tint").untint(vim.fn.win_getid())
      end,
    })
  end,
}
