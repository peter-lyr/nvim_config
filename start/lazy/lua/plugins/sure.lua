return {
  { "folke/lazy.nvim" },

  -- require('plugins.plenary'),

  -- require('plugins.web-devicons'),

  {
    "dstein64/vim-startuptime",
    lazy = true,
    cmd = "StartupTime",
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

}
