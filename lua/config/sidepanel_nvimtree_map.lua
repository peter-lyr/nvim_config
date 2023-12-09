local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.basic_map(bufnr)
  require 'config.sidepanel_nvimtree_map_basic'.basic_map(bufnr)
end

function M.sel_map(bufnr)
  require 'config.sidepanel_nvimtree_map_sel'.sel_map(bufnr)
end

return M
