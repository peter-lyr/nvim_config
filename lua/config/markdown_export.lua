local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

M.markdown_export_py = M.source .. '.main.py'

local fts = {
  'pdf',
  'html',
  'docx',
}

local getfiles = function(dir)
  local files = {}
  local result = require 'plenary.scandir'.scan_dir(dir, { depth = 1, hidden = 1, })
  for _, file in ipairs(result) do
    local ext = vim.fn.tolower(string.match(file, '%.([^.]+)$'))
    if vim.tbl_contains(fts, ext) == true then
      files[#files + 1] = file
    end
  end
  return files
end

M.create = function()
  B.system_run('start', 'python %s %s & pause', M.markdown_export_py, vim.api.nvim_buf_get_name(0))
end

M.delete = function()
  local fpath = require 'plenary.path':new(vim.api.nvim_buf_get_name(0))
  if fpath:exists() then
    local curdir = fpath:parent().filename
    curdir = string.gsub(curdir, '/', '\\')
    local files = getfiles(curdir)
    local cnt = 0
    for _, v in ipairs(files) do
      cnt = cnt + 1
      vim.fn.system('del "' .. v .. '"')
    end
    B.notify_info('delete ' .. tostring(cnt) .. ' file(s)')
  end
end

return M
