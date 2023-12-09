local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.tortoisesvn(params)
  if not params or #params < 3 then
    return
  end
  local cmd, cmd1, cmd2, root, yes = unpack(params)
  if #params == 3 then
    cmd, root, yes = unpack(params)
  elseif #params == 4 then
    cmd1, cmd2, root, yes = unpack(params)
    cmd = cmd1 .. ' ' .. cmd2
  end
  if not cmd then
    return
  end
  local abspath = (root == 'root') and vim.fn['projectroot#get'](vim.api.nvim_buf_get_name(0)) or vim.api.nvim_buf_get_name(0)
  if yes == 'yes' or vim.tbl_contains({ 'y', 'Y', }, vim.fn.trim(vim.fn.input('Sure to update? [Y/n]: ', 'Y'))) == true then
    vim.fn.execute(string.format('silent !%s && start tortoiseproc.exe /command:%s /path:\"%s\"',
      B.system_cd(abspath),
      cmd, abspath))
  end
end

return M
