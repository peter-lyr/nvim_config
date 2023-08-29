return {
  { "folke/lazy.nvim", },

  {
    "dstein64/vim-startuptime",
    lazy = true,
    cmd = "StartupTime",
  },

  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd [[colorscheme tokyonight]]
  --   end,
  -- },

  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  }

}
