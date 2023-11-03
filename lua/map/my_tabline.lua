local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.load_require 'dbakker/vim-projectroot'
B.load_require 'peter-lyr/vim-bbye'

--------------------

B.map_set_lua(M.config)

B.map('<c-l>', 'b_next_buf', {})
B.map('<c-h>', 'b_prev_buf', {})

B.map('<c-s-l>', 'bd_next_buf', {})
B.map('<c-s-h>', 'bd_prev_buf', {})

--------

B.map('<leader>qw', 'only_cur_buffer', {})
B.map('<leader>qt', 'restore_hidden_tabs', {})
B.map('<leader>qo', 'append_one_proj_right_down', {})
B.map('<leader>qn', 'append_one_proj_new_tab', {})
B.map('<leader>qm', 'append_one_proj_new_tab_no_dupl', {})
B.map('<leader>q<leader>', 'simple_statusline_toggle', {})
B.map('<leader>q<cr>', 'toggle_tabs_way', {})

------

B.map('<leader>xL', 'bd_all_next_buf', {})
B.map('<leader>xH', 'bd_all_prev_buf', {})

B.map_reset_opts()

--------------------

B.aucmd(M.source, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    require(M.config).update_bufs_and_refresh_tabline(ev)
  end,
})

B.aucmd(M.source, 'WinResized', { 'WinResized', }, {
  callback = function()
    require(M.config).update_bufs_and_refresh_tabline(ev)
  end,
})

B.aucmd(M.source, 'DirChanged', { 'DirChanged', 'TabEnter', }, {
  callback = function()
    require(M.config).update_bufs_and_refresh_tabline(ev)
    pcall(vim.cmd, 'ProjectRootCD')
  end,
})

--------------------
-- dbakker/vim-projectroot
--------------------

vim.g.rootmarkers = {
  '.git',
}

B.aucmd('vim-projectroot', 'BufEnter', 'BufEnter', {
  callback = function(ev)
    require(M.config).projectroot_titlestring(ev)
  end,
})

return M
