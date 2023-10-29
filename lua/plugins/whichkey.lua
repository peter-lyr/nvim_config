local S = require 'startup'

local plugin = 'folke/which-key.nvim'
local map = 'Whichkey'

return {
  plugin,
  lazy = true,
  init = function()
    vim.o.timeoutlen = 300
    if not S.load_whichkeys_txt_enable then
      require 'my_simple'.add_whichkey('<leader>', plugin, map)
    end
  end,
}
