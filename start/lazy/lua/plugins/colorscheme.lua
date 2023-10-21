return {
  {
    'navarasu/onedark.nvim',
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile', },
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },
}
