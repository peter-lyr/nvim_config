local M = {}

local B = require 'base'

package.loaded[B.get_loaded()] = nil

M.sessions_dir_path = B.get_std_data_dir_path 'sessions'
M.sessions_txt_path = B.get_create_file_path(M.sessions_dir_path, 'sessions.txt')

pcall(vim.cmd, 'Lazy load telescope-ui-select.nvim')

function M.sel()
  local lines = M.sessions_txt_path:readlines()
  local fnames = {}
  for _, line in ipairs(lines) do
    local fname = vim.fn.trim(line)
    if #fname > 0 and require 'plenary.path':new(fname):exists() then
      fnames[#fnames + 1] = fname
    end
  end
  if #fnames > 0 then
    vim.ui.select(fnames, { prompt = 'sessions sel open', }, function(choice, idx)
      if not choice then
        return
      end
      vim.cmd('edit ' .. choice)
    end)
  end
end

function M.load()
  local lines = M.sessions_txt_path:readlines()
  for _, line in ipairs(lines) do
    local fname = vim.fn.trim(line)
    if #fname > 0 and require 'plenary.path':new(fname):exists() then
      vim.cmd('edit ' .. fname)
    end
  end
end

function M.save()
  local fnames = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) == true and vim.api.nvim_buf_is_valid(buf) == true then
      local fname = vim.api.nvim_buf_get_name(buf)
      if #fname > 0 and require 'plenary.path':new(fname):exists() then
        fnames[#fnames + 1] = fname
      end
    end
  end
  if #fnames > 0 then
    M.sessions_txt_path:write(vim.fn.join(fnames, '\n'), 'w')
  end
end

B.aucmd('VimLeavePre', { 'VimLeavePre', }, { callback = M.save, })

return M
