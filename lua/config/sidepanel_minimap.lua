local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
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
  M.opened = 1
end

function M.close()
  minimap.close()
  M.opened = nil
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

M.waiting_for_aerial_leave = nil

B.aucmd(M.lua, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    local ft = vim.api.nvim_buf_get_option(ev.buf, 'filetype')
    if ft == 'minimap' then
      M.opened = 1
      vim.cmd 'setlocal signcolumn=no'
      vim.fn.timer_start(20, function()
        vim.keymap.set({ 'n', }, '<MiddleMouse>', function() M.close() end, { buffer = ev.buf, desc = 'MiniMap close', })
        vim.keymap.set({ 'v', }, '<MiddleMouse>', function() M.close() end, { buffer = ev.buf, desc = 'MiniMap close', })
        vim.keymap.set({ 'n', }, '<RightMouse>', function() M.esc(1) end, { buffer = ev.buf, desc = 'MiniMap esc', })
        vim.keymap.set({ 'v', }, '<RightMouse>', function() M.esc(2) end, { buffer = ev.buf, desc = 'MiniMap esc', })
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
    elseif ft == 'aerial' then
      if M.opened then
        M.waiting_for_aerial_leave = 1
        M.close()
      end
    end
  end,
})

B.aucmd(M.lua, 'BufLeave', 'BufLeave', {
  callback = function(ev)
    local ft = vim.api.nvim_buf_get_option(ev.buf, 'filetype')
    if ft == 'aerial' then
      if M.waiting_for_aerial_leave then
        M.waiting_for_aerial_leave = nil
        M.open()
      end
    end
  end,
})

return M
