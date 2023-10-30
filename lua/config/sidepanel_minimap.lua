local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

M.width = 25

local minimap = require 'mini.map'

local symbols = minimap.gen_encode_symbols.dot '4x2'
symbols[1] = ' '

minimap.setup {
  integrations = {
    minimap.gen_integration.builtin_search(),
    minimap.gen_integration.gitsigns(),
    minimap.gen_integration.diagnostic(),
  },
  symbols = {
    encode = symbols,
    -- scroll_line = '█',
    -- scroll_view = '░',
    -- scroll_line = '󰨊',
    -- scroll_view = '│',
    scroll_line = '█',
    scroll_view = '┃',
  },
  window = {
    focusable = true,
    side = 'right',
    show_integration_count = true,
    width = M.width,
    winblend = 20,
  },
}

function M.open()
  minimap.open()
  M.auto_open_en = 1
  M.opened = 1
end

function M.close()
  minimap.close()
  M.auto_open_en = nil
  M.opened = nil
end

function M.auto_open()
  M.auto_open_en = 1
end

function M.toggle_focus()
  minimap.toggle_focus()
end

function M.cr(cnt)
  for _ = 1, cnt do
    vim.cmd [[call feedkeys("\<cr>")]]
  end
end

function M.esc(cnt)
  for _ = 1, cnt do
    vim.cmd [[call feedkeys("\<esc>")]]
  end
end

function M.up()
  vim.cmd [[call feedkeys("\<up>")]]
end

function M.down()
  vim.cmd [[call feedkeys("\<down>")]]
end

B.aucmd(M.source, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    if vim.api.nvim_buf_get_option(ev.buf, 'filetype') == 'minimap' then
      vim.cmd 'setlocal signcolumn=no'
      vim.fn.timer_start(20, function()
        vim.keymap.set({ 'n', }, '<MiddleMouse>', function() M.esc(1) end, { buffer = ev.buf, desc = 'MiniMap esc', })
        vim.keymap.set({ 'v', }, '<MiddleMouse>', function() M.esc(2) end, { buffer = ev.buf, desc = 'MiniMap esc', })
        vim.keymap.set({ 'n', }, 'q', function() M.esc(1) end, { buffer = ev.buf, desc = 'MiniMap esc', })
        vim.keymap.set({ 'v', }, 'q', function() M.esc(2) end, { buffer = ev.buf, desc = 'MiniMap esc', })
        vim.keymap.set({ 'n', }, '`', function() M.esc(1) end, { buffer = ev.buf, desc = 'MiniMap esc', })
        vim.keymap.set({ 'v', }, '`', function() M.esc(2) end, { buffer = ev.buf, desc = 'MiniMap esc', })
        vim.keymap.set({ 'n', }, '<2-LeftMouse>', function() M.cr(1) end, { buffer = ev.buf, desc = 'MiniMap cr', })
        vim.keymap.set({ 'v', }, '<2-LeftMouse>', function() M.cr(2) end, { buffer = ev.buf, desc = 'MiniMap cr', })
        vim.keymap.set({ 'n', }, '<tab>', function() M.cr(1) end, { buffer = ev.buf, desc = 'MiniMap cr', })
        vim.keymap.set({ 'v', }, '<tab>', function() M.cr(2) end, { buffer = ev.buf, desc = 'MiniMap cr', })
        vim.keymap.set({ 'n', }, 'a', function() M.cr(1) end, { buffer = ev.buf, desc = 'MiniMap cr', })
        vim.keymap.set({ 'v', }, 'a', function() M.cr(2) end, { buffer = ev.buf, desc = 'MiniMap cr', })
        vim.keymap.set({ 'n', 'v', }, '<ScrollWheelUp>', function() M.up() end, { buffer = ev.buf, desc = 'MiniMap up', })
        vim.keymap.set({ 'n', 'v', }, '<ScrollWheelDown>', function() M.down() end, { buffer = ev.buf, desc = 'MiniMap down', })
      end)
    end
  end,
})

return M