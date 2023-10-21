local M = {}
local B = require 'my_base'
M.source = debug.getinfo(1)['source']
package.loaded[B.get_loaded(M.source)] = nil
--------------------------------------------

local bqf = require 'bqf'

local hi = function()
  vim.cmd [[
    hi BqfPreviewBorder guifg=#50a14f ctermfg=71
    hi link BqfPreviewRange Search
  ]]
end

hi()

local percent = 50

pcall(vim.api.nvim_del_autocmd, vim.g.bqf_au_bufenter)

vim.g.bqf_au_bufenter = vim.api.nvim_create_autocmd({ 'BufEnter', }, {
  callback = function()
    if vim.bo.ft == 'qf' then
      local floatwin = require 'bqf.preview.floatwin'
      floatwin.defaultHeight = vim.fn.float2nr(vim.o.lines * percent / 100 - 3)
      floatwin.defaultVHeight = vim.fn.float2nr(vim.o.lines * percent / 100 - 3)
    end
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.bqf_au_colorscheme)

vim.g.bqf_au_colorscheme = vim.api.nvim_create_autocmd({ 'ColorScheme', }, {
  callback = function()
    hi()
  end,
})

bqf.setup {
  auto_resize_height = true,
  preview = {
    win_height = vim.fn.float2nr(vim.o.lines * percent / 100 - 3),
    win_vheight = vim.fn.float2nr(vim.o.lines * percent / 100 - 3),
    wrap = true,
  },
}

return M
