local M = {}

package.loaded['cbp2cmake'] = nil

vim.g.cbp2cmake_main_py = require("plenary.path"):new(vim.g.pack_path):joinpath('nvim_config', 'opt', 'work',
  'autoload', 'cbp2cmake'):joinpath('main.py')['filename']

M.build = function()
  local fname = vim.api.nvim_buf_get_name(0)
  local project = string.gsub(vim.fn.tolower(vim.call('ProjectRootGet')), '\\', '/')
  if #project == 0 then
    print('no projectroot:', fname)
    return
  end
  local cmd = string.format([[chcp 65001 && python "%s" "%s"]], vim.g.cbp2cmake_main_py,  project)
  require('terminal').send('cmd', cmd, 'show')
  -- vim.cmd(string.format([[silent !start cmd /c "%s & pause"]], cmd))
  vim.fn.timer_start(30, function()
    vim.api.nvim_win_set_height(0, 12)
    vim.cmd('norm G')
    vim.cmd('wincmd p')
  end)
  vim.fn.timer_start(5000, function()
    require('terminal').hideall()
  end)
end

return M
