local M = {}

package.loaded['c2cmake'] = nil

local Path = require 'plenary.path'
local Scan = require 'plenary.scandir'

local c2cmake = Path:new(vim.g.pack_path):joinpath('nvim_config', 'opt', 'work', 'autoload', 'c2cmake')
local c2cmake_py = c2cmake:joinpath 'c2cmake.py'.filename
local cbp2cmake_py = c2cmake:joinpath 'cbp2cmake.py'.filename

local rep = function(path)
  path, _ = string.gsub(path, '\\', '/')
  return path
end

local get_cbps = function(abspath)
  local cbps = {}
  local path = Path:new(abspath)
  local entries = Scan.scan_dir(path.filename, { hidden = false, depth = 8, add_dirs = false, })
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

local function systemcd(p)
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

M.c2cmake = function()
  local fname = vim.api.nvim_buf_get_name(0)
  local project = string.gsub(vim.fn.tolower(vim.call 'ProjectRootGet'), '\\', '/')
  if #project == 0 then
    print('not in a project:', fname)
    return
  end
  local cbps = get_cbps(project)
  if #cbps < 1 then
    vim.notify 'c2cmake'
    local cmd = string.format([[chcp 936 && %s python "%s" "%s"]], systemcd(project), c2cmake_py, project)
    vim.cmd(string.format([[silent !start cmd /c "%s & pause"]], cmd))
  else
    vim.notify 'cbp2cmake'
    local cmd = string.format([[chcp 936 && %s python "%s" "%s"]], systemcd(project), cbp2cmake_py, project)
    vim.cmd(string.format([[silent !start cmd /c "%s & pause"]], cmd))
  end
end

return M
