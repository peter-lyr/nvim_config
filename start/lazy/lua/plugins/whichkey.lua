return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    require 'which-key'.setup {}
    require 'which-key'.register { ['<leader>g'] = { name = 'Git prefix', }, }
  end,
}
