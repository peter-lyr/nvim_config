local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.map_set_lua(M.config)

B.map('<leader>w<c-i>', 'copy_tab', {})
B.map('<leader>w<c-h>', 'copy_left', {})
B.map('<leader>w<c-j>', 'copy_down', {})
B.map('<leader>w<c-k>', 'copy_up', {})
B.map('<leader>w<c-l>', 'copy_right', {})
B.map('<leader>w<a-i>', 'new_tab', {})
B.map('<leader>w<a-h>', 'new_left', {})
B.map('<leader>w<a-j>', 'new_down', {})
B.map('<leader>w<a-k>', 'new_up', {})
B.map('<leader>w<a-l>', 'new_right', {})

B.map('<leader>wh', 'change_around', { 'h', })
B.map('<leader>wj', 'change_around', { 'j', })
B.map('<leader>wk', 'change_around', { 'k', })
B.map('<leader>wl', 'change_around', { 'l', })
B.map('<leader>wL', 'change_around_last', {})
B.map('<leader>w=', 'stack_cur', {})
B.map('<leader>w+', 'stack_open_txt', {})
B.map('<leader>w-', 'stack_open_sel', {})

B.map('<leader>xh', 'close_win_left', {})
B.map('<leader>xj', 'close_win_down', {})
B.map('<leader>xk', 'close_win_up', {})
B.map('<leader>xl', 'close_win_right', {})
B.map('<leader>xt', 'close_cur_tab', {})

B.map('<leader>xw', 'Bwipeout_cur', {})
B.map('<leader>xW', 'bwipeout_cur', {})
B.map('<leader>xd', 'Bdelete_cur', {})
B.map('<leader>xD', 'bdelete_cur', {})

B.map('<leader>xc', 'close_cur', {})

B.map('<leader>xp', 'bdelete_cur_proj', {})
B.map('<leader>xP', 'bwipeout_cur_proj', {})
B.map('<leader>xo', 'bdelete_other_proj', {})
B.map('<leader>xO', 'bwipeout_other_proj', {})

B.map('<leader>x<del>', 'bwipeout_deleted', {})
B.map('<leader>x<cr>', 'reopen_deleted', {})

-------

B.map('<c-0><c-0>', 'fontsize_normal', {})
B.map('<c-0>_', 'fontsize_min', {})
B.map('<c-0><c-->', 'fontsize_frameless', {})
B.map('<c-0><c-=>', 'fontsize_fullscreen', {})
B.map('<c-0><c-bs>', 'fontsize_frameless_toggle', {})

return M
