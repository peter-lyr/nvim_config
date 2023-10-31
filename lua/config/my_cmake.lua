local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

M.c2cmake_py = M.source .. '.c2cmake.py'
M.cbp2cmake_py = M.source .. '.cbp2cmake.py'

function M.get_cbps(file)
  local cbps = {}
  local path = require 'plenary.path':new(file)
  local entries = require 'plenary.scandir'.scan_dir(path.filename, { hidden = false, depth = 18, add_dirs = false, })
  for _, entry in ipairs(entries) do
    local entry_path_name = B.rep_slash_lower(entry)
    if string.match(entry_path_name, '%.([^%.]+)$') == 'cbp' then
      if vim.tbl_contains(cbps, entry_path_name) == false then
        table.insert(cbps, entry_path_name)
      end
    end
  end
  return cbps
end

function M.to_cmake()
  local proj = B.rep_slash_lower(vim.call 'ProjectRootGet')
  if #proj == 0 then
    local fname = vim.api.nvim_buf_get_name(0)
    B.notify_info('not in a project: ' .. fname)
    return
  end
  local cbps = M.get_cbps(proj)
  if #cbps < 1 then
    B.notify_info 'c2cmake...'
    B.system_run('start', 'chcp 65001 && %s && python "%s" "%s"', B.system_cd(proj), M.c2cmake_py, proj)
  else
    B.notify_info 'cbp2cmake...'
    B.system_run('start', 'chcp 65001 && %s && python "%s" "%s"', B.system_cd(proj), M.cbp2cmake_py, proj)
  end
end

return M
