local M = {}

package.loaded['cbp2make'] = nil

local Path = require "plenary.path"
local Scan = require "plenary.scandir"

local function systemcd(path)
  local s = ''
  if string.sub(path, 2, 2) == ':' then
    s = s .. string.sub(path, 1, 2) .. ' && '
  end
  if require 'plenary.path'.new(path):is_dir() then
    s = s .. 'cd ' .. path
  else
    s = s .. 'cd ' .. require 'plenary.path'.new(path):parent().filename
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
  local entries = Scan.scan_dir(path.filename, { hidden = false, depth = 8, add_dirs = false, })
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

Cbp2makeBuildDone = function()
  require 'notify'.dismiss()
  vim.notify 'Done!'
  vim.cmd 'au! User AsyncRunStop'
end

M.build_do = function(project, workspace)
  vim.cmd [[au User AsyncRunStop call v:lua.Cbp2makeBuildDone()]]
  local make = 'mingw32-make all'
  local rebuild_en = require 'config.coderunner'.rebuild_en
  if rebuild_en then
    make = make .. ' -B -j20'
  end
  local cmd = string.format(
    [[chcp 65001 && %s && cbp2make --wrap-objects --keep-outdir -in "%s" -out Makefile & %s]],
    systemcd(project), workspace, make)
  if rebuild_en then
    cmd = string.gsub(cmd, '"', '\\"')
    vim.fn.system(string.format([[start cmd /c "%s & pause"]], cmd))
  else
    vim.cmd('AsyncRun ' .. cmd)
    local winid = vim.fn.win_getid()
    vim.cmd 'copen'
    vim.cmd 'wincmd J'
    if vim.api.nvim_win_get_height(0) < 15 then
      vim.api.nvim_win_set_height(0, 15)
    end
    vim.cmd 'norm Gzb'
    vim.fn.win_gotoid(winid)
  end
end

local notify_building = function()
  if require 'config.coderunner'.rebuild_en then
    vim.notify 'Re Building...'
  else
    vim.notify 'Building...'
  end
end

M.build = function(workspace)
  local project = string.gsub(vim.fn.tolower(vim.call 'ProjectRootGet'), '\\', '/')
  if #project == 0 then
    print('no projectroot:', vim.api.nvim_buf_get_name(0))
    return
  end

  if workspace then
    if type(workspace) == 'string' then
      notify_building()
      M.build_do(project, workspace)
    elseif type(workspace) == 'table' then
      local workspaces = workspace
      if #workspaces == 1 then
        notify_building()
        M.build_do(project, workspaces[1])
        return
      end
      vim.ui.select(workspaces, { prompt = 'select one of them', }, function(_, idx)
        workspace = workspaces[idx]
        notify_building()
        M.build_do(project, workspace)
      end)
    end
    return
  end

  local workspaces = M.get_workspaces(project)
  workspace = workspaces[1]
  if #workspaces == 0 then
    vim.notify('No workspace file found in ' .. project .. '.')
    vim.notify 'Preparing...'
    require 'c2cmake'.c2cmake()
    return
  elseif #workspaces > 1 then
    vim.ui.select(workspaces, { prompt = 'select one of them', }, function(_, idx)
      workspace = workspaces[idx]
      notify_building()
      M.build_do(project, workspace)
    end)
    return
  else
    notify_building()
    M.build_do(project, workspace)
  end
end

return M
