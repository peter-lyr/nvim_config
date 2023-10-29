local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

function M.get_loaded_valid_bufs()
  local files = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if B.is_buf_loaded_valid(buf) then
      local fname = vim.api.nvim_buf_get_name(buf)
      if #fname > 0 and B.file_exists(fname) then
        files[#files + 1] = fname
      end
    end
  end
  return files
end

return M
