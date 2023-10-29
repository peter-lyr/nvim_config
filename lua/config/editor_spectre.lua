local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
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
