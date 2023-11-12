local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

require('config.editor_nerdcommenter')

vim.keymap.set({ 'n', }, '<leader>co',  "}kvip:call nerdcommenter#Comment('x', 'invert')<CR>", { desc = 'Nerdcommenter invert a paragraph', })
vim.keymap.set({ 'n', }, '<leader>cp',  "}kvip:call nerdcommenter#Comment('x', 'toggle')<CR>", { desc = 'Nerdcommenter toggle a paragraph', })

return M
