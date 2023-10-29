local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.load_require 'dbakker/vim-projectroot'

B.map_set_lua(M.config)

B.map('<leader>mu', 'update', { 'cur', })
B.map('<leader>mU', 'update', { 'cwd', })
B.map('<leader>mv', 'paste', { 'jpg', })
B.map('<leader>mV', 'paste', { 'png', })
B.map('<leader>my', 'copy_text', {})
B.map('<leader>mY', 'copy_file', {})
B.map('<s-f11>', 'copy_file', {})
B.map('<leader>mE', 'edit_drag_bin_fts_md', {})

----------------

B.aucmd(M.source, 'FocusLost', { 'FocusLost', }, {
  callback = function()
    require(M.config).focuslost()
  end,
})

B.aucmd(M.source, 'BufReadPre', { 'BufReadPre', }, {
  callback = function(ev)
    require(M.config).readpre(ev)
  end,
})

B.aucmd(M.source, 'BufReadPost', { 'BufReadPost', }, {
  callback = function()
    require(M.config).readpost()
  end,
})

B.aucmd(M.source, 'BufEnter', { 'BufEnter', }, {
  callback = function(ev)
    require(M.config).bufenter(ev)
  end,
})

return M
