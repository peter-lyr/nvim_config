local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

require 'marks'.setup {
  default_mappings = false,
  builtin_marks = { '.', '<', '>', '^', },
  cyclic = false,
  force_write_shada = false,
  refresh_interval = 250,
  sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20, },
  excluded_filetypes = {
    'NvimTree',
    'fugitive',
    'help',
  },
  mappings = {
    toggle = 'mm',
    set_next = 'mn',
    delete_line = 'md',
    delete_buf = 'mx',
    next = 'ms',
    prev = 'mw',
    annotate = 'ma',
  },
}

return M
