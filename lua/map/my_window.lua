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

-- start
vim.keymap.set({ 'n', 'v', }, 'q<cr>', function() require 'config.my_window'.start_cur_executable() end, { silent = true, desc = 'system start cur executable file', })
vim.keymap.set({ 'n', 'v', }, 'q.', function() require 'config.my_window'.start_cur_dir() end, { silent = true, desc = 'q.', })
vim.keymap.set({ 'n', 'v', }, 'qw', function() require 'config.my_window'.start_cwd() end, { silent = true, desc = 'qw', })

vim.keymap.set({ 'n', 'v', }, '<leader>l', '<c-w>l', M.opt '<c-w>l')
vim.keymap.set({ 'n', 'v', }, '<leader>h', '<c-w>h', M.opt '<c-w>h')

vim.keymap.set({ 'n', 'v', }, '<leader>w<c-i>', function() require 'config.my_window'.copy_tab() end, M.opt 'copy_tab')
vim.keymap.set({ 'n', 'v', }, '<leader>w<c-h>', function() require 'config.my_window'.copy_left() end, M.opt 'copy_left')
vim.keymap.set({ 'n', 'v', }, '<leader>w<c-j>', function() require 'config.my_window'.copy_down() end, M.opt 'copy_down')
vim.keymap.set({ 'n', 'v', }, '<leader>w<c-k>', function() require 'config.my_window'.copy_up() end, M.opt 'copy_up')
vim.keymap.set({ 'n', 'v', }, '<leader>w<c-l>', function() require 'config.my_window'.copy_right() end, M.opt 'copy_right')
vim.keymap.set({ 'n', 'v', }, '<leader>w<a-i>', function() require 'config.my_window'.new_tab() end, M.opt 'new_tab')
vim.keymap.set({ 'n', 'v', }, '<leader>w<a-h>', function() require 'config.my_window'.new_left() end, M.opt 'new_left')
vim.keymap.set({ 'n', 'v', }, '<leader>w<a-j>', function() require 'config.my_window'.new_down() end, M.opt 'new_down')
vim.keymap.set({ 'n', 'v', }, '<leader>w<a-k>', function() require 'config.my_window'.new_up() end, M.opt 'new_up')
vim.keymap.set({ 'n', 'v', }, '<leader>w<a-l>', function() require 'config.my_window'.new_right() end, M.opt 'new_right')

vim.keymap.set({ 'n', 'v', }, '<leader>wh', function() require 'config.my_window'.change_around 'h' end, M.opt 'change_around')
vim.keymap.set({ 'n', 'v', }, '<leader>wj', function() require 'config.my_window'.change_around 'j' end, M.opt 'change_around')
vim.keymap.set({ 'n', 'v', }, '<leader>wk', function() require 'config.my_window'.change_around 'k' end, M.opt 'change_around')
vim.keymap.set({ 'n', 'v', }, '<leader>wl', function() require 'config.my_window'.change_around 'l' end, M.opt 'change_around')
vim.keymap.set({ 'n', 'v', }, '<leader>wL', function() require 'config.my_window'.change_around_last() end, M.opt 'change_around_last')
vim.keymap.set({ 'n', 'v', }, '<leader>w=', function() require 'config.my_window'.stack_cur() end, M.opt 'stack_cur')
vim.keymap.set({ 'n', 'v', }, '<leader>w+', function() require 'config.my_window'.stack_open_txt() end, M.opt 'stack_open_txt')
vim.keymap.set({ 'n', 'v', }, '<leader>w-', function() require 'config.my_window'.stack_open_sel() end, M.opt 'stack_open_sel')

