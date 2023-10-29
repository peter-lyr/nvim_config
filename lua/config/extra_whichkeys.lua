local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
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

return M
