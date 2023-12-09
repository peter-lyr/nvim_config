local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

require 'notify'.setup {
  top_down = false,
  timeout = 3000,
  max_height = function()
    return math.floor(vim.o.lines * 0.75)
  end,
  max_width = function()
    return math.floor(vim.o.columns * 0.75)
  end,
}

vim.notify = require 'notify'

function M.sel_go_win(last)
  M.winids = {}
  for winnr = 1, vim.fn.winnr '$' do
    local winid = vim.fn.win_getid(winnr)
    if vim.api.nvim_win_is_valid(winid) == true then
      table.insert(M.winids, 1, tostring(winid) .. ': ' .. vim.api.nvim_buf_get_name(vim.fn.winbufnr(winnr)))
    end
  end
  if last then
    local winid = string.match(M.winids[1], '(%d+):')
    B.cmd('call win_gotoid(%s)', winid)
    return
  end
  B.ui_sel(M.winids, 'goto winid', function(winid)
    winid = string.match(winid, '(%d+):')
    B.set_timeout(200, function()
      B.cmd('call win_gotoid(%s)', winid)
    end)
  end)
end

return M
