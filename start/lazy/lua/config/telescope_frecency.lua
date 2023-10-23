local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
package.loaded[B.get_loaded(M.source)] = nil
--------------------------------------------

B.load('sqlite.lua')
B.load('telescope.nvim', 'telescope')

vim.g.sqlite_clib_path = require 'plenary.path':new(vim.g.pack_path):parent():parent():parent():parent():parent():joinpath('sqlite3', 'sqlite3.dll').filename

pcall(require 'telescope'.load_extension, 'frecency')

M.frecency = function()
  vim.cmd 'Telescope frecency'
end

return M
