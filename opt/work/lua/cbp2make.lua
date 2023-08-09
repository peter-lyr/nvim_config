local M = {}

package.loaded['cbp2make'] = nil

local cbp2make = require("plenary.path"):new(vim.g.pack_path):joinpath('nvim_config', 'opt', 'work', 'autoload', 'cbp2make')
vim.g.cbp2make_main_py = cbp2make:joinpath('cbp2make.py').filename
vim.g.cbp2make_cfg = cbp2make:joinpath('cbp2make.cfg').filename


local cbp2make_timer = -1

M.build = function()
  local fname = vim.api.nvim_buf_get_name(0)
  local project = string.gsub(vim.fn.tolower(vim.call('ProjectRootGet')), '\\', '/')
  if #project == 0 then
    print('no projectroot:', fname)
    return
  end
  local cmd = string.format([[chcp 65001 && python "%s" "%s"]], vim.g.cbp2make_main_py, project)
  require('terminal').send('cmd', cmd, 'show')
  -- vim.cmd(string.format([[silent !start cmd /c "%s & pause"]], cmd))
  if vim.g.builtin_terminal_ok == 1 then
    pcall(vim.fn.timer_stop, cbp2make_timer)
    local bufnr = -1
    vim.fn.timer_start(30, function()
      vim.api.nvim_win_set_height(0, 12)
      vim.cmd('norm G')
      vim.cmd('wincmd p')
      vim.fn.timer_start(30, function()
        bufnr = vim.fn.bufnr()
        vim.keymap.set('n', 'q', function()
          require('terminal').hideall()
        end, { desc = 'terminal hideall', nowait = true, buffer = bufnr })
      end)
    end)
    cbp2make_timer = vim.fn.timer_start(5000, function()
      if vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'buftype') ~= 'terminal' then
        require('terminal').hideall()
      end
      pcall(vim.keymap.del, 'n', 'q', { buffer = bufnr })
    end)
  end
end

return M
