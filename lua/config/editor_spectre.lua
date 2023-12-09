local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.open()
  require 'spectre'.open()
end

function M.open_visual_select_word()
  require 'spectre'.open_visual { select_word = true, }
end

function M.open_visual()
  require 'spectre'.open_visual()
end

function M.open_file_search()
  require 'spectre'.open_file_search { select_word = true, }
end

require 'spectre'.setup()

return M
