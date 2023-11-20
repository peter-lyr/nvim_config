local B = {}

local S = require 'startup'

-----------------------------

B.load_require = S.load_require

B.load_post = nil

function B.load_require_common()
  if not B.is(B.load_post) then
    B.load_post = 1
    B.load_require 'navarasu/onedark.nvim'
    vim.cmd.colorscheme 'onedark'
  end
end

-----------------------------

function B.is(val)
  if not val or val == 0 or val == '' or val == false or val == {} then
    return nil
  end
  return 1
end

function B.is_buf_ft(fts, buf)
  if not buf then
    buf = vim.fn.bufnr()
  end
  if type(fts) == 'string' then
    fts = { fts, }
  end
  if B.is(vim.tbl_contains(fts, vim.api.nvim_buf_get_option(buf, 'filetype'))) then
    return 1
  end
  return nil
end

function B.rep_slash(content)
  content = string.gsub(content, '/', '\\')
  return content
end

function B.rep_slash_lower(content)
  return vim.fn.tolower(B.rep_slash(content))
end

function B.rep_baskslash(content)
  content = string.gsub(content, '\\', '/')
  return content
end

function B.rep_baskslash_lower(content)
  return vim.fn.tolower(B.rep_baskslash(content))
end

-----------------------------

function B.get_base_source()
  return debug.getinfo(1)['source']
end

function B.get_source(source)
  if not source then
    source = B.get_base_source()
  end
  source = vim.fn.trim(source, '@')
  return B.rep_baskslash(source)
end

function B.get_loaded(source)
  source = B.get_source(source)
  local loaded = string.match(source, '.+lua/(.+)%.lua')
  if not loaded then
    return ''
  end
  loaded = string.gsub(loaded, '/', '.')
  return loaded
end

B.source = B.get_source(debug.getinfo(1)['source'])
B.loaded = B.get_loaded(B.source)

-----------------------------

function B.merge_tables(...)
  return require 'my_base_funcs'.merge_tables(...)
end

-----------------------------

B.whichkeys = {}

function B.register_whichkey(lua, key, desc)
  require 'my_base_keymap'.register_whichkey(B.whichkeys, lua, key, desc)
end

function B.merge_whichkeys()
  require 'which-key'.register(B.whichkeys)
end

-----------------------------

function B.get_desc(source, desc)
  return B.get_loaded(source) .. '-' .. desc, {}
end

function B.get_group(source, desc)
  return vim.api.nvim_create_augroup(B.get_desc(source, desc), {})
end

function B.aucmd(source, desc, event, opts)
  opts = vim.tbl_deep_extend('force', opts, { group = B.get_group(source, desc), desc = B.get_desc(source, desc), })
  return vim.api.nvim_create_autocmd(event, opts)
end

-----------------------------

function B.set_timeout(timeout, callback)
  return vim.fn.timer_start(timeout, function()
    callback()
  end, { ['repeat'] = 1, })
end

function B.set_interval(interval, callback)
  return vim.fn.timer_start(interval, function()
    callback()
  end, { ['repeat'] = -1, })
end

function B.clear_interval(timer)
  pcall(vim.fn.timer_stop, timer)
end

-----------------------------

function B.source_lua(file)
  require 'config.my_test_useful'.source_lua(file)
end

function B.map_buf_c_q_close(buf, cmd)
  require 'config.my_test_useful'.map_buf_c_q_close(buf, cmd)
end

-----------------------------

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

--------------------

function B.get_dir_path(dirs)
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

function B.get_std_data_dir_path(dirs)
  if type(dirs) == 'string' then
    dirs = { dirs, }
  end
  table.insert(dirs, 1, vim.fn.stdpath 'data')
  return B.get_dir_path(dirs)
end

function B.get_file_path(dirs, file)
  local dir_path = B.get_dir_path(dirs)
  return dir_path:joinpath(file)
end

function B.get_create_file_path(dirs, file)
  local file_path = B.get_file_path(dirs, file)
  if not file_path:exists() then
    file_path:touch()
  end
  return file_path
end

function B.get_create_dir(dirs)
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

function B.get_create_std_data_dir(dirs)
  if type(dirs) == 'string' then
    dirs = { dirs, }
  end
  table.insert(dirs, 1, vim.fn.stdpath 'data')
  return B.get_create_dir(dirs)
end

function B.get_create_file(dir, filename)
  dir = string.gsub(dir, '\\', '/')
  dir = vim.fn.trim(dir, '/')
  local file = dir .. '/' .. filename
  if vim.fn.filereadable(file) == 0 then
    vim.fn.writefile({ '', }, file)
  end
  return file
end

----------------

function B.file_exists(file)
  vim.cmd 'Lazy load plenary.nvim'
  file = B.rep_slash(file)
  return require 'plenary.path':new(file):exists()
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

---------

function B.notify_info(message)
  require 'my_base_asyncrun'.notify_info(message)
end

function B.notify_error(message)
  require 'my_base_asyncrun'.notify_error(message)
end

function B.system_cd(file)
  return require 'my_base_asyncrun'.system_cd(file)
end

function B.system_run(way, str_format, ...)
  require 'my_base_asyncrun'.system_run(way, str_format, ...)
end

--------

function B.powershell_run(file)
  return require 'my_base_asyncrun'.powershell_run(file)
end

-----------

function B.asyncrun_prepare_add(callback)
  return require 'my_base_asyncrun'.asyncrun_prepare_add(callback)
end

----------------------

function B.ui_sel(items, prompt, callback)
  if items and #items > 0 then
    vim.ui.select(items, { prompt = prompt, }, callback)
  end
end

function B.is_buf_loaded_valid(buf)
  return vim.api.nvim_buf_is_loaded(buf) == true and vim.api.nvim_buf_is_valid(buf) == true
end

function B.get_loaded_valid_bufs()
  return require 'my_base_funcs'.get_loaded_valid_bufs()
end

------

function B.get_dirs_equal(dname, root_dir)
  return require 'my_base_funcs'.get_dirs_equal(dname, root_dir)
end

function B.get_file_dirs(file)
  return require 'my_base_funcs'.get_file_dirs(file)
end

function B.get_file_dirs_till_git(file)
  return require 'my_base_funcs'.get_file_dirs_till_git(file)
end

function B.get_fname_tail(file)
  return require 'my_base_funcs'.get_fname_tail(file)
end

--------

function B.cmd(str_format, ...)
  return require 'my_base_asyncrun'.cmd(str_format, ...)
end

function B.print(str_format, ...)
  return require 'my_base_asyncrun'.print(str_format, ...)
end

---------------

function B.scan_files(dir, pattern)
  return require 'my_base_funcs'.scan_files(dir, pattern)
end

function B.time_diff(timestamp)
  return require 'my_base_funcs'.time_diff(timestamp)
end

------------

function B.del_dir(dir)
  B.system_run('start silent', [[del /s /q %s & rd /s /q %s]], dir, dir)
end

function B.get_cfile()
  local cur_head = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')
  local cfile = vim.fn.expand '<cfile>'
  cfile = B.rep_baskslash(cfile)
  cfile = require 'plenary.path':new(cur_head):joinpath(unpack(vim.fn.split(cfile, '/'))).filename
  return cfile
end

return B
