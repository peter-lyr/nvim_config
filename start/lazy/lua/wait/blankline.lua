return {
  "lukas-reineke/indent-blankline.nvim",
  lazy = true,
  event = { "BufReadPost", "BufNewFile" },
  opt = {
    space_char_blankline = " ",
      char = "│",
      filetype_exclude = {
        "help",
        -- "alpha",
        -- "dashboard",
        "neo-tree",
        -- "Trouble",
        "lazy",
        "mason",
        "notify",
        -- "toggleterm",
        -- "lazyterm",
      },
      show_trailing_blankline_indent = false,
      show_current_context = false,
  },
}
