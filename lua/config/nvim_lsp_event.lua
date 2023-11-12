local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.c()
  require 'config.nvim_lsp_event_c'
end

function M.lua()
  require 'config.nvim_lsp_event_lua'
end

function M.markdown()
  require 'config.nvim_lsp_event_markdown'
end

function M.python()
  require 'config.nvim_lsp_event_python'
end

return M
