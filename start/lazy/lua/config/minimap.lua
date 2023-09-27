local M = {}

package.loaded['config.minimap'] = nil

local minimap = require 'mini.map'

minimap.setup {
  integrations = {
    minimap.gen_integration.builtin_search(),
    minimap.gen_integration.gitsigns(),
    minimap.gen_integration.diagnostic(),
  },
  symbols = {
    encode = minimap.gen_encode_symbols.dot '4x2',
    -- scroll_line = '█',
    -- scroll_view = '░',
    scroll_line = '󰨊',
    scroll_view = '│',
  },
  window = {
    focusable = true,
    side = 'right',
    show_integration_count = true,
    width = 12,
    winblend = 90,
  },
}

M.auto_open_en = 1
M.opened = nil

local function cr(cnt)
  for _ = 1, cnt do
    vim.cmd [[call feedkeys("\<cr>")]]
  end
end

local function esc(cnt)
  for _ = 1, cnt do
    vim.cmd [[call feedkeys("\<esc>")]]
  end
end

local function up()
  vim.cmd [[call feedkeys("\<up>")]]
end

local function down()
  vim.cmd [[call feedkeys("\<down>")]]
end

pcall(vim.api.nvim_del_autocmd, vim.g.minimap_au_bufenter)

vim.g.minimap_au_bufenter = vim.api.nvim_create_autocmd('BufEnter', {
  callback = function(ev)
    if M.auto_open_en and vim.api.nvim_buf_get_option(ev.buf, 'filetype') ~= 'minimap' then
      if not M.opened then
        minimap.open()
      end
    end
    if vim.api.nvim_buf_get_option(ev.buf, 'filetype') == 'minimap' then
      vim.keymap.set({ 'n', }, '<MiddleMouse>', function() esc(1) end, { buffer = ev.buf, desc = 'MiniMap esc', })
      vim.keymap.set({ 'v', }, '<MiddleMouse>', function() esc(2) end, { buffer = ev.buf, desc = 'MiniMap esc', })
      vim.keymap.set({ 'n', }, '<2-LeftMouse>', function() cr(1) end, { buffer = ev.buf, desc = 'MiniMap cr', })
      vim.keymap.set({ 'v', }, '<2-LeftMouse>', function() cr(2) end, { buffer = ev.buf, desc = 'MiniMap cr', })
      vim.keymap.set({ 'n', 'v', }, '<ScrollWheelUp>', function() up() end, { buffer = ev.buf, desc = 'MiniMap up', })
      vim.keymap.set({ 'n', 'v', }, '<ScrollWheelDown>', function() down() end, { buffer = ev.buf, desc = 'MiniMap down', })
    end
  end,
})

M.open = function()
  minimap.open()
  M.auto_open_en = 1
  M.opened = 1
end

M.close = function()
  minimap.close()
  M.auto_open_en = nil
  M.opened = nil
end

M.auto_open = function()
  M.auto_open_en = 1
end

M.toggle_focus = function()
  minimap.toggle_focus()
end

return M
