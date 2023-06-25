return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "VeryLazy" },
  opt = {
    space_char_blankline = " ",
      char = "│",
      filetype_exclude = {
        "qf",
        "help",
        "neo-tree",
        "lazy",
        "mason",
        "notify",
      },
      show_trailing_blankline_indent = false,
      show_current_context = false,
  },
}
