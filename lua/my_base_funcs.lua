local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.load_require 'dbakker/vim-projectroot'

function M.get_loaded_valid_bufs()
  local files = {}
  local cnt = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if B.is_buf_loaded_valid(buf) then
      local file = vim.api.nvim_buf_get_name(buf)
      if #file > 0 and B.file_exists(file) then
        local proj = B.rep_backslash_lower(vim.fn['ProjectRootGet'](file))
        if vim.tbl_contains(vim.tbl_keys(files), proj) == false then
          files[proj] = {}
        end
        files[proj][#files[proj] + 1] = file
        cnt = cnt + 1
      end
    end
  end
  return files, cnt
end

-------------

function M.get_dirs_equal(dname, root_dir)
  if not root_dir then
    root_dir = vim.fn['ProjectRootGet']()
  end
  local entries = require 'plenary.scandir'.scan_dir(root_dir, { hidden = false, depth = 32, add_dirs = true, })
  local dirs = {}
  for _, entry in ipairs(entries) do
    entry = B.rep_slash(entry)
    if require 'plenary.path':new(entry):is_dir() then
      local name = B.get_only_name(entry)
      if name == dname then
        dirs[#dirs + 1] = entry
      end
    end
  end
  return dirs
end

---------

function M.get_file_dirs(file)
  vim.cmd 'Lazy load plenary.nvim'
  if not file then
    file = vim.api.nvim_buf_get_name(0)
  end
  file = B.rep_slash(file)
  local file_path = require 'plenary.path':new(file)
  if not file_path:is_file() then
    B.notify_info('not file: ' .. file)
    return nil
  end
  local dirs = {}
  for _ = 1, 24 do
    file_path = file_path:parent()
    local name = B.rep_backslash(file_path.filename)
    dirs[#dirs + 1] = name
    if not string.match(name, '/') then
      break
    end
  end
  return dirs
end

function M.get_file_dirs_till_git(file)
  vim.cmd 'Lazy load plenary.nvim'
  if not file then
    file = vim.api.nvim_buf_get_name(0)
  end
  file = B.rep_slash(file)
  local file_path = require 'plenary.path':new(file)
  if not file_path:is_file() then
    B.notify_info('not file: ' .. file)
    return {}
  end
  local dirs = {}
  for _ = 1, 24 do
    file_path = file_path:parent()
    local name = B.rep_backslash(file_path.filename)
    dirs[#dirs + 1] = name
    if B.file_exists(require 'plenary.path':new(name):joinpath '.git'.filename) then
      break
    end
  end
  return dirs
end

function M.get_fname_tail(file)
  vim.cmd 'Lazy load plenary.nvim'
  file = B.rep_slash(file)
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

function M.scan_files(dir, pattern)
  local entries = require 'plenary.scandir'.scan_dir(dir, { hidden = true, depth = 1, add_dirs = false, })
  local files = {}
  for _, entry in ipairs(entries) do
    local file = B.rep_slash(entry)
    if not pattern or string.match(file, pattern) then
      files[#files + 1] = B.get_only_name(file)
    end
  end
  return files
end

function M.time_diff(timestamp)
  local diff = os.time() - timestamp
  local years, months, weeks, days, hours, minutes, seconds = 0, 0, 0, 0, 0, 0, 0
  if diff >= 31536000 then
    years = math.floor(diff / 31536000)
    diff = diff - (years * 31536000)
  end
  if diff >= 2592000 then
    months = math.floor(diff / 2592000)
    diff = diff - (months * 2592000)
  end
  if diff >= 604800 then
    weeks = math.floor(diff / 604800)
    diff = diff - (weeks * 604800)
  end
  if diff >= 86400 then
    days = math.floor(diff / 86400)
    diff = diff - (days * 86400)
  end
  if diff >= 3600 then
    hours = math.floor(diff / 3600)
    diff = diff - (hours * 3600)
  end
  if diff >= 60 then
    minutes = math.floor(diff / 60)
    diff = diff - (minutes * 60)
  end
  seconds = diff
  if M.is(years) then
    return string.format('%2d years,   %2d months  ago.', years, months)
  elseif M.is(months) then
    return string.format('%2d months,  %2d weeks   ago.', months, weeks)
  elseif M.is(weeks) then
    return string.format('%2d weeks,   %2d days    ago.', weeks, days)
  elseif M.is(days) then
    return string.format('%2d days,    %2d hours   ago.', days, hours)
  elseif M.is(hours) then
    return string.format('%2d hours,   %2d minutes ago.', hours, minutes)
  elseif M.is(minutes) then
    return string.format('%2d minutes, %2d seconds ago.', minutes, seconds)
  elseif M.is(seconds) then
    return string.format('%2d minutes, %2d seconds ago.', 0, seconds)
  end
end

-----------------

function M.merge_tables(...)
  local result = {}
  for _, t in ipairs { ..., } do
    for _, v in ipairs(t) do
      result[#result + 1] = v
    end
  end
  return result
end

------------------

function M.is(val)
  if not val or val == 0 or val == '' or val == false or val == {} then
    return nil
  end
  return 1
end

function M.is_buf_ft(fts, buf)
  if not buf then
    buf = vim.fn.bufnr()
  end
  if type(fts) == 'string' then
    fts = { fts, }
  end
  if M.is(vim.tbl_contains(fts, vim.api.nvim_buf_get_option(buf, 'filetype'))) then
    return 1
  end
  return nil
end

--------------

function M.index_of(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return -1
end

function M.get_only_name(file)
  file = B.rep_slash(file)
  local only_name = vim.fn.trim(file, '\\')
  if string.match(only_name, '\\') then
    only_name = string.match(only_name, '.+%\\(.+)$')
  end
  return only_name
end

--------------------

function M.get_dir_path(dirs)
  B.load_require 'nvim-lua/plenary.nvim'
  if type(dirs) == 'string' then
    dirs = { dirs, }
  end
  local dir_1 = table.remove(dirs, 1)
  dir_1 = B.rep_slash(dir_1)
  local dir_path = require 'plenary.path':new(dir_1)
  for _, dir in ipairs(dirs) do
    if not dir_path:exists() then
      vim.fn.mkdir(dir_path.filename)
    end
    dir_path = dir_path:joinpath(dir)
  end
  return dir_path
end

function M.get_std_data_dir_path(dirs)
  if type(dirs) == 'string' then
    dirs = { dirs, }
  end
  table.insert(dirs, 1, vim.fn.stdpath 'data')
  return M.get_dir_path(dirs)
end

function M.get_file_path(dirs, file)
  local dir_path = M.get_dir_path(dirs)
  return dir_path:joinpath(file)
end

function M.get_create_file_path(dirs, file)
  local file_path = M.get_file_path(dirs, file)
  if not file_path:exists() then
    file_path:touch()
  end
  return file_path
end

function M.get_create_dir(dirs)
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

function M.get_create_std_data_dir(dirs)
  if type(dirs) == 'string' then
    dirs = { dirs, }
  end
  table.insert(dirs, 1, vim.fn.stdpath 'data')
  return M.get_create_dir(dirs)
end

function M.get_create_file(dir, filename)
  dir = string.gsub(dir, '\\', '/')
  dir = vim.fn.trim(dir, '/')
  local file = dir .. '/' .. filename
  if vim.fn.filereadable(file) == 0 then
    vim.fn.writefile({ '', }, file)
  end
  return file
end

--------------------------------

function M.file_exists(file)
  vim.cmd 'Lazy load plenary.nvim'
  file = B.rep_slash(file)
  return require 'plenary.path':new(file):exists()
end

function M.fetch_existed_files(files)
  local new_files = {}
  for _, file in ipairs(files) do
    file = vim.fn.trim(file)
    if #file > 0 and M.file_exists(file) then
      new_files[#new_files + 1] = file
    end
  end
  return new_files
end

---------

function M.get_cfile()
  local cur_head = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')
  local cfile = vim.fn.expand '<cfile>'
  cfile = B.rep_backslash(cfile)
  cfile = require 'plenary.path':new(cur_head):joinpath(unpack(vim.fn.split(cfile, '/'))).filename
  return cfile
end

function M.get_root_short(project_root_path)
  local temp__ = vim.fn.tolower(vim.fn.fnamemodify(project_root_path, ':t'))
  if #temp__ >= 15 then
    local s1 = ''
    local s2 = ''
    for i = 15, 3, -1 do
      s2 = string.sub(temp__, #temp__ - i, #temp__)
      if vim.fn.strdisplaywidth(s2) <= 7 then
        break
      end
    end
    for i = 15, 3, -1 do
      s1 = string.sub(temp__, 1, i)
      if vim.fn.strdisplaywidth(s1) <= 7 then
        break
      end
    end
    return s1 .. '…' .. s2
  end
  local updir = vim.fn.tolower(vim.fn.fnamemodify(project_root_path, ':h:t'))
  if #updir >= 15 then
    local s1 = ''
    local s2 = ''
    for i = 15, 3, -1 do
      s2 = string.sub(updir, #updir - i, #updir)
      if vim.fn.strdisplaywidth(s2) <= 7 then
        break
      end
    end
    for i = 15, 3, -1 do
      s1 = string.sub(updir, 1, i)
      if vim.fn.strdisplaywidth(s1) <= 7 then
        break
      end
    end
    return s1 .. '…' .. s2
  end
  return updir .. '/' .. temp__
end

return M
