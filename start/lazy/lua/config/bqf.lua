local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
package.loaded[B.get_loaded(M.source)] = nil
--------------------------------------------

M.bqf = require 'bqf'

M.percent = 50

function M.hi()
  vim.cmd [[
    hi BqfPreviewBorder guifg=#50a14f ctermfg=71
    hi link BqfPreviewRange Search
  ]]
end

M.hi()

B.aucmd(M.source, 'BufEnter', { 'BufEnter', }, {
  callback = function()
    if vim.bo.ft == 'qf' then
      local floatwin = require 'bqf.preview.floatwin'
      floatwin.defaultHeight = vim.fn.float2nr(vim.o.lines * M.percent / 100 - 3)
      floatwin.defaultVHeight = vim.fn.float2nr(vim.o.lines * M.percent / 100 - 3)
    end
  end,
})

B.aucmd(M.source, 'ColorScheme', { 'ColorScheme', }, {
  callback = function()
    M.hi()
  end,
})

M.bqf.setup {
  auto_resize_height = true,
  preview = {
    win_height = vim.fn.float2nr(vim.o.lines * M.percent / 100 - 3),
    win_vheight = vim.fn.float2nr(vim.o.lines * M.percent / 100 - 3),
    wrap = true,
  },
}

return M
