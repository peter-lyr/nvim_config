local S = require 'my_simple'

local plugin = 'tpope/vim-fugitive'
local config = 'fugitive'

vim.keymap.set({ 'n', 'v', }, '<leader><leader>', function()
  print '00000'
end, { silent = true, desc = '9999', })

return {
  plugin,
  lazy = true,
  cmd = {
    'Git',
  },
  keys = {
    S.gkey('<leader>a', plugin, config),
  },
  config = function()
    S.load_require(plugin, config)
  end,
}
