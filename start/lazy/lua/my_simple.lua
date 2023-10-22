local S = {}

function S.get_create_dir(dirs)
  if type(dirs) == 'string' then
    dirs = { dirs, }
  end
  local dir_1 = table.remove(dirs, 1)
  local dir = string.gsub(dir_1, '\\', '/')
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir)
  end
  for _, d in ipairs(dirs) do
    dir = dir .. '/' .. d
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir)
    end
  end
  return dir
end

function S.get_create_opt_dir(dir)
  return S.get_create_dir { vim.fn.expand '$VIMRUNTIME', 'pack', 'nvim_config', 'opt', dir }
end

function S.get_create_std_data_dir(dirs)
  if type(dirs) == 'string' then
    dirs = { dirs, }
  end
  table.insert(dirs, 1, vim.fn.stdpath 'data')
  return S.get_create_dir(dirs)
end

function S.get_create_file(dir, filename)
  dir = string.gsub(dir, '\\', '/')
  dir = vim.fn.trim(dir, '/')
  local file = dir .. '/' .. filename
  if vim.fn.filereadable(file) == 0 then
    vim.fn.writefile({ '', }, file)
  end
  return file
end

function S.set_timeout(timeout, callback)
  local timer = vim.fn.timer_start(timeout, function()
    callback()
  end, { ['repeat'] = 1, })
  return timer
end

return S
