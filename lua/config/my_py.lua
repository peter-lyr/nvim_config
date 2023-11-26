local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.run(runway)
  if not runway then
    runway = 'asyncrun'
  end
  local pause = ''
  if runway == 'start' then
    pause = '& pause'
  end
  local cur_file = vim.api.nvim_buf_get_name(0)
  local fname = B.get_only_name(cur_file)
  B.system_run(runway, [[%s && python %s %s]], B.system_cd(cur_file), fname, pause)
end

function M.toexe(runway)
  if not runway then
    runway = 'asyncrun'
  end
  local pause = ''
  if runway == 'start' then
    pause = '& pause'
  end
  local cur_file = vim.api.nvim_buf_get_name(0)
  local fname = B.get_only_name(cur_file)
  local f = io.popen 'which pyinstaller'
  if f then
    if B.is(f:read '*a') then
      B.system_run(runway, [[%s && pyinstaller -F %s]], B.system_cd(cur_file), fname)
    else
      B.system_run(runway, [[pip install pyinstaller -i http://pypi.douban.com/simple --trusted-host pypi.douban.com && %s && pyinstaller -F %s %s]], B.system_cd(cur_file), fname, pause)
    end
    f:close()
  end
end

return M
