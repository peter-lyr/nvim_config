local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

vim.keymap.set({ 'n', 'v', }, '<leader>vo', '<cmd>TortoiseSVN settings cur yes<cr>', { silent = true, desc = 'TortoiseSVN settings cur yes<cr>', })

vim.keymap.set({ 'n', 'v', }, '<leader>vd', '<cmd>TortoiseSVN diff cur yes<cr>', { silent = true, desc = 'TortoiseSVN diff cur yes<cr>', })
vim.keymap.set({ 'n', 'v', }, '<leader>vf', '<cmd>TortoiseSVN diff root yes<cr>', { silent = true, desc = 'TortoiseSVN diff root yes<cr>', })

vim.keymap.set({ 'n', 'v', }, '<leader>vb', '<cmd>TortoiseSVN blame cur yes<cr>', { silent = true, desc = 'TortoiseSVN blame cur yes<cr>', })

vim.keymap.set({ 'n', 'v', }, '<leader>vw', '<cmd>TortoiseSVN repobrowser cur yes<cr>', { silent = true, desc = 'TortoiseSVN repobrowser cur yes<cr>', })
vim.keymap.set({ 'n', 'v', }, '<leader>ve', '<cmd>TortoiseSVN repobrowser root yes<cr>', { silent = true, desc = 'TortoiseSVN repobrowser root yes<cr>', })

-- vim.keymap.set({ 'n', 'v', }, '<leader>vs', '<cmd>TortoiseSVN repostatus cur yes<cr>', { silent = true, desc = 'TortoiseSVN repostatus cur yes<cr>', })
-- vim.keymap.set({ 'n', 'v', }, '<leader>vS', '<cmd>TortoiseSVN repostatus root yes<cr>', { silent = true, desc = 'TortoiseSVN repostatus root yes<cr>', })
-- vim.keymap.set({ 'n', 'v', }, '<leader>vr', '<cmd>TortoiseSVN rename cur yes<cr>', { silent = true, desc = 'TortoiseSVN rename cur yes<cr>', })
-- vim.keymap.set({ 'n', 'v', }, '<leader>vR', '<cmd>TortoiseSVN remove cur yes<cr>', { silent = true, desc = 'TortoiseSVN remove cur yes<cr>', })
-- vim.keymap.set({ 'n', 'v', }, '<leader>vv', '<cmd>TortoiseSVN revert cur yes<cr>', { silent = true, desc = 'TortoiseSVN revert cur yes<cr>', })
-- vim.keymap.set({ 'n', 'v', }, '<leader>v<c-v>', '<cmd>TortoiseSVN revert root yes<cr>', { silent = true, desc = 'TortoiseSVN revert root yes<cr>', })
-- vim.keymap.set({ 'n', 'v', }, '<leader>va', '<cmd>TortoiseSVN add cur yes<cr>', { silent = true, desc = 'TortoiseSVN add cur yes<cr>', })
-- vim.keymap.set({ 'n', 'v', }, '<leader>vA', '<cmd>TortoiseSVN add root yes<cr>', { silent = true, desc = 'TortoiseSVN add root yes<cr>', })
-- vim.keymap.set({ 'n', 'v', }, '<leader>vc', '<cmd>TortoiseSVN commit cur yes<cr>', { silent = true, desc = 'TortoiseSVN commit cur yes<cr>', })

vim.keymap.set({ 'n', 'v', }, '<leader>va', '<cmd>TortoiseSVN commit root yes<cr>', { silent = true, desc = 'TortoiseSVN commit root yes<cr>', })

vim.keymap.set({ 'n', 'v', }, '<leader>vu', '<cmd>TortoiseSVN update root no<cr>', { silent = true, desc = 'TortoiseSVN update root no<cr>', })
vim.keymap.set({ 'n', 'v', }, '<leader>vi', '<cmd>TortoiseSVN update /rev root yes<cr>', { silent = true, desc = 'TortoiseSVN update /rev root yes<cr>', })

vim.keymap.set({ 'n', 'v', }, '<leader>vl', '<cmd>TortoiseSVN log cur yes<cr>', { silent = true, desc = 'TortoiseSVN log cur yes<cr>', })
vim.keymap.set({ 'n', 'v', }, '<leader>v;', '<cmd>TortoiseSVN log root yes<cr>', { silent = true, desc = 'TortoiseSVN log root yes<cr>', })

-- vim.keymap.set({ 'n', 'v', }, '<leader>vk', '<cmd>TortoiseSVN checkout root yes<cr>', { silent = true, desc = 'TortoiseSVN checkout root yes<cr>', })

vim.api.nvim_create_user_command('TortoiseSVN', function(params)
  require 'config.my_svn'.tortoisesvn(params['fargs'])
end, { nargs = '*', })

return M
