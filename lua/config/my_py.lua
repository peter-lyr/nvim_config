local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.run(way)
  if not way then
    way = 'asyncrun'
  end
  local cur_file = vim.api.nvim_buf_get_name(0)
  local fname = B.get_only_name(cur_file)
  B.system_run(way, [[%s && python %s]], B.system_cd(cur_file), fname)
end

return M
