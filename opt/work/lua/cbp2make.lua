local M = {}

package.loaded['cbp2make'] = nil

local Path = require("plenary.path")
local Scan = require("plenary.scandir")

local cbp2make = require("plenary.path"):new(vim.g.pack_path):joinpath('nvim_config', 'opt', 'work', 'autoload',
  'cbp2make')
vim.g.cbp2make_cfg = cbp2make:joinpath('cbp2make.cfg').filename

local cbp2make_timer = -1

local function systemcd(path)
  local s = ''
  if string.sub(path, 2, 2) == ':' then
    s = s .. string.sub(path, 1, 2) .. ' && '
  end
  if require('plenary.path').new(path):is_dir() then
    s = s .. 'cd ' .. path
  else
    s = s .. 'cd ' .. require('plenary.path').new(path):parent().filename
  end
  return s
end

local rep = function(path)
  path, _ = string.gsub(path, '\\', '/')
  return path
end

M.get_workspaces = function(abspath)
  local workspaces = {}
  local path = Path:new(abspath)
  local entries = Scan.scan_dir(path.filename, { hidden = false, depth = 8, add_dirs = false })
  for _, entry in ipairs(entries) do
    local entry_path_name = rep(entry)
    if string.match(entry_path_name, '%.([^%.]+)$') == 'workspace' then
      if vim.tbl_contains(workspaces, entry_path_name) == false then
        table.insert(workspaces, entry_path_name)
      end
    end
  end
  return workspaces
end

M.build_do = function(project, workspace)
  local cmd = string.format([[chcp 65001 && %s && cbp2make -cfg "%s" -in "%s" -out Makefile && mingw32-make]],
    systemcd(project), vim.g.cbp2make_cfg, workspace)
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

M.build = function(workspace)
  local project = string.gsub(vim.fn.tolower(vim.call('ProjectRootGet')), '\\', '/')
  if #project == 0 then
    print('no projectroot:', vim.api.nvim_buf_get_name(0))
    return
  end

  if workspace then
    if type(workspace) == 'string' then
      vim.notify('Building...')
      M.build_do(project, workspace)
    elseif type(workspace) == 'table' then
      local workspaces = workspace
      if #workspaces == 1 then
        vim.notify('Building...')
        M.build_do(project, workspace)
        return
      end
      vim.ui.select(workspaces, { prompt = 'select one of them' }, function(_, idx)
        workspace = workspaces[idx]
        vim.notify('Building...')
        M.build_do(project, workspace)
      end)
    end
    return
  end

  local workspaces = M.get_workspaces(project)
  workspace = workspaces[1]
  if #workspaces == 0 then
    vim.notify('No workspace file found in ' .. project .. '.')
    vim.notify('Preparing...')
    require('cbp2cmake').build()
    return
  elseif #workspaces > 1 then
    vim.ui.select(workspaces, { prompt = 'select one of them' }, function(_, idx)
      workspace = workspaces[idx]
      vim.notify('Building...')
      M.build_do(project, workspace)
    end)
    return
  else
    vim.notify('Building...')
    M.build_do(project, workspace)
  end
end

return M
