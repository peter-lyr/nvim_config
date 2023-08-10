local M = {}

package.loaded['cbp2cmake'] = nil

local Path = require("plenary.path")
local Scan = require("plenary.scandir")

local cbp2cmake = require("plenary.path"):new(vim.g.pack_path):joinpath('nvim_config', 'opt', 'work', 'autoload', 'cbp2cmake')
vim.g.cbp2cmake_main_py = cbp2cmake:joinpath('cbp2cmake.py').filename

local cbp2cmake_timer = -1

local rep = function(path)
  path, _ = string.gsub(path, '\\', '/')
  return path
end

local get_cbps = function(abspath)
  local cbps = {}
  local path = Path:new(abspath)
  local entries = Scan.scan_dir(path.filename, { hidden = false, depth = 8, add_dirs = false })
  for _, entry in ipairs(entries) do
    local entry_path_name = rep(entry)
    if string.match(entry_path_name, '%.([^%.]+)$') == 'cbp' then
      if vim.tbl_contains(cbps, entry_path_name) == false then
        table.insert(cbps, entry_path_name)
      end
    end
  end
  return cbps
end

M.build = function()
  local fname = vim.api.nvim_buf_get_name(0)
  local project = string.gsub(vim.fn.tolower(vim.call('ProjectRootGet')), '\\', '/')
  if #project == 0 then
    print('no projectroot:', fname)
    return
  end
  local cbps = get_cbps(project)
  if #cbps < 1 then
    vim.notify('No cbp file found in ' .. project .. '.')
    return
  end
  local cmd = string.format([[chcp 65001 && python "%s" "%s"]], vim.g.cbp2cmake_main_py, project)
  require('terminal').send('cmd', cmd, 'show')
  -- vim.cmd(string.format([[silent !start cmd /c "%s & pause"]], cmd))
  if vim.g.builtin_terminal_ok == 1 then
    pcall(vim.fn.timer_stop, cbp2cmake_timer)
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
    cbp2cmake_timer = vim.fn.timer_start(5000, function()
      if vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'buftype') ~= 'terminal' then
        require('terminal').hideall()
      end
      pcall(vim.keymap.del, 'n', 'q', { buffer = bufnr })
    end)
  end
end

return M
