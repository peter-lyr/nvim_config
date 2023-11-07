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
        local proj = B.rep_baskslash_lower(vim.fn['ProjectRootGet'](file))
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
  file = B.rep_slash(file)
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
    if string.match(file, pattern) then
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
  if B.is(years) then
    return string.format('%2d years,   %2d months  ago.', years, months)
  elseif B.is(months) then
    return string.format('%2d months,  %2d weeks   ago.', months, weeks)
  elseif B.is(weeks) then
    return string.format('%2d weeks,   %2d days    ago.', weeks, days)
  elseif B.is(days) then
    return string.format('%2d days,    %2d hours   ago.', days, hours)
  elseif B.is(hours) then
    return string.format('%2d hours,   %2d minutes ago.', hours, minutes)
  elseif B.is(minutes) then
    return string.format('%2d minutes, %2d seconds ago.', minutes, seconds)
  elseif B.is(seconds) then
    return string.format('%2d minutes, %2d seconds ago.', 0, seconds)
  end
end

return M
