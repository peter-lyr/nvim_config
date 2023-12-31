local M = {}

-- session dir and file

local path = require 'plenary.path'
local session_dir = path:new(vim.fn.stdpath 'data'):joinpath 'session'
local session_last_all = session_dir:joinpath 'last_all.txt'
local session_branches = session_dir:joinpath 'branches.txt'

if not session_dir:exists() then
  session_dir:mkdir()
end

if not session_branches:exists() then
  session_branches:write('{}', 'w')
end

if not session_last_all:exists() then
  session_last_all:write('{}', 'w')
end

-- last all buffers

local function rep(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '\\', '/')
  return content
end

local function get_branch(project)
  local head = path:new(project):joinpath('.git', 'HEAD')
  local branch = 'xxxxxx'
  if head:exists() then
    local HEAD = head:read()
    branch = HEAD:match 'ref: refs/heads/(.+)$'
    if not branch then
      branch = HEAD:sub(1, 6)
    end
    branch = vim.fn.trim(branch)
  end
  return branch
end

M.save = function()
  local sta, data = pcall(loadstring('return ' .. session_branches:read()))
  local last_all_buffers = {}
  local branches_buffers = {}
  local branches_buffers_old = sta and data or {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(bufnr) == 0 or vim.api.nvim_buf_is_loaded(bufnr) == false or vim.api.nvim_buf_get_option(bufnr, 'readonly') == true then
      goto continue
    end
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local fpath = path:new(fname)
    if #fname == 0 or not fpath:exists() or fpath:is_dir() then
      goto continue
    end
    local project = rep(vim.fn['ProjectRootGet'](fname))
    local branch = get_branch(project)
    fname = rep(fname)
    table.insert(last_all_buffers, fname)
    if vim.tbl_contains(vim.tbl_keys(branches_buffers), project) == false then
      local f1 = { fname, }
      local b1 = {}
      b1[branch] = f1
      branches_buffers[project] = b1
    else
      if vim.tbl_contains(vim.tbl_keys(branches_buffers[project]), branch) == false then
        branches_buffers[project][branch] = { fname, }
      else
        table.insert(branches_buffers[project][branch], fname)
      end
    end
    ::continue::
  end
  local temp = {}
  for project, branch in pairs(branches_buffers_old) do
    if path:new(project):exists() then
      temp[project] = branch
    end
  end
  branches_buffers = vim.tbl_deep_extend('force', temp, branches_buffers)
  if #vim.tbl_keys(branches_buffers) > 0 then
    session_branches:write(vim.inspect(branches_buffers), 'w')
  end
  if #last_all_buffers > 0 then
    session_last_all:write(vim.inspect(last_all_buffers), 'w')
  end
end

local opened = nil

M.open_last_all = function()
  opened = 1
  local sta, data = pcall(loadstring('return ' .. session_last_all:read()))
  if sta and #data > 0 then
    for _, fname in ipairs(data) do
      vim.cmd('e ' .. fname)
    end
  end
end

M.open_branches = function()
  opened = 1
  local sta, data = pcall(loadstring('return ' .. session_branches:read()))
  if sta and data and #vim.tbl_keys(data) > 0 then
    vim.ui.select(vim.fn.sort(vim.tbl_keys(data)), { prompt = 'session open project', }, function(project)
      local branch = get_branch(project)
      if vim.tbl_contains(vim.tbl_keys(data[project]), branch) == true then
        for _, fname in ipairs(data[project][branch]) do
          vim.cmd('e ' .. fname)
        end
      else
        print('no such branch:', branch)
      end
    end)
  end
end

M.delete_branches = function()
  local sta, data = pcall(loadstring('return ' .. session_branches:read()))
  if sta and data and #vim.tbl_keys(data) > 0 then
    vim.ui.select(vim.fn.sort(vim.tbl_keys(data)), { prompt = 'session delete project', }, function(project)
      local new_data = {}
      for p, b in pairs(data) do
        if p ~= project then
          new_data[p] = b
        end
      end
      session_branches:write(vim.inspect(new_data), 'w')
    end)
  end
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNew", "BufNewFile", }, {
  callback = function(ev)
    if opened and #ev.file > 0 then
      M.save()
    end
  end,
})

vim.api.nvim_create_autocmd({ "ExitPre", }, {
  callback = function()
    M.save()
  end,
})

return M
