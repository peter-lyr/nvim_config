local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

function M.b_prev_buf()
  local C = require 'config.tabline'
  if C.proj_bufs[C.cur_proj] then
    local index
    if vim.v.count ~= 0 then
      index = vim.v.count
    else
      index = B.index_of(C.proj_bufs[C.cur_proj], C.cur_buf) - 1
    end
    if index < 1 then
      index = #C.proj_bufs[C.cur_proj]
    end
    vim.cmd(string.format('b%d', C.proj_bufs[C.cur_proj][index]))
    C.update_bufs_and_refresh_tabline()
  end
end

function M.b_next_buf()
  local C = require 'config.tabline'
  if C.proj_bufs[C.cur_proj] then
    local index
    if vim.v.count ~= 0 then
      index = vim.v.count
    else
      index = B.index_of(C.proj_bufs[C.cur_proj], C.cur_buf) + 1
    end
    if index > #C.proj_bufs[C.cur_proj] then
      index = 1
    end
    vim.cmd(string.format('b%d', C.proj_bufs[C.cur_proj][index]))
    C.update_bufs_and_refresh_tabline()
  end
end

function M.bd_prev_buf()
  local C = require 'config.tabline'
  if #C.proj_bufs[C.cur_proj] > 0 then
    local index = B.index_of(C.proj_bufs[C.cur_proj], C.cur_buf)
    if index <= 1 then
      return
    end
    index = index - 1
    vim.cmd(string.format('Bdelete! %d', C.proj_bufs[C.cur_proj][index]))
    C.update_bufs_and_refresh_tabline()
  end
end

function M.bd_next_buf()
  local C = require 'config.tabline'
  if #C.proj_bufs[C.cur_proj] > 0 then
    local index = B.index_of(C.proj_bufs[C.cur_proj], C.cur_buf)
    if index >= #C.proj_bufs[C.cur_proj] then
      return
    end
    index = index + 1
    vim.cmd(string.format('Bdelete! %d', C.proj_bufs[C.cur_proj][index]))
    C.update_bufs_and_refresh_tabline()
  end
end

return M
