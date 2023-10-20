local M = {}

function M.rep(content)
  content = string.gsub(content, '\\', '/')
  return content
end

function M.get_source()
  local source = vim.fn.trim(debug.getinfo(1)['source'], '@')
  return M.rep(source)
end

function M.get_loaded()
  local source = M.get_source()
  local loaded = string.match(source, '.+lua/(.+)%.lua')
  loaded = string.gsub(loaded, '/', '.')
  return loaded
end

package.loaded[M.get_loaded()] = nil

M.sessions_dir_p = require 'plenary.path':new(vim.fn.stdpath 'data'):joinpath 'sessions'
M.sessions_txt_p = M.sessions_dir_p:joinpath 'sessions.txt'

if not M.sessions_dir_p:exists() then
  vim.fn.mkdir(M.sessions_dir_p.filename)
end

pcall(vim.cmd, 'Lazy load telescope-ui-select.nvim')

M.sel = function()
  local lines = M.sessions_txt_p:readlines()
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

M.load = function()
  local lines = M.sessions_txt_p:readlines()
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
    M.sessions_txt_p:write(vim.fn.join(fnames, '\n'), 'w')
  end
end

vim.api.nvim_create_autocmd({ 'VimLeavePre', }, { callback = M.save, })

return M
