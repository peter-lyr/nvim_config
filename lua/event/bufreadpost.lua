local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

-- go to last loc when opening a buffer
B.aucmd(M.source, 'BufReadPost', 'BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

--------------------------

M.tab_4_fts = {
  'c', 'cpp',
  'python',
  'ld',
}

B.aucmd(M.source, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    if vim.fn.filereadable(ev.file) == 1 and vim.o.modifiable == true then
      vim.opt.cursorcolumn = true
      vim.opt.signcolumn   = 'auto:2'
    end
    if vim.tbl_contains(M.tab_4_fts, vim.opt.filetype:get()) == true then
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
    else
      vim.opt.tabstop = 2
      vim.opt.softtabstop = 2
      vim.opt.shiftwidth = 2
    end
  end,
})

return M
