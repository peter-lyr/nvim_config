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

return M
