local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

B.load_require 'rcarriga/nvim-notify'
B.load_require 'skywind3000/asyncrun.vim'

function M.addcommitpush(info)
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

function M.commit_push(info)
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

function M.commit(info)
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

function M.graph(runway)
  if not runway then
    B.system_run('asyncrun', 'git log --all --graph --decorate --oneline')
  else
    B.system_run(runway, 'git log --all --graph --decorate --oneline && pause')
  end
end

function M.push()
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
    local lines = file_path:readlines()
    if vim.tbl_contains(lines, remote_name) == false then
      file_path:write(remote_name, 'a')
      file_path:write('.clang-format', 'a')
    end
  else
    file_path:write(remote_name, 'w')
    file_path:write('.clang-format', 'w')
  end
  B.asyncrun_prepare_add(function()
    M.addcommitpush 's1'
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

function M.init()
  B.ui_sel(B.get_file_dirs(vim.api.nvim_buf_get_name(0)), 'git init', function(choice)
    if choice then
      M.init_do(choice)
    end
  end)
end

function M.addall()
  pcall(vim.call, 'ProjectRootCD')
  B.system_run('asyncrun', 'git add -A')
end

function M.pull()
  pcall(vim.call, 'ProjectRootCD')
  B.system_run('asyncrun', 'git pull')
end

function M.reset_hard()
  local res = vim.fn.input('git reset --hard [N/y]: ', 'y')
  if vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES', }, res) == true then
    B.system_run('asyncrun', 'git reset --hard')
  end
end

function M.reset_hard_clean()
  local res = vim.fn.input('git reset --hard && git clean -fd [N/y]: ', 'y')
  if vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES', }, res) == true then
    B.system_run('asyncrun', 'git reset --hard && git clean -fd')
  end
end

function M.clean_ignored_files_and_folders()
  local result = vim.fn.systemlist { 'git', 'clean', '-xdn', }
  if #result > 0 then
    B.notify_info { 'git clean -xdn', vim.loop.cwd(), table.concat(result, '\n'), }
    local res = vim.fn.input('Sure to del all of them? [Y/n]: ', 'y')
    if vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES', }, res) == false then
      return
    end
  else
    return
  end
  vim.g.cwd = vim.fn['ProjectRootGet']()
  vim.cmd [[
    python << EOF
import subprocess
import vim
import re
import os
import shutil
cwd = vim.eval('g:cwd')
rm_exclude = [
  '.git-.*',
  '.svn'
]
out = subprocess.Popen(['git', 'clean', '-xdn'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, cwd=cwd)
stdout, stderr = out.communicate()
if not stderr:
  stdout = stdout.decode('utf-8').replace('\r', '').split('\n')
  c = 0
  for line in stdout:
    res = re.findall('Would remove (.+)', line)
    if res:
      ok = 1
      for p in rm_exclude:
        if re.match(p, res[0]):
          ok = 0
          break
      if ok:
        c += 1
        file = os.path.join(cwd, res[0])
        if re.match('.+/$', res[0]):
          shutil.rmtree(file)
        else:
          os.remove(file)
  vim.command(f"""lua require'my_base'.notify_info('del {c} Done!')""")
EOF
]]
end

function M.clone()
  local dirs = B.merge_tables(
    require 'config.sidepanel_nvimtree'.my_dirs,
    B.get_file_dirs(B.rep_backslash_lower(vim.api.nvim_buf_get_name(0)))
  )
  B.ui_sel(dirs, 'git clone sel a dir', function(proj)
    local author, repo = string.match(vim.fn.input('author/repo to clone: ', 'peter-lyr/iw23'), '(.+)/(.+)')
    if B.is(author) and B.is(repo) then
      B.system_run('start', [[cd %s & git clone git@github.com:%s/%s.git]], proj, author, repo)
    end
  end)
end

function M.branch_new_and_checkout()
  local branchname = vim.fn.input('new branch name: ', vim.fn['gitbranch#name']())
  local cur_repo = B.rep_backslash_lower(vim.fn['ProjectRootGet']())
  B.system_run('start', [[cd %s & git checkout -b %s]], B.system_cd(cur_repo), branchname)
end

M.merge_other_repo_py = require 'plenary.path':new(M.source .. '.merge_other_repo.py')

B.load_require 'itchyny/vim-gitbranch'

function M.append(str_format, ...)
  if type(str_format) == 'table' then
    str_format = vim.fn.join(str_format, ' && ')
  end
  local cmd = string.format(str_format, ...)
  vim.fn.append('.', cmd)
end

M.do_not_move_itmes = {
  'README.md',
  '.images',
  '.docs',
}

function M.merge_other_repo()
  local cur_repo = B.rep_backslash_lower(vim.fn['ProjectRootGet']())
  if #cur_repo > 0 then
    local repos = require 'config.sidepanel_nvimtree'.get_all_repos()
    B.ui_sel(repos, 'merge which repo to ' .. vim.loop.cwd(), function(repo)
      repo = B.rep_backslash_lower(repo)
      if #repo > 0 and repo ~= cur_repo then
        local dir = vim.fn.input(string.format('mv %s to which dir (auto create): ', repo), B.get_only_name(repo))
        if not B.is(dir) then
          return
        end
        local branchname = vim.fn.input(string.format('sel which branch of %s: ', repo), 'main')
        if not B.is(branchname) then
          return
        end
        local do_not_move_itmes = vim.fn.join(M.do_not_move_itmes, '" "')
        B.system_run('start', {
            'cd %s',
            'python "%s" "%s" "%s" "%s" "%s" "%s" "%s"',
          },
          B.system_cd(vim.loop.cwd()),
          M.merge_other_repo_py,
          cur_repo,
          dir,
          vim.fn['gitbranch#name'](),
          repo,
          branchname,
          do_not_move_itmes
        )
      end
    end)
  end
end

return M
