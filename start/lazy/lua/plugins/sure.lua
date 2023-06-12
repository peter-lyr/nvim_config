return {
  { "folke/lazy.nvim" },

  -- "nvim-lua/plenary.nvim",

  -- "nvim-tree/nvim-web-devicons",

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
