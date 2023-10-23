return {
  {
    'navarasu/onedark.nvim',
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile', 'TextChanged', 'InsertEnter', },
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },
}
