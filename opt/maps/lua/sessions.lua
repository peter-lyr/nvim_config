local M = {}

function M.rep_baskslash(content)
  content = string.gsub(content, '\\', '/')
  return content
end

function M.get_source()
  local source = vim.fn.trim(debug.getinfo(1)['source'], '@')
  return M.rep_baskslash(source)
end

function M.get_loaded()
  local source = M.get_source()
  local loaded = string.match(source, '.+lua/(.+)%.lua')
  loaded = string.gsub(loaded, '/', '.')
  return loaded
end

package.loaded[M.get_loaded()] = nil

function M.get_desc(desc)
  return M.get_loaded() .. '-' .. desc, {}
end

function M.get_group(desc)
  return vim.api.nvim_create_augroup(M.get_desc(desc), {})
end

function M.aucmd(desc, event, opts)
  opts = vim.tbl_deep_extend('force', opts, { group = M.get_group(desc), desc = M.get_desc(desc), })
  vim.api.nvim_create_autocmd(event, opts)
end

function M.get_std_data_dir_path(dirs)
  local std_data_path = require 'plenary.path':new(vim.fn.stdpath 'data')
  if not dir then
    return std_data_path
  end
  local dir_path = std_data_path
  if type(dirs) == 'string' then
    dirs = { dirs, }
  end
  for _, dir in dirs do
    dir_path = std_data_path:joinpath(dir)
    if not dir_path:exists() then
      vim.fn.mkdir(dir_path.filename)
    end
  end
  return dir_path
end

function M.get_create_file_path(dir_path, filename)
  local file_path = dir_path:joinpath(filename)
  if not file_path:exists() then
    file_path:write('', 'w')
  end
  return file_path
end

M.sessions_dir_path = M.get_std_data_dir_path 'sessions'
M.sessions_txt_path = M.get_create_file_path(M.sessions_dir_path, 'sessions.txt')

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

M.aucmd('VimLeavePre', { 'VimLeavePre', }, { callback = M.save, })

return M