vim.keymap.set({ 'n', 'v', }, '<leader>xh', function() require 'config.my_window'.close_win_left() end, M.opt 'close_win_left')
vim.keymap.set({ 'n', 'v', }, '<leader>xj', function() require 'config.my_window'.close_win_down() end, M.opt 'close_win_down')
vim.keymap.set({ 'n', 'v', }, '<leader>xk', function() require 'config.my_window'.close_win_up() end, M.opt 'close_win_up')
vim.keymap.set({ 'n', 'v', }, '<leader>xl', function() require 'config.my_window'.close_win_right() end, M.opt 'close_win_right')
vim.keymap.set({ 'n', 'v', }, '<leader>xt', function() require 'config.my_window'.close_cur_tab() end, M.opt 'close_cur_tab')

vim.keymap.set({ 'n', 'v', }, '<leader>xw', function() require 'config.my_window'.Bwipeout_cur() end, M.opt 'Bwipeout_cur')
vim.keymap.set({ 'n', 'v', }, '<leader>xW', function() require 'config.my_window'.bwipeout_cur() end, M.opt 'bwipeout_cur')
vim.keymap.set({ 'n', 'v', }, '<leader>xd', function() require 'config.my_window'.Bdelete_cur() end, M.opt 'Bdelete_cur')
vim.keymap.set({ 'n', 'v', }, '<leader>xD', function() require 'config.my_window'.bdelete_cur() end, M.opt 'bdelete_cur')

vim.keymap.set({ 'n', 'v', }, '<leader>xow', function() require 'config.my_window'.Bwipeout_other() end, M.opt 'Bwipeout_other')
vim.keymap.set({ 'n', 'v', }, '<leader>xoW', function() require 'config.my_window'.bwipeout_other() end, M.opt 'bwipeout_other')
vim.keymap.set({ 'n', 'v', }, '<leader>xod', function() require 'config.my_window'.Bdelete_other() end, M.opt 'Bdelete_other')
vim.keymap.set({ 'n', 'v', }, '<leader>xoD', function() require 'config.my_window'.bdelete_other() end, M.opt 'bdelete_other')

vim.keymap.set({ 'n', 'v', }, '<leader>xc', function() require 'config.my_window'.close_cur() end, M.opt 'close_cur')

vim.keymap.set({ 'n', 'v', }, '<leader>xp', function() require 'config.my_window'.bdelete_cur_proj() end, M.opt 'bdelete_cur_proj')
vim.keymap.set({ 'n', 'v', }, '<leader>xP', function() require 'config.my_window'.bwipeout_cur_proj() end, M.opt 'bwipeout_cur_proj')

vim.keymap.set({ 'n', 'v', }, '<leader>xop', function() require 'config.my_window'.bdelete_other_proj() end, M.opt 'bdelete_other_proj')
vim.keymap.set({ 'n', 'v', }, '<leader>xoP', function() require 'config.my_window'.bwipeout_other_proj() end, M.opt 'bwipeout_other_proj')

vim.keymap.set({ 'n', 'v', }, '<leader>x<del>', function() require 'config.my_window'.bwipeout_deleted() end, M.opt 'bwipeout_deleted')
vim.keymap.set({ 'n', 'v', }, '<leader>x<cr>', function() require 'config.my_window'.reopen_deleted() end, M.opt 'reopen_deleted')

-------

vim.keymap.set({ 'n', 'v', }, '<c-0><c-0>', function() require 'config.my_window'.fontsize_normal() end, M.opt 'fontsize_normal')
vim.keymap.set({ 'n', 'v', }, '<c-0>_', function() require 'config.my_window'.fontsize_min() end, M.opt 'fontsize_min')
vim.keymap.set({ 'n', 'v', }, '<c-0><c-->', function() require 'config.my_window'.fontsize_frameless() end, M.opt 'fontsize_frameless')
vim.keymap.set({ 'n', 'v', }, '<c-0><c-=>', function() require 'config.my_window'.fontsize_fullscreen() end, M.opt 'fontsize_fullscreen')
vim.keymap.set({ 'n', 'v', }, '<c-0><c-bs>', function() require 'config.my_window'.fontsize_frameless_toggle() end, M.opt 'fontsize_frameless_toggle')

return M
