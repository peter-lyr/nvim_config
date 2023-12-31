local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

B.load_require 'L3MON4D3/LuaSnip'
B.load_require 'hrsh7th/cmp-buffer'
B.load_require 'hrsh7th/cmp-cmdline'
B.load_require 'hrsh7th/cmp-nvim-lsp'
B.load_require 'hrsh7th/cmp-path'
B.load_require 'rafamadriz/friendly-snippets'
B.load_require 'saadparwaiz1/cmp_luasnip'

-----------------

require('config.nvim_cmp')

return M
