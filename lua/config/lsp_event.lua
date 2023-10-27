local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

function M.c()
  require(M.loaded .. '_' .. 'c')
end

function M.lua()
  require(M.loaded .. '_' .. 'lua')
end

function M.markdown()
  require(M.loaded .. '_' .. 'markdown')
end

function M.python()
  require(M.loaded .. '_' .. 'python')
end

return M
