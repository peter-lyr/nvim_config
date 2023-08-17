local M = {}

package.loaded['_2cmake'] = nil

local cbp2cmake = require("plenary.path"):new(vim.g.pack_path):joinpath('nvim_config', 'opt', 'work', 'autoload', '_2cmake')
vim.g._2cmake_main_py = cbp2cmake:joinpath('_2cmake.py').filename

M.build = function()
  local fname = vim.api.nvim_buf_get_name(0)
  local project = string.gsub(vim.fn.tolower(vim.call('ProjectRootGet')), '\\', '/')
  if #project == 0 then
    print('no projectroot:', fname)
    return
  end
  local cmd = string.format([[chcp 936 && python "%s" "%s"]], vim.g._2cmake_main_py, project)
  vim.cmd(string.format([[silent !start cmd /c "%s & pause"]], cmd))
end

return M
