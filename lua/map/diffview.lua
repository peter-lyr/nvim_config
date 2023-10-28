local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------


B.load_require 'nvim-lua/plenary.nvim'
B.load_require 'nvim-tree/nvim-web-devicons'
B.load_require 'paopaol/telescope-git-diffs.nvim'

require 'map.telescope'

---------------

B.map_set_lua(M.config)

B.map('<leader>gv1', 'filehistory', { '16', })
B.map('<leader>gv2', 'filehistory', { '64', })
B.map('<leader>gv3', 'filehistory', { 'finite', })
B.map('<leader>gvs', 'filehistory', { 'stash', })
B.map('<leader>gvb', 'filehistory', { 'base', })
B.map('<leader>gvr', 'filehistory', { 'range', })
B.map('<leader>gvo', 'open')
B.map('<leader>gvl', 'refresh')
B.map('<leader>gvq', 'close')
B.map('<leader>gvw', 'diff_commits')

--------------

B.register_whichkey('<leader>gv', 'Diffview')

B.merge_whichkeys()

------

require 'telescope'.load_extension 'git_diffs'

----------

B.aucmd(M.source, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    require 'config.diffview'.number(ev)
  end,
})

------

return M
