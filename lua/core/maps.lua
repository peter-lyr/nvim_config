-- -- go cmdline
vim.keymap.set({ 'n', 'v', }, '<leader>;', ':', { silent = false, desc = 'go cmdline', })

vim.api.nvim_create_user_command('Run', function(params)
  require 'my_base'.system_run('asyncrun', vim.fn.join(params['fargs'], ' '))
end, { nargs = '*', })

vim.keymap.set({ 'n', 'v', }, '<leader>\'', ':Run ', { silent = false, desc = 'go cmdline :AsyncRun', })

-- record
vim.keymap.set({ 'n', 'v', }, 'q', '<cmd>WhichKey q<cr>', { silent = true, desc = 'nop', })
vim.keymap.set({ 'n', 'v', }, 'Q', 'q', { silent = true, desc = 'record', })

-- c.
vim.keymap.set({ 'n', 'v', }, 'c.', '<cmd>cd %:h<cr>', { silent = true, desc = 'c.', })

-- undo
vim.keymap.set({ 'n', }, 'U', '<c-r>', { silent = true, desc = 'redo', })

-- scroll horizontally
vim.keymap.set({ 'n', 'v', }, '<S-ScrollWheelDown>', '10zl', { silent = false, desc = 'scroll right horizontally', })
vim.keymap.set({ 'n', 'v', }, '<S-ScrollWheelUp>', '10zh', { silent = false, desc = 'scroll left horizontally', })

-- f5
vim.keymap.set({ 'n', 'v', }, '<f5>', '<cmd>e!<cr>', { silent = true, desc = 'e!', })
vim.keymap.set({ 'n', 'v', }, 'qq', '<cmd>e!<cr>', { silent = true, desc = 'e!', })

-- cursor
vim.keymap.set({ 'n', 'v', }, '<c-j>', '5j', { silent = true, desc = '5j', })
vim.keymap.set({ 'n', 'v', }, '<c-k>', '5k', { silent = true, desc = '5k', })

-- copy_paste
vim.keymap.set({ 'n', 'v', }, '<a-y>', '"+y', { silent = true, desc = '"+y', })
vim.keymap.set({ 'n', }, 'yii', '"+yi', { silent = true, desc = '"+yi', })
vim.keymap.set({ 'n', }, 'yaa', '"+ya', { silent = true, desc = '"+ya', })
vim.keymap.set({ 'n', 'v', }, '<a-d>', '"+d', { silent = true, desc = '"+d', })
vim.keymap.set({ 'n', }, 'dii', '"+di', { silent = true, desc = '"+di', })
vim.keymap.set({ 'n', }, 'daa', '"+da', { silent = true, desc = '"+da', })
vim.keymap.set({ 'n', 'v', }, '<a-c>', '"+c', { silent = true, desc = '"+c', })
vim.keymap.set({ 'n', }, 'cii', '"+ci', { silent = true, desc = '"+ci', })
vim.keymap.set({ 'n', }, 'caa', '"+ca', { silent = true, desc = '"+ca', })
vim.keymap.set({ 'n', 'v', }, '<a-p>', '"+p', { silent = true, desc = '"+p', })
vim.keymap.set({ 'n', 'v', }, '<a-s-p>', '"+P', { silent = true, desc = '"+P', })

-- for youdao dict
vim.keymap.set({ 'v', }, '<c-c>', '"+y', { silent = true, desc = '"+y', })

vim.cmd [[
cab xpx sort
cab xqc g/^\(.*\)$\n\1$/d
cab xpq sort\|g/^\(.*\)$\n\1$/d
]]
