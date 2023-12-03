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

vim.keymap.set({ 'n', 'v', }, '<leader>af', function() require 'config.sidepanel_nvimtree'.findfile() end, M.opt 'findfile')
vim.keymap.set({ 'n', 'v', }, '<leader>ao', function() require 'config.sidepanel_nvimtree'.open() end, M.opt 'open')
vim.keymap.set({ 'n', 'v', }, '<leader>aO', function() require 'config.sidepanel_nvimtree'.restart() end, M.opt 'restart')
vim.keymap.set({ 'n', 'v', }, '<leader>ac', function() require 'config.sidepanel_nvimtree'.close() end, M.opt 'close')

vim.keymap.set({ 'n', 'v', }, '<leader>aj', function() require 'config.sidepanel_nvimtree'.findnext() end, M.opt 'findnext')
vim.keymap.set({ 'n', 'v', }, '<leader>ak', function() require 'config.sidepanel_nvimtree'.findprev() end, M.opt 'findprev')

vim.keymap.set({ 'n', 'v', }, '<leader>an', function() require 'config.sidepanel_nvimtree'.cd_opened_projs() end, M.opt 'cd_opened_projs')
vim.keymap.set({ 'n', 'v', }, '<leader>ay', function() require 'config.sidepanel_nvimtree'.cd_my_dirs() end, M.opt 'cd_my_dirs')
vim.keymap.set({ 'n', 'v', }, '<leader>aY', function() require 'config.sidepanel_nvimtree'.cd_my_dirs_first() end, M.opt 'cd_my_dirs_first')

vim.keymap.set({ 'n', 'v', }, '<leader>ag', function() require 'config.sidepanel_nvimtree'.cd_git_repos() end, M.opt 'cd_git_repos')
vim.keymap.set({ 'n', 'v', }, '<leader>aG', function() require 'config.sidepanel_nvimtree'.update_git_repos() end, M.opt 'update_git_repos')

---------------------------------

B.load_require 'nvim-lua/plenary.nvim'
B.load_require 'nvim-tree/nvim-web-devicons'

---------------------

B.aucmd(M.source, 'BufEnter', { 'BufEnter', 'DirChanged', 'CursorHold', }, {
  callback = function(ev)
    require 'config.sidepanel_nvimtree_map_basic'.ausize(ev)
  end,
})

return M
