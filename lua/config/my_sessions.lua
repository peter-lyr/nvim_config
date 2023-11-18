local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

M.sessions_dir_path = B.get_create_std_data_dir 'sessions'
M.sessions_txt_path = B.get_create_file_path(M.sessions_dir_path, 'sessions.txt')

require 'config.telescope_ui_sel'

M.sel_all = 'open all above'

function M.open_all(projs)
  for _, files in pairs(projs) do
    for _, file in ipairs(files) do
      vim.cmd('edit ' .. file)
    end
  end
  vim.cmd 'e!'
  vim.cmd 'ProjectRootCD'
end

function M.get_projs(fname)
  if not fname then
    return loadstring('return ' .. M.sessions_txt_path:read())()
  end
  return loadstring('return ' .. B.get_create_file_path(M.sessions_dir_path, fname):read())()
end

function M.edit(files)
  if type(files) == 'string' then
    files = { files, }
  end
  for _, file in ipairs(files) do
    vim.cmd('edit ' .. file)
  end
  vim.cmd 'e!'
  vim.cmd 'ProjectRootCD'
end

function M.sel(fname)
  local projs = M.get_projs(fname)
  local list = {}
  local names = {}
  for proj, files in pairs(projs) do
    local only_names = {}
    for _, name in ipairs(files) do
      names[#names + 1] = name
      only_names[#only_names + 1] = B.get_only_name(name)
    end
    list[#list + 1] = string.format('%2d files   "%s"   %s', #files, proj, vim.fn.join(only_names, ' '))
  end
  if #list > 0 then
    if #names == 1 then
      M.edit(names)
    else
      table.insert(list, 1, M.sel_all)
      B.ui_sel(list, 'sessions sel proj open', function(proj, _)
        if proj == M.sel_all then
          M.open_all(projs)
          return
        end
        proj = string.match(proj, '%d+ files   "(.*)"')
        if proj then
          local files = projs[proj]
          if #files == 1 then
            M.edit(files)
          else
            table.insert(files, 1, M.sel_all)
            B.ui_sel(files, 'sessions sel file open', function(file, _)
              if file == M.sel_all then
                M.edit(files)
              else
                M.edit(file)
              end
            end)
          end
        end
      end)
    end
  end
end

M.format = 'sessions_%d_%dProjs_%dFiles %s.txt'
M.pattern = 'sessions_(%d+)_(%d+)Projs_(%d+)Files (.*)%.txt'

function M.save()
  local files, cnt = B.get_loaded_valid_bufs()
  if #vim.tbl_keys(files) > 0 then
    M.sessions_txt_path:write(vim.inspect(files), 'w')
    local projs = {}
    local _cnt = 1
    for proj, _ in pairs(files) do
      projs[#projs + 1] = string.format('%d %s', _cnt, string.gsub(B.get_only_name(proj), '[\\/:%*%?"<>|]', '_'))
      _cnt = _cnt + 1
    end
    local file = string.format(M.format, os.time(), #vim.tbl_keys(files), cnt, vim.fn.join(projs, ' '))
    local last_sessions_txt_path = B.get_create_file_path(M.sessions_dir_path, file)
    last_sessions_txt_path:write(vim.inspect(files), 'w')
  end
end

function M.sel_recent()
  local files = B.scan_files(M.sessions_dir_path, M.pattern)
  local new_files = {}
  table.sort(files)
  for i = #files, 1, -1 do
    local file = files[i]
    for timestamp, projs_cnt, files_cnt, projs in string.gmatch(file, M.pattern) do
      new_files[#new_files + 1] = string.format('%14s  %d  Projs  %d Files.  |  %s', B.time_diff(tonumber(timestamp, 10)), projs_cnt, files_cnt, projs)
    end
  end
  B.ui_sel(new_files, 'which sessions to open', function(_, idx)
    M.sel(files[#files - idx + 1])
  end)
end

M.opened_projs_dir_path = B.get_create_std_data_dir 'opened_projs'
M.opened_projs_txt_path = B.get_create_file_path(M.opened_projs_dir_path, 'opened_projs.txt')

function M.init_opened_projs()
  local cwd = B.rep_slash_lower(vim.loop.cwd())
  M.opened_projs = { cwd, }
  M.opened_projs_txt_path:write(vim.inspect(M.opened_projs), 'w')
  B.cmd('cd %s', cwd)
end

if not M.opened_projs_loaded then
  M.init_opened_projs()
end

M.opened_projs_loaded = 1

function M.add_opened_projs()
  local cwd = B.rep_slash_lower(vim.loop.cwd())
  if vim.tbl_contains(M.opened_projs, cwd) == false then
    M.opened_projs[#M.opened_projs + 1] = cwd
    local func = loadstring('return ' .. M.opened_projs_txt_path:read())
    if func then
      local projs = func()
      if projs then
        for _, proj in ipairs(projs) do
          proj = B.rep_slash_lower(proj)
          if vim.tbl_contains(M.opened_projs, proj) == false then
            M.opened_projs[#M.opened_projs + 1] = proj
          end
        end
      end
      M.opened_projs_txt_path:write(vim.inspect(M.opened_projs), 'w')
      B.notify_info(cwd)
    end
  end
end

require 'map.sidepanel_nvimtree'
require 'config.sidepanel_nvimtree'

function M.cd_opened_projs()
  local func = loadstring('return ' .. M.opened_projs_txt_path:read())
  if func then
    local projs = func()
    B.ui_sel(projs, 'sel dir to change', function(dir)
      if dir then
        pcall(vim.cmd, 'NvimTreeOpen')
        B.cmd('cd %s', dir)
      end
    end)
  end
end

M.depei = vim.fn.expand [[$HOME]] .. '\\DEPEI'

if vim.fn.isdirectory(M.depei) == 0 then
  vim.fn.mkdir(M.depei)
end

M.my_dirs = {
  B.rep_baskslash_lower(M.depei),
  B.rep_baskslash_lower(vim.fn.expand [[$HOME]]),
  B.rep_baskslash_lower(vim.fn.expand [[$TEMP]]),
  B.rep_baskslash_lower(vim.fn.expand [[$LOCALAPPDATA]]),
  B.rep_baskslash_lower(vim.fn.expand [[$VIMRUNTIME]]),
}

for i = 1, 26 do
  local dir = vim.fn.nr2char(64 + i) .. [[:\]]
  dir = B.rep_baskslash_lower(vim.fn.trim(dir, '/'))
  if vim.fn.isdirectory(dir) == 1 and vim.tbl_contains(M.my_dirs, dir) == false then
    M.my_dirs[#M.my_dirs + 1] = dir
  end
end

function M.cd_my_dirs()
  B.ui_sel(M.my_dirs, 'sel dir to change', function(dir)
    if dir then
      pcall(vim.cmd, 'NvimTreeOpen')
      B.cmd('cd %s', dir)
    end
  end)
end

M.git_repos_dir_path = B.get_create_std_data_dir 'git_repos'
M.git_repos_txt_path = B.get_create_file_path(M.git_repos_dir_path, 'git_repos.txt')
M.update_git_repos_py_path = M.source .. '.update_git_repos.py'

function M.cd_git_repos()
  local git_repos = {}
  local lines = M.git_repos_txt_path:readlines()
  for _, line in ipairs(lines) do
    local dir_path = require 'plenary.path':new(vim.fn.trim(line))
    if dir_path:exists() == true then
      git_repos[#git_repos + 1] = dir_path.filename
    end
  end
  if #git_repos == 0 then
    M.update_git_repos()
    return
  end
  B.ui_sel(git_repos, 'sel dir to change', function(choice, _)
    if not choice then
      return
    end
    local dir_path = require 'plenary.path':new(vim.fn.trim(choice))
    if dir_path:exists() == true then
      vim.cmd 'NvimTreeOpen'
      vim.cmd('cd ' .. choice)
    end
  end)
end

function M.update_git_repos()
  B.system_run('start', '%s && python "%s" "%s"',
    B.system_cd(M.git_repos_dir_path), M.update_git_repos_py_path, M.git_repos_txt_path.filename)
end

return M
