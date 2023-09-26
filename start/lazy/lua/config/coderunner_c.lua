local M = {}

package.loaded['config.coderunner_c'] = nil

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

return M
