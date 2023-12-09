local S = require 'startup'

return {
  {
    'rcarriga/nvim-notify',
    lazy = true,
    keys = {
      { '<esc>', function() require 'notify'.dismiss() end, mode = { 'n', }, silent = true, desc = 'dismiss notification', },
    },
    config = function()
      require 'map.extra_notify'
    end,
  },
  {
    'folke/which-key.nvim',
    lazy = true,
    init = function()
      vim.o.timeoutlen = 300
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>', 'folke/which-key.nvim', 'Extra_Whichkey')
      end
    end,
    config = function()
      require 'map.extra_whichkey'
    end,
  },
}
