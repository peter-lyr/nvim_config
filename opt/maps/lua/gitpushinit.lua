local M = {}

local testtimer = nil

GitpushinitDone = function()
  testtimer:stop()
  pcall(vim.call, 'fugitive#ReloadStatus')
  local l = vim.fn.getqflist()
  vim.notify(l[1]['text'] .. '\n' .. l[#l-1]['text'] .. '\n' .. l[#l]['text'])
  vim.cmd('au! User AsyncRunStop')
end

local function asyncrunprepare()
  testtimer = vim.loop.new_timer()
  local l = 0
  testtimer:start(300, 100, function()
    vim.schedule(function()
      local temp = #vim.fn.getqflist()
      if l ~= temp then
        pcall(vim.call, 'fugitive#ReloadStatus')
        l = temp
      end
    end)
  end)
  vim.cmd([[au User AsyncRunStop call v:lua.GitpushinitDone()]])
end

M.addcommitpush = function()
  pcall(vim.call, 'ProjectRootCD')
  local result = vim.fn.systemlist({ "git", "status", "-s" })
  if #result > 0 then
    vim.notify("git status -s" .. '\n' .. vim.loop.cwd() .. '\n' .. table.concat(result, '\n'))
    local input = vim.fn.input('commit info (Add all and push): ')
    if #input > 0 then
      vim.loop.new_timer():start(10, 0, function()
        vim.schedule(function()
          asyncrunprepare()
          vim.cmd(string.format('AsyncRun git add -A && git status && git commit -m "%s" && git push', input))
        end)
      end)
    end
  else
    vim.notify('no changes')
  end
end

M.commitpush = function()
  pcall(vim.call, 'ProjectRootCD')
  local result = vim.fn.systemlist({ "git", "diff", "--staged", "--stat" })
  if #result > 0 then
    vim.notify("git diff --staged --stat" .. '\n' .. vim.loop.cwd() .. '\n' .. table.concat(result, '\n'))
    local input = vim.fn.input('commit info (commit and push): ')
    if #input > 0 then
      vim.loop.new_timer():start(10, 0, function()
        vim.schedule(function()
          asyncrunprepare()
          vim.cmd(string.format('AsyncRun git commit -m "%s" && git push', input))
        end)
      end)
    end
  else
    vim.notify('no staged')
  end
end

M.commit = function()
  local result = vim.fn.systemlist({ "git", "diff", "--staged", "--stat" })
  if #result > 0 then
    vim.notify("git diff --staged --stat" .. '\n' .. vim.loop.cwd() .. '\n' .. table.concat(result, '\n'))
    local input = vim.fn.input('commit info (just commit): ')
    if #input > 0 then
      vim.loop.new_timer():start(10, 0, function()
        vim.schedule(function()
          asyncrunprepare()
          vim.cmd(string.format('AsyncRun git commit -m "%s"', input))
        end)
      end)
    end
  else
    vim.notify('no staged')
  end
end

M.push = function()
  pcall(vim.call, 'ProjectRootCD')
  local result = vim.fn.systemlist({ "git", "cherry", "-v" })
  if #result > 0 then
    vim.notify("git cherry -v" .. '\n' .. vim.loop.cwd() .. '\n' .. table.concat(result, '\n'))
    vim.loop.new_timer():start(10, 0, function()
      vim.schedule(function()
        asyncrunprepare()
        vim.cmd('AsyncRun git push')
      end)
    end)
  else
    vim.notify('cherry empty')
  end
end

local function get_fname_tail(fname)
  fname = string.gsub(fname, '\\', '/')
  local fpath = require('plenary.path'):new(fname)
  if fpath:is_file() then
    fname = fpath:_split()
    return fname[#fname]
  elseif fpath:is_dir() then
    fname = fpath:_split()
    if #fname[#fname] > 0 then
      return fname[#fname]
    else
      return fname[#fname - 1]
    end
  end
  return ''
end

local function get_dirs(fname)
  local fpath = require('plenary.path'):new(fname)
  if not fpath:is_file() then
    vim.cmd('ec "not file"')
    return nil
  end
  local dirs = {}
  for _ = 1, 24 do
    fpath = fpath:parent()
    local name = string.gsub(fpath.filename, '\\', '/')
    table.insert(dirs, name)
    if not string.match(name, '/') then
      break
    end
  end
  return dirs
end

M.initdo = function(dpath, run)
  local remote_name = get_fname_tail(dpath)
  if remote_name == '' then
    return
  end
  remote_name = '.git-' .. remote_name
  local remote_dpath = require('plenary.path').new(dpath):joinpath(remote_name)
  if remote_dpath:exists() then
    print('remote path already existed: ' .. remote_dpath)
    return
  end
  local remote_dname = remote_dpath.filename
  local fname = dpath .. '/.gitignore'
  local fpath = require('plenary.path').new(fname)
  if fpath:is_file() then
    local lines = vim.fn.readfile(fname)
    if vim.tbl_contains(lines, remote_name) == false then
      vim.fn.writefile({ remote_name }, fname, "a")
    end
  else
    vim.fn.writefile({ remote_name }, fname, "a")
  end
  asyncrunprepare()
  local cmd = string.gsub(string.format([[%s
      cd %s && md %s &&
      cd %s && git init --bare &&
      cd .. &&
      git init &&
      git add .gitignore &&
      git commit -m ".gitignore" &&
      git remote add origin %s &&
      git branch -M "main" &&
      git push -u origin "main"
      ]],
    not run and 'AsyncRun' or '!',
    dpath, remote_name, remote_dname, remote_name), '%s+', ' ')
  vim.cmd(cmd)
end

M.init = function()
  local fname = vim.api.nvim_buf_get_name(0)
  local dirs = get_dirs(fname)
  if not dirs then
    return
  end
  vim.ui.select(dirs, { prompt = 'git init' }, function(choice)
    if not choice then
      return
    end
    M.initdo(choice)
  end)
end

M.addall = function()
  pcall(vim.call, 'ProjectRootCD')
  asyncrunprepare()
  vim.cmd('AsyncRun git add -A')
end

M.pull = function()
  pcall(vim.call, 'ProjectRootCD')
  asyncrunprepare()
  vim.cmd('AsyncRun git pull')
end

return M
