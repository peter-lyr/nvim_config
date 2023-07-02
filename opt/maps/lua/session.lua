local M = {}

-- session dir and file

local path = require('plenary.path')
local session_dir = path:new(vim.fn.stdpath('data')):joinpath('session')
local session_last_all = session_dir:joinpath('last_all.txt')
local session_branches = session_dir:joinpath('branches.txt')

if not session_dir:exists() then
  session_dir:mkdir()
end

-- last all buffers

local function rep(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '\\', '/')
  return content
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
    local head = path:new(project):joinpath('.git', 'HEAD')
    local branch = 'xxxxxx'
    if head:exists() then
      local HEAD = head:read()
      branch = HEAD:match('ref: refs/heads/(.+)$')
      if not branch then
        branch = HEAD:sub(1, 6)
      end
      branch = vim.fn.trim(branch)
    end
    fname = rep(fname)
    table.insert(last_all_buffers, fname)
    if not vim.tbl_contains(vim.tbl_keys(branches_buffers), project) then
      local f1 = { fname }
      local b1 = {}
      b1[branch] = f1
      branches_buffers[project] = b1
    else
      if not vim.tbl_contains(vim.tbl_keys(branches_buffers[project]), branch) then
        branches_buffers[project][branch] = { fname }
      else
        table.insert(branches_buffers[project][branch], fname)
      end
    end
    ::continue::
  end
  branches_buffers = vim.tbl_deep_extend('force', branches_buffers_old, branches_buffers)
  if #vim.tbl_keys(branches_buffers) > 0 then
    session_branches:write(vim.inspect(branches_buffers), 'w')
  end
  if #last_all_buffers > 0 then
    session_last_all:write(vim.inspect(last_all_buffers), 'w')
  end
end

M.open_last_all = function()
  local sta, data = pcall(loadstring('return ' .. session_last_all:read()))
  if sta and #data > 0 then
    for _, fname in ipairs(data) do
      vim.cmd('e ' .. fname)
    end
  end
end

M.open_branches = function()
end

return M
