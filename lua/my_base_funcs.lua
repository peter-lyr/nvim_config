local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

function M.get_loaded_valid_bufs()
  local files = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if B.is_buf_loaded_valid(buf) then
      local file = vim.api.nvim_buf_get_name(buf)
      if #file > 0 and B.file_exists(file) then
        local proj = B.rep_baskslash_lower(vim.fn['ProjectRootGet'](file))
        if vim.tbl_contains(vim.tbl_keys(files), proj) == false then
          files[proj] = {}
        end
        files[proj][#files[proj] + 1] = file
      end
    end
  end
  return files
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

return M
