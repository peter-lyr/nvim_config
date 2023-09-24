local minimap = require 'mini.map'

minimap.setup {
  integrations = {
    minimap.gen_integration.builtin_search(),
    minimap.gen_integration.gitsigns(),
    minimap.gen_integration.diagnostic(),
  },
  symbols = {
    encode = minimap.gen_encode_symbols.dot('4x2'),
    scroll_line = '█',
    scroll_view = '│',
  },
  window = {
    focusable = true,
    side = 'right',
    show_integration_count = true,
    width = 12,
    winblend = 25,
  },
}
