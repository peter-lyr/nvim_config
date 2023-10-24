local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

M.width = 25

local minimap = require 'mini.map'

local symbols = minimap.gen_encode_symbols.dot '4x2'
symbols[1] = ' '

minimap.setup {
  integrations = {
    minimap.gen_integration.builtin_search(),
    minimap.gen_integration.gitsigns(),
    minimap.gen_integration.diagnostic(),
  },
  symbols = {
    encode = symbols,
    -- scroll_line = '█',
    -- scroll_view = '░',
    -- scroll_line = '󰨊',
    -- scroll_view = '│',
    scroll_line = '█',
    scroll_view = '┃',
  },
  window = {
    focusable = true,
    side = 'right',
    show_integration_count = true,
    width = M.width,
    winblend = 20,
  },
}

M.open = function()
  minimap.open()
  M.auto_open_en = 1
  M.opened = 1
end

M.close = function()
  minimap.close()
  M.auto_open_en = nil
  M.opened = nil
end

M.auto_open = function()
  M.auto_open_en = 1
end

M.toggle_focus = function()
  minimap.toggle_focus()
end

print(M.source)

return M
