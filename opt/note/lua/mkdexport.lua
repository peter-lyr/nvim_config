local M = {}

vim.g.mkdexportpy = require "plenary.path":new(vim.g.pack_path):joinpath('nvim_config', 'opt', 'note',
  'autoload'):joinpath 'main.py'['filename']

local fts = {
  'pdf',
  'html',
  'docx',
}

local getfiles = function(directory)
  local files = {}
  local result = require "plenary.scandir".scan_dir(directory, { depth = 1, hidden = 1, })
  for _, file in ipairs(result) do
    local extension = file:gsub("^.*%.([^.]+)$", "%1")
    if vim.tbl_contains(fts, extension) == true then
      table.insert(files, file)
    end
  end
  return files
end

M.create = function()
  require 'terminal'.send('cmd', 'python ' .. vim.g.mkdexportpy .. ' ' .. vim.api.nvim_buf_get_name(0), 0)
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
    print('delete', cnt, 'file(s)')
  end
end

return M
