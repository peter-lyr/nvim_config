local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.opt(desc)
  return { silent = true, desc = M.lua .. ' ' .. desc, }
end

vim.keymap.set({ 'n', 'v', }, '<c-l>', function() require 'config.my_tabline'.b_next_buf() end, M.opt 'b_next_buf')
vim.keymap.set({ 'n', 'v', }, '<c-h>', function() require 'config.my_tabline'.b_prev_buf() end, M.opt 'b_prev_buf')

vim.keymap.set({ 'n', 'v', }, '<c-s-l>', function() require 'config.my_tabline'.bd_next_buf() end, M.opt 'bd_next_buf')
vim.keymap.set({ 'n', 'v', }, '<c-s-h>', function() require 'config.my_tabline'.bd_prev_buf() end, M.opt 'bd_prev_buf')

--------

vim.keymap.set({ 'n', 'v', }, '<leader>qw', function() require 'config.my_tabline'.only_cur_buffer() end, M.opt 'only_cur_buffer')
vim.keymap.set({ 'n', 'v', }, '<leader>qt', function() require 'config.my_tabline'.restore_hidden_tabs() end, M.opt 'restore_hidden_tabs')
vim.keymap.set({ 'n', 'v', }, '<leader>qd', function() require 'config.my_tabline'.append_one_proj_right_down() end, M.opt 'append_one_proj_right_down')
vim.keymap.set({ 'n', 'v', }, '<leader>qn', function() require 'config.my_tabline'.append_one_proj_new_tab() end, M.opt 'append_one_proj_new_tab')
vim.keymap.set({ 'n', 'v', }, '<leader>qm', function() require 'config.my_tabline'.append_one_proj_new_tab_no_dupl() end, M.opt 'append_one_proj_new_tab_no_dupl')
vim.keymap.set({ 'n', 'v', }, '<leader>q<leader>', function() require 'config.my_tabline'.simple_statusline_toggle() end, M.opt 'simple_statusline_toggle')
vim.keymap.set({ 'n', 'v', }, '<leader>q<cr>', function() require 'config.my_tabline'.toggle_tabs_way() end, M.opt 'toggle_tabs_way')
vim.keymap.set({ 'n', 'v', }, '<leader>qu', function() require 'config.my_tabline'.append_unload_right_down() end, M.opt 'append_unload_right_down')

------

vim.keymap.set({ 'n', 'v', }, '<leader>xL', function() require 'config.my_tabline'.bd_all_next_buf() end, M.opt 'bd_all_next_buf')
vim.keymap.set({ 'n', 'v', }, '<leader>xH', function() require 'config.my_tabline'.bd_all_prev_buf() end, M.opt 'bd_all_prev_buf')

B.register_whichkey('config.my_tabline', '<leader>xo', 'kill other')

B.merge_whichkeys()

--------------------

B.aucmd(M.source, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    require('config.my_tabline').update_bufs_and_refresh_tabline(ev)
  end,
})

B.aucmd(M.source, 'WinResized', { 'WinResized', }, {
  callback = function()
    require('config.my_tabline').update_bufs_and_refresh_tabline(ev)
  end,
})

B.aucmd(M.source, 'DirChanged', { 'DirChanged', 'TabEnter', }, {
  callback = function()
    require('config.my_tabline').update_bufs_and_refresh_tabline(ev)
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
    require('config.my_tabline').projectroot_titlestring(ev)
  end,
})

---------

B.load_require 'dbakker/vim-projectroot'
B.load_require 'peter-lyr/vim-bbye'

return M
