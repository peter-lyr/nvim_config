return {
  "lukas-reineke/indent-blankline.nvim",
  lazy = true,
  event = { "CursorMoved", "CursorMovedI" },
  init = function()
    vim.opt.list = true
  end,
  opt = {
    space_char_blankline = " ",
    -- show_current_context = true,
    -- show_current_context_start = true,
  },
}
