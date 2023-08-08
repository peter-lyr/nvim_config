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
  require('terminal').send('cmd', 'python ' .. vim.g.cbp2cmake_main_py .. ' ' .. project, 'show')
end

return M
