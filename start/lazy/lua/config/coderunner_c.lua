local M = {}

package.loaded['config.coderunner_c'] = nil

M.rebuild_en = nil

local c2cmake = require 'plenary.path':new(vim.g.pack_path):joinpath('nvim_config', 'start', 'lazy', 'lua', 'config')
local c2cmake_py = c2cmake:joinpath 'coderunner_c2cmake.py'.filename
local cbp2cmake_py = c2cmake:joinpath 'coderunner_cbp2cmake.py'.filename

local function rep(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '/', '\\')
  return content
end

local function system_cd(p)
  local s = ''
  if string.sub(p, 2, 2) == ':' then
    s = s .. string.sub(p, 1, 2) .. ' && '
  end
  if require 'plenary.path'.new(p):is_dir() then
    s = s .. 'cd ' .. p .. ' && '
  else
    s = s .. 'cd ' .. require 'plenary.path'.new(p):parent().filename .. ' && '
  end
  return s
end

local function system_run(way, str_format, ...)
  local cmd = string.format(str_format, ...)
  if way == 'start' then
    cmd = string.format([[silent !start cmd /c "%s & pause"]], cmd)
  elseif way == 'asyncrun' then
    cmd = string.format('AsyncRun %s', cmd)
  elseif way == 'term' then
    cmd = string.format('wincmd s|term %s', cmd)
  end
  vim.cmd(cmd)
end

M.get_cbps = function(abspath)
  local cbps = {}
  local path = require 'plenary.path':new(abspath)
  local entries = require 'plenary.scandir'.scan_dir(path.filename, { hidden = false, depth = 18, add_dirs = false, })
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

M.to_cmake = function()
  local project = rep(vim.call 'ProjectRootGet')
  if #project == 0 then
    local fname = vim.api.nvim_buf_get_name(0)
    print('not in a project:', fname)
    return
  end
  local cbps = M.get_cbps(project)
  if #cbps < 1 then
    vim.notify 'c2cmake...'
    system_run('start', 'chcp 65001 && %s python "%s" "%s"', system_cd(project), c2cmake_py, project)
  else
    vim.notify 'cbp2cmake...'
    system_run('start', 'chcp 65001 && %s python "%s" "%s"', system_cd(project), cbp2cmake_py, project)
  end
end

--------------------------
-- to_make
--------------------------

M.get_workspaces = function(abspath)
  local workspaces = {}
  local path = require 'plenary.path':new(abspath)
  local entries = require 'plenary.scandir'.scan_dir(path.filename, { hidden = false, depth = 8, add_dirs = false, })
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
  local make = 'mingw32-make --no-print-directory all'
  if M.rebuild_en then
    make = make .. ' -B -j20'
  end
  local cmd = string.format([[chcp 65001 && %s cbp2make --wrap-objects --keep-outdir -in "%s" -out Makefile & %s]], system_cd(project), workspace, make)
  if M.rebuild_en then
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
  if M.rebuild_en then
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
    M.to_cmake()
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
