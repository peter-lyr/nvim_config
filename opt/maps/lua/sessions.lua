local M = {}

local B = require 'base'

package.loaded[B.get_loaded()] = nil

M.sessions_dir_path = B.get_std_data_dir_path 'sessions'
M.sessions_txt_path = B.get_create_file_path(M.sessions_dir_path, 'sessions.txt')

function M.sel()
  local files = {}
  for _, line in ipairs(M.sessions_txt_path:readlines()) do
    local fname = vim.fn.trim(line)
    if #fname > 0 and B.file_exists(fname) then
      files[#files + 1] = fname
    end
  end
  B.ui_sel(files, 'sessions sel open', function(choice, idx)
    if not choice then
      return
    end
    vim.cmd('edit ' .. choice)
  end)
end

function M.load()
  for _, line in ipairs(M.sessions_txt_path:readlines()) do
    local fname = vim.fn.trim(line)
    if #fname > 0 and B.file_exists(fname) then
      vim.cmd('edit ' .. fname)
    end
  end
end

function M.save()
  local files = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) == true and vim.api.nvim_buf_is_valid(buf) == true then
      local fname = vim.api.nvim_buf_get_name(buf)
      if #fname > 0 and B.file_exists(fname) then
        files[#files + 1] = fname
      end
    end
  end
  if #files > 0 then
    M.sessions_txt_path:write(vim.fn.join(files, '\n'), 'w')
  end
end

B.aucmd('VimLeavePre', { 'VimLeavePre', }, { callback = M.save, })

return M
