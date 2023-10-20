local B = {}

function B.rep_baskslash(content)
  content = string.gsub(content, '\\', '/')
  return content
end

function B.get_source()
  local source = vim.fn.trim(debug.getinfo(1)['source'], '@')
  return B.rep_baskslash(source)
end

function B.get_loaded()
  local source = B.get_source()
  local loaded = string.match(source, '.+lua/(.+)%.lua')
  loaded = string.gsub(loaded, '/', '.')
  return loaded
end

function B.get_desc(desc)
  return B.get_loaded() .. '-' .. desc, {}
end

function B.get_group(desc)
  return vim.api.nvim_create_augroup(B.get_desc(desc), {})
end

function B.aucmd(desc, event, opts)
  opts = vim.tbl_deep_extend('force', opts, { group = B.get_group(desc), desc = B.get_desc(desc), })
  vim.api.nvim_create_autocmd(event, opts)
end

function B.get_std_data_dir_path(dirs)
  vim.cmd 'Lazy load plenary.nvim'
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

function B.get_create_file_path(dir_path, filename)
  local file_path = dir_path:joinpath(filename)
  if not file_path:exists() then
    file_path:write('', 'w')
  end
  return file_path
end

function B.ui_sel(items, prompt, callback)
  vim.cmd 'Lazy load telescope-ui-select.nvim'
  if #items > 0 then
    vim.ui.select(items, { prompt = prompt, }, callback)
  end
end

function B.file_exists(file)
  vim.cmd 'Lazy load plenary.nvim'
  return require 'plenary.path':new(file):exists()
end

return B
