local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

M.c2cmake_py = M.source .. '.c2cmake.py'
M.cbp2cmake_py = M.source .. '.cbp2cmake.py'
M._clang_format = M.source .. '_\\.clang-format'

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

function M.to_cmake_do(proj)
  local fname = B.rep_backslash_lower(vim.api.nvim_buf_get_name(0))
  proj = B.rep_backslash_lower(proj)
  if #proj == 0 then
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
  B.system_run('start silent', 'copy /y "%s" "%s"', B.rep_slash(M._clang_format), B.rep_slash(require 'plenary.path':new(proj):joinpath('.clang-format').filename))
end

function M.cmake(cwd)
  if #vim.call 'ProjectRootGet' == 0 then
    B.notify_info 'not in a git repo'
    return
  end
  if cwd then
    M.to_cmake_do(B.rep_slash_lower(vim.call 'ProjectRootGet'))
  else
    B.ui_sel(B.get_file_dirs_till_git(), 'which dir to cmake', function(proj)
      M.to_cmake_do(proj)
    end)
  end
end

return M
