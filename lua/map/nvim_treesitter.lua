local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.load_require 'nvim-treesitter/nvim-treesitter-context'
B.load_require 'p00f/nvim-ts-rainbow'

vim.g.matchup_matchparen_offscreen = { method = 'popup', }

B.load_require 'andymass/vim-matchup'

--------------

require(M.config)

return M
