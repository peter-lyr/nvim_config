local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------


B.load_require 'nvim-lua/plenary.nvim'
B.load_require 'nvim-tree/nvim-web-devicons'
B.load_require 'paopaol/telescope-git-diffs.nvim'

require 'map.telescope'

---------------

function M.opt(desc)
  return { silent = true, desc = M.lua .. ' ' .. desc, }
end

vim.keymap.set({ 'n', 'v', }, '<leader>gv1', function() require 'config.git_diffview'.filehistory '16' end, M.opt 'filehistory')
vim.keymap.set({ 'n', 'v', }, '<leader>gv2', function() require 'config.git_diffview'.filehistory '64' end, M.opt 'filehistory')
vim.keymap.set({ 'n', 'v', }, '<leader>gv3', function() require 'config.git_diffview'.filehistory 'finite' end, M.opt 'filehistory')
vim.keymap.set({ 'n', 'v', }, '<leader>gvs', function() require 'config.git_diffview'.filehistory 'stash' end, M.opt 'filehistory')
vim.keymap.set({ 'n', 'v', }, '<leader>gvb', function() require 'config.@git_diffview'.filehistory 'base' end, M.opt 'filehistory')
vim.keymap.set({ 'n', 'v', }, '<leader>gvr', function() require 'config.git_diffview'.filehistory 'range' end, M.opt 'filehistory')
vim.keymap.set({ 'n', 'v', }, '<leader>gvo', function() require 'config.git_diffview'.open() end, M.opt 'open')
vim.keymap.set({ 'n', 'v', }, '<leader>gvl', function() require 'config.git_diffview'.refresh() end, M.opt 'refresh')
vim.keymap.set({ 'n', 'v', }, '<leader>gvq', function() require 'config.git_diffview'.close() end, M.opt 'close')
vim.keymap.set({ 'n', 'v', }, '<leader>gvw', function() require 'config.git_diffview'.diff_commits() end, M.opt 'diff_commits')

--------------

B.register_whichkey('config.git_diffview', '<leader>gv', 'Diffview')
B.merge_whichkeys()

------

require 'telescope'.load_extension 'git_diffs'

----------

B.aucmd(M.lua, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    require 'config.git_diffview'.number(ev)
  end,
})

------

return M
