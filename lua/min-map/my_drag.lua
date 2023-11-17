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

vim.keymap.set({ 'n', 'v', }, '<leader>mE', function() require 'config.my_drag'.edit_drag_bin_fts_md() end, M.opt 'edit_drag_bin_fts_md')
vim.keymap.set({ 'n', }, '<esc>', function() require 'notify'.dismiss() end, M.opt 'dismiss notification')
vim.keymap.set({ 'n', 'v', }, 'c.', function() vim.cmd 'cd %:h' end, M.opt 'cd %:h')
vim.keymap.set({ 'n', 'v', }, '<leader><leader>', function() vim.cmd 'WhichKey' end, M.opt 'WhichKey')
vim.keymap.set({ 'n', 'v', }, '<c-l>', function() B.notify_info(vim.fn.execute 'ls') end, M.opt 'ls')
vim.keymap.set({ 'n', 'v', }, '<c-;>', function() B.notify_info(vim.fn.execute 'ls!') end, M.opt 'ls!')
vim.keymap.set({ 'n', 'v', }, '<cr>', function() if vim.v.count ~= 0 then pcall(B.cmd, 'b%d', vim.v.count) end end, M.opt 'buffer v:count')
vim.keymap.set({ 'n', 'v', }, '<leader>xc', function() vim.cmd 'quit' end, M.opt 'quit')
vim.keymap.set({ 'n', }, '<leader>;', function() vim.cmd [[call feedkeys(":")]] end, M.opt ':')
vim.keymap.set({ 'v', }, '<leader>;', function() vim.cmd [[call feedkeys("\<esc>:")]] end, M.opt ':')
vim.keymap.set({ 'n', 'v', }, '<c-h>', function()
  require 'notify'.dismiss()
  local bufs = vim.api.nvim_list_bufs()
  local index = B.index_of(bufs, vim.fn.bufnr())
  if index > 1 then
    index = index - 1
  else
    index = #bufs
  end
  B.cmd('b%d', bufs[index])
  B.print(string.format('%d/%d. %s', index, #bufs, vim.api.nvim_buf_get_name(bufs[index])))
end, M.opt 'prev buf')
vim.keymap.set({ 'n', 'v', }, '<c-j>', function()
  require 'notify'.dismiss()
  local bufs = vim.api.nvim_list_bufs()
  local index = B.index_of(bufs, vim.fn.bufnr())
  if index < #bufs then
    index = index + 1
  else
    index = 1
  end
  B.cmd('b%d', bufs[index])
  B.print(string.format('%d/%d. %s', index, #bufs, vim.api.nvim_buf_get_name(bufs[index])))
end, M.opt 'prev buf')

----------------

B.aucmd(M.source, 'BufReadPre', { 'BufReadPre', }, {
  callback = function(ev)
    require 'config.my_drag'.readpre_min(ev)
  end,
})

B.aucmd(M.source, 'BufReadPost', { 'BufReadPost', }, {
  callback = function()
    require 'config.my_drag'.readpost()
  end,
})

B.aucmd(M.source, 'BufEnter', { 'BufEnter', }, {
  callback = function(ev)
    require 'config.my_drag'.bufenter(ev)
  end,
})

----------------

vim.g.startuptime_tries = 10

vim.cmd.colorscheme 'onedark'

require 'which-key'.setup {}
require 'which-key'.register { ['<leader>m'] = { name = 'my_drag', }, }

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

return M
