local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

B.load_require 'dbakker/vim-projectroot'

function M.opt(desc)
  return { silent = true, desc = M.lua .. ' ' .. desc, }
end

vim.keymap.set({ 'n', 'v', }, '<leader>mu', function() require 'config.my_drag'.update 'cur' end, M.opt 'update')
vim.keymap.set({ 'n', 'v', }, '<leader>mU', function() require 'config.my_drag'.update 'cwd' end, M.opt 'update')
vim.keymap.set({ 'n', 'v', }, '<leader>mv', function() require 'config.my_drag'.paste 'jpg' end, M.opt 'paste')
vim.keymap.set({ 'n', 'v', }, '<leader>mV', function() require 'config.my_drag'.paste 'png' end, M.opt 'paste')
vim.keymap.set({ 'n', 'v', }, '<leader>my', function() require 'config.my_drag'.copy_text() end, M.opt 'copy_text')
vim.keymap.set({ 'n', 'v', }, '<leader>mY', function() require 'config.my_drag'.copy_file() end, M.opt 'copy_file')
vim.keymap.set({ 'n', 'v', }, '<s-f11>', function() require 'config.my_drag'.copy_file() end, M.opt 'copy_file')
vim.keymap.set({ 'n', 'v', }, '<leader>mE', function() require 'config.my_drag'.edit_drag_bin_fts_md() end, M.opt 'edit_drag_bin_fts_md')

----------------

B.aucmd(M.source, 'BufReadPre', { 'BufReadPre', }, {
  callback = function(ev)
    require('config.my_drag').readpre_min(ev)
  end,
})

B.aucmd(M.source, 'BufReadPost', { 'BufReadPost', }, {
  callback = function()
    require('config.my_drag').readpost()
  end,
})

B.aucmd(M.source, 'BufEnter', { 'BufEnter', }, {
  callback = function(ev)
    require('config.my_drag').bufenter(ev)
  end,
})

return M
