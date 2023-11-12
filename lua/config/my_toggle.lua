local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

M.diff = function()
  if vim.o.diff == false then
    vim.cmd 'diffthis'
  else
    local winid = vim.fn.win_getid()
    vim.cmd 'windo diffoff'
    vim.fn.win_gotoid(winid)
  end
  print("vim.o.diff:", vim.o.diff)
end

M.wrap = function()
  if vim.o.wrap == true then
    vim.cmd 'set nowrap'
  else
    vim.cmd 'set wrap'
  end
  print("vim.o.wrap:", vim.o.wrap)
end

M.renu = function()
  if vim.o.relativenumber == true then
    vim.cmd 'set norelativenumber'
  else
    vim.cmd 'set relativenumber'
  end
  print("vim.o.relativenumber:", vim.o.relativenumber)
end

M.signcolumn = function()
  if vim.o.signcolumn == true then
    vim.cmd 'set signcolumn=auto:1'
  else
    vim.cmd 'set signcolumn=no'
  end
  print("vim.o.signcolumn:", vim.o.signcolumn)
end

M.conceallevel = function()
  if vim.o.conceallevel == 0 then
    vim.cmd 'set conceallevel=3'
  else
    vim.cmd 'set conceallevel=0'
  end
  print("vim.o.conceallevel:", vim.o.conceallevel)
end

M.iskeyword_bak = nil

M.iskeyword = function()
  if vim.o.iskeyword == '@,48-57,_,192-255' and M.iskeyword_bak then
    vim.o.iskeyword = M.iskeyword_bak
  else
    M.iskeyword_bak = vim.o.iskeyword
    vim.o.iskeyword = '@,48-57,_,192-255'
  end
  print(vim.o.iskeyword)
end

return M
