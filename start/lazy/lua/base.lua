local B = {}

function B.rep_baskslash(content)
  content = string.gsub(content, '\\', '/')
  return content
end

function B.get_source(source)
  if not source then
    source = vim.fn.trim(debug.getinfo(1)['source'], '@')
  end
  return B.rep_baskslash(source)
end

function B.get_loaded(source)
  source = B.get_source(source)
  local loaded = string.match(source, '.+lua/(.+)%.lua')
  loaded = string.gsub(loaded, '/', '.')
  return loaded
end

package.loaded[B.get_loaded()] = nil

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

function B.is_buf_loaded_valid(buf)
  return vim.api.nvim_buf_is_loaded(buf) == true and vim.api.nvim_buf_is_valid(buf) == true
end

function B.get_loaded_valid_bufs()
  local files = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if B.is_buf_loaded_valid(buf) then
      local fname = vim.api.nvim_buf_get_name(buf)
      if #fname > 0 and B.file_exists(fname) then
        files[#files + 1] = fname
      end
    end
  end
  return files
end

function B.fetch_existed_files(files)
  local new_files = {}
  for _, file in ipairs(files) do
    file = vim.fn.trim(file)
    if #file > 0 and B.file_exists(file) then
      new_files[#new_files + 1] = file
    end
  end
  return new_files
end

function B.set_timeout(timeout, callback)
  local timer = vim.fn.timer_start(timeout, function()
    callback()
  end, { ['repeat'] = 1, })
  return timer
end

function B.set_interval(interval, callback)
  local timer = vim.fn.timer_start(interval, function()
    callback()
  end, { ['repeat'] = -1, })
  return timer
end

function B.clear_interval(timer)
  vim.fn.timer_stop(timer)
end

function B.notify_qflist()
  local lines = {}
  for _, i in ipairs(vim.fn.getqflist()) do
    lines[#lines + 1] = i['text']
  end
  vim.notify(vim.fn.join(lines, '\n'))
end

function B.asyncrun_prepare(callback)
  B.temp_function = function()
    if not callback then
      B.notify_qflist()
    else
      B.temp_function = function()
        callback()
      end
    end
    vim.cmd 'au! User AsyncRunStop'
  end
  vim.cmd "au User AsyncRunStop call v:lua.require('base').temp_function()"
end

function B.notify_on_open(win)
  local buf = vim.api.nvim_win_get_buf(win)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  vim.api.nvim_win_set_option(win, 'concealcursor', 'nvic')
end

B.notify_info = function(message)
  local messages = type(message) == 'table' and message or { message, }
  local title = table.remove(messages, 1)
  message = vim.fn.join(messages, '\n')
  vim.notify(message, 'info', {
    title = title,
    animate = false,
    on_open = B.notify_on_open,
    timeout = 1000 * 8,
  })
end

function B.system_run(way, str_format, ...)
  local cmd = string.format(str_format, ...)
  if way == 'start' then
    cmd = string.format([[silent !start cmd /c "%s"]], cmd)
    vim.cmd(cmd)
  elseif way == 'asyncrun' then
    vim.cmd 'Lazy load asyncrun.vim'
    cmd = string.format('AsyncRun %s', cmd)
    B.asyncrun_prepare()
    vim.cmd(cmd)
  elseif way == 'term' then
    cmd = string.format('wincmd s|term %s', cmd)
    vim.cmd(cmd)
  end
end

return B
