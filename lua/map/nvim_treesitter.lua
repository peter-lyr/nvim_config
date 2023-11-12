local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

B.load_require 'nvim-treesitter/nvim-treesitter-context'
B.load_require 'p00f/nvim-ts-rainbow'

vim.g.matchup_matchparen_offscreen = { method = 'popup', }

B.load_require 'andymass/vim-matchup'

--------------

require('config.nvim_treesitter')

return M
