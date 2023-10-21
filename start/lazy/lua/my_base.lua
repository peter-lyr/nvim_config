local B = {}

local S = require 'my_simple'

B.get_std_data_dir = S.get_std_data_dir
B.get_dir = S.get_dir
B.get_create_file = S.get_create_file

B.set_timeout = S.set_timeout
B.get_opt_dir = S.get_opt_dir

function B.rep_slash(content)
  content = string.gsub(content, '/', '\\')
  return content
end

function B.rep_slash_lower(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '/', '\\')
  return content
end

function B.rep_baskslash(content)
  content = string.gsub(content, '\\', '/')
  return content
end

function B.rep_baskslash_lower(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '\\', '/')
  return content
end

function B.get_base_source()
  return debug.getinfo(1)['source']
end

function B.get_source(source)
  if not source then
    source = vim.fn.trim(B.get_base_source(), '@')
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

function B.get_desc(source, desc)
  return B.get_loaded(source) .. '-' .. desc, {}
end

function B.get_group(source, desc)
  return vim.api.nvim_create_augroup(B.get_desc(source, desc), {})
end

function B.aucmd(source, desc, event, opts)
  opts = vim.tbl_deep_extend('force', opts, { group = B.get_group(source, desc), desc = B.get_desc(source, desc), })
  vim.api.nvim_create_autocmd(event, opts)
end

function B.get_file_dirs(file)
  vim.cmd 'Lazy load plenary.nvim'
  local file_path = require 'plenary.path':new(file)
  if not file_path:is_file() then
    B.notify_info('not file: ' .. file)
    return nil
  end
  local dirs = {}
  for _ = 1, 24 do
    file_path = file_path:parent()
    local name = B.rep_baskslash(file_path.filename)
    dirs[#dirs + 1] = name
    if not string.match(name, '/') then
      break
    end
  end
  return dirs
end

function B.get_file_path(dirs, file)
  local dir_path = B.get_dir_path(dirs)
  return dir_path:joinpath(file)
end

function B.get_dir_path(dirs)
  vim.cmd 'Lazy load plenary.nvim'
  if type(dirs) == 'string' then
    dirs = { dirs, }
  end
  local dir_1 = table.remove(dirs, 1)
  local dir_path = require 'plenary.path':new(dir_1)
  if not dir_path:exists() then
    vim.fn.mkdir(dir_path.filename)
  end
  for _, dir in ipairs(dirs) do
    dir_path = dir_path:joinpath(dir)
    if not dir_path:exists() then
      vim.fn.mkdir(dir_path.filename)
    end
  end
  return dir_path
end

function B.get_std_data_dir_path(dirs)
  if type(dirs) == 'string' then
    dirs = { dirs, }
  end
  table.insert(dirs, 1, vim.fn.stdpath 'data')
  return B.get_dir_path(dirs)
end

function B.get_create_file_path(dir_path, filename)
  local file_path = dir_path:joinpath(filename)
  if not file_path:exists() then
    file_path:write('', 'w')
  end
  return file_path
end

function B.get_fname_tail(file)
  vim.cmd 'Lazy load plenary.nvim'
  file = string.gsub(file, '\\', '/')
  local fpath = require 'plenary.path':new(file)
  if fpath:is_file() then
    file = fpath:_split()
    return file[#file]
  elseif fpath:is_dir() then
    file = fpath:_split()
    if #file[#file] > 0 then
      return file[#file]
    else
      return file[#file - 1]
    end
  end
  return ''
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

function B.set_interval(interval, callback)
  local timer = vim.fn.timer_start(interval, function()
    callback()
  end, { ['repeat'] = -1, })
  return timer
end

function B.clear_interval(timer)
  vim.fn.timer_stop(timer)
end

B.notify_info = function(message)
  local messages = type(message) == 'table' and message or { message, }
  local title = ''
  if #messages > 1 then
    title = table.remove(messages, 1)
  end
  message = vim.fn.join(messages, '\n')
  vim.notify(message, 'info', {
    title = title,
    animate = false,
    on_open = B.notify_on_open,
    timeout = 1000 * 8,
  })
end

function B.notify_qflist()
  local lines = {}
  for _, i in ipairs(vim.fn.getqflist()) do
    lines[#lines + 1] = i['text']
  end
  B.notify_info(lines)
end

function B.refresh_fugitive()
  vim.cmd 'Lazy load vim-fugitive'
  vim.call 'fugitive#ReloadStatus'
end

function B.asyncrun_prepare(callback)
  if not callback then
    AsyncRunDone = function()
      B.notify_qflist()
      B.refresh_fugitive()
      vim.cmd 'au! User AsyncRunStop'
    end
  else
    AsyncRunDone = function()
      callback()
      vim.cmd 'au! User AsyncRunStop'
    end
  end
  vim.cmd 'au User AsyncRunStop call v:lua.AsyncRunDone()'
end

function B.notify_on_open(win)
  local buf = vim.api.nvim_win_get_buf(win)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  vim.api.nvim_win_set_option(win, 'concealcursor', 'nvic')
end

function B.system_run(way, str_format, ...)
  if type(str_format) == 'table' then
    str_format = vim.fn.join(str_format, ' && ')
  end
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

function B.system_cd(file)
  vim.cmd 'Lazy load plenary.nvim'
  local new_file = ''
  if string.sub(file, 2, 2) == ':' then
    new_file = new_file .. string.sub(file, 1, 2) .. ' && '
  end
  if require 'plenary.path'.new(file):is_dir() then
    return new_file .. 'cd ' .. file
  else
    return new_file .. 'cd ' .. require 'plenary.path'.new(file):parent().filename
  end
end

function B.index_of(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return -1
end

function B.get_only_name(file)
  file = B.rep_slash(file)
  local only_name = vim.fn.trim(file, '\\')
  if string.match(only_name, '\\') then
    only_name = string.match(only_name, '.+%\\(.+)$')
  end
  return only_name
end

function B.buf_map_close(lhs, buf)
  vim.keymap.set({ 'n', 'v', }, lhs, function()
    vim.cmd 'close'
  end, { buffer = buf, nowait = true, desc = 'close', })
end

return B
