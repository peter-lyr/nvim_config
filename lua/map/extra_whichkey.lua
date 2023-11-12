local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

require 'which-key'.setup {
  window = {
    border = 'single',
    winblend = 12,
  },
  layout = {
    height = { min = 4, max = 80, },
    width = { min = 20, max = 200, },
  },
}

vim.keymap.set({ 'n', 'v', }, '<a-w>', '<cmd>WhichKey<cr>', { silent = true, desc = 'WhichKey', })

return M
