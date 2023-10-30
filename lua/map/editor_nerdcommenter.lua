local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

require(M.config)

vim.keymap.set({ 'n', }, '<leader>co',  "}kvip:call nerdcommenter#Comment('x', 'invert')<CR>", { desc = 'Nerdcommenter invert a paragraph', })
vim.keymap.set({ 'n', }, '<leader>cp',  "}kvip:call nerdcommenter#Comment('x', 'toggle')<CR>", { desc = 'Nerdcommenter invert paragraph', })

return M
