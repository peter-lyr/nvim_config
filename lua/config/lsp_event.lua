local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

function M.c()
  require 'config.lsp_event_c'
end

function M.lua()
  require 'config.lsp_event_lua'
end

function M.markdown()
  require 'config.lsp_event_markdown'
end

function M.python()
  require 'config.lsp_event_python'
end

return M
