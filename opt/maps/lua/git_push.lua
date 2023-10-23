local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
package.loaded[B.get_loaded(M.source)] = nil
--------------------------------------------

M.addcommitpush = function(info)
  pcall(vim.call, 'ProjectRootCD')
  local result = vim.fn.systemlist { 'git', 'status', '-s', }
  if #result > 0 then
    B.notify_info { 'git status -s', vim.loop.cwd(), table.concat(result, '\n'), }
    if not info then
      info = vim.fn.input 'commit info (Add all and push): '
    end
    if #info > 0 then
      B.set_timeout(10, function()
        B.system_run('asyncrun', 'git add -A && git status && git commit -m "%s" && git push', info)
      end)
    end
  else
    vim.notify 'no changes'
  end
end

M.commit_push = function(info)
  pcall(vim.call, 'ProjectRootCD')
  local result = vim.fn.systemlist { 'git', 'diff', '--staged', '--stat', }
  if #result > 0 then
    B.notify_info { 'git diff --staged --stat', vim.loop.cwd(), table.concat(result, '\n'), }
    if not info then
      info = vim.fn.input 'commit info (commit and push): '
    end
    if #info > 0 then
      B.set_timeout(10, function()
        B.system_run('asyncrun', 'git commit -m "%s" && git push', info)
      end)
    end
  else
    vim.notify 'no staged'
  end
end

M.commit = function(info)
  pcall(vim.call, 'ProjectRootCD')
  local result = vim.fn.systemlist { 'git', 'diff', '--staged', '--stat', }
  if #result > 0 then
    B.notify_info { 'git diff --staged --stat', vim.loop.cwd(), table.concat(result, '\n'), }
    if not info then
      info = vim.fn.input 'commit info (just commit): '
    end
    if #info > 0 then
      B.set_timeout(10, function()
        B.system_run('asyncrun', 'git commit -m "%s"', info)
      end)
    end
  else
    vim.notify 'no staged'
  end
end

M.graph = function()
  B.system_run('asyncrun', 'git log --all --graph --decorate --oneline && pause')
end

M.push = function()
  pcall(vim.call, 'ProjectRootCD')
  local result = vim.fn.systemlist { 'git', 'cherry', '-v', }
  if #result > 0 then
    B.notify_info { 'git cherry -v', vim.loop.cwd(), table.concat(result, '\n'), }
    B.set_timeout(10, function()
      B.system_run('asyncrun', 'git push')
    end)
  else
    vim.notify 'cherry empty'
  end
end

function M.init_do(git_root_dir)
  local remote_name = B.get_fname_tail(git_root_dir)
  if remote_name == '' then
    return
  end
  remote_name = '.git-' .. remote_name
  local remote_dir_path = B.get_dir_path { git_root_dir, remote_name, }
  if remote_dir_path:exists() then
    B.notify_info('remote path already existed: ' .. remote_dir_path.filename)
    return
  end
  local file_path = B.get_file_path(git_root_dir, '.gitignore')
  if file_path:exists() then
    local lines = file_path:read()
    if vim.tbl_contains(lines, remote_name) == false then
      file_path:write(remote_name, 'a')
    end
  else
    file_path:write(remote_name, 'w')
  end
  B.asyncrun_prepare_add(function()
    M.addcommitpush('s1')
  end)
  B.system_run('asyncrun', {
    B.system_cd(git_root_dir),
    'md "%s"',
    'cd %s',
    'git init --bare',
    'cd ..',
    'git init',
    'git add .gitignore',
    [[git commit -m ".gitignore"]],
    [[git remote add origin "%s"]],
    [[git branch -M "main"]],
    [[git push -u origin "main"]],
  }, remote_name, remote_name, remote_name)
end

M.init = function()
  B.ui_sel(B.get_file_dirs(vim.api.nvim_buf_get_name(0)), 'git init', function(choice)
    if choice then
      M.init_do(choice)
    end
  end)
end

M.addall = function()
  pcall(vim.call, 'ProjectRootCD')
  B.system_run('asyncrun', 'git add -A')
end

M.pull = function()
  pcall(vim.call, 'ProjectRootCD')
  B.system_run('asyncrun', 'git pull')
end

M.reset_hard = function()
  local res = vim.fn.input('git reset --hard [N/y]: ', 'y')
  if vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES', }, res) == true then
    B.system_run('asyncrun', 'git reset --hard')
  end
end

M.reset_hard_clean = function()
  local res = vim.fn.input('git reset --hard && git clean -fd [N/y]: ', 'y')
  if vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES', }, res) == true then
    B.system_run('asyncrun', 'git reset --hard && git clean -fd')
  end
end

M.clone = function()
  B.notify_info { 'cwd: ' .. vim.loop.cwd(), }
  local res = vim.fn.input 'Input git repo name: '
  B.system_run('asyncrun', 'git clone git@github.com:peter-lyr/%s.git', res)
end

return M
