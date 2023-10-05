local M = {}

package.loaded['all_git_repos'] = nil

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

M.all_git_repos_dir_p = require 'plenary.path':new(vim.fn.stdpath 'data'):joinpath 'all_git_repos'
M.all_git_repos_txt_p = M.all_git_repos_dir_p:joinpath 'all_git_repos.txt'
M.all_git_repos_py_p = require 'plenary.path':new(vim.g.pack_path):joinpath('nvim_config', 'opt', 'maps', 'lua', 'all_git_repos.py')

if not M.all_git_repos_dir_p:exists() then
  vim.fn.mkdir(M.all_git_repos_dir_p.filename)
end

if not M.all_git_repos_txt_p:exists() then
  M.all_git_repos_txt_p:write('', 'w')
end

pcall(vim.cmd, 'Lazy load telescope-ui-select.nvim')

M.update_all_git_repos = function()
  system_run('start', 'chcp 65001 && %s python "%s" "%s"', system_cd(M.all_git_repos_dir_p.filename), M.all_git_repos_py_p.filename, M.all_git_repos_txt_p.filename)
end

M.sel = function()
  local git_repos = {}
  local lines = M.all_git_repos_txt_p:readlines()
  for _, line in ipairs(lines) do
    local dir_p = require 'plenary.path':new(vim.fn.trim(line))
    if dir_p:exists() == true then
      git_repos[#git_repos + 1] = dir_p.filename
    end
  end
  vim.ui.select(git_repos, { prompt = 'nvimtree open git repo', }, function(choice, idx)
    if not choice then
      return
    end
    local dir_p = require 'plenary.path':new(vim.fn.trim(choice))
    if dir_p:exists() == true then
      vim.cmd 'NvimTreeOpen'
      vim.cmd('cd ' .. choice)
    end
  end)
end

vim.api.nvim_create_user_command('UpdateAllGitRepos', M.update_all_git_repos, {})

return M
