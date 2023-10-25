return {
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
  },
  {
    'dstein64/vim-startuptime',
    lazy = true,
  },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
  {
    'navarasu/onedark.nvim',
    lazy = true,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },
}
