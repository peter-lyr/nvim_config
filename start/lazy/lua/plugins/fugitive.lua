local S = require 'my_simple'

local plugin = 'tpope/vim-fugitive'
local map = 'fugitive'

vim.keymap.set({ 'n', 'v', }, '<leader><leader>', function()
  print '00000'
end, { silent = true, desc = '9999', })

return {
  plugin,
  lazy = true,
  -- cmd = {
  --   'Git',
  -- },
  -- config = function()
  --   S.load_require(plugin, map)
  -- end,
  init = function()
    S.wkey('<leader>', plugin, map)
  end
}
