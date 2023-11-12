local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
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

function M.create()
  B.system_run('start', 'python %s %s & pause', M.markdown_export_py, vim.api.nvim_buf_get_name(0))
end

function M.delete()
  local fpath = require 'plenary.path':new(vim.api.nvim_buf_get_name(0))
  if fpath:exists() then
    local curdir = fpath:parent().filename
    curdir = string.gsub(curdir, '/', '\\')
    local files = getfiles(curdir)
    local cnt = 0
    local lines = {}
    for _, file in ipairs(files) do
      cnt = cnt + 1
      vim.fn.system('del "' .. file .. '"')
      lines[#lines + 1] = file
    end
    table.insert(lines, 1, string.format('delete %d file(s)', cnt))
    B.notify_info(lines)
  end
end

return M
