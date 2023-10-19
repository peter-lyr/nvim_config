local M = {}

package.loaded['config.minimap'] = nil

vim.cmd 'Lazy load aerial.nvim'

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

M.auto_open_en = nil
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
    if M.auto_open_en and vim.fn.filereadable(ev.file) == 1 then
      if not M.opened then
        minimap.open()
      end
    end
    if vim.api.nvim_buf_get_option(ev.buf, 'filetype') == 'minimap' then
      vim.fn.timer_start(20, function()
        if vim.fn.getcurpos()[5] > 3 and (vim.fn.trim(vim.fn.execute 'norm g8') == '20') == true then
          if require 'config.aerial'.opened then
            vim.cmd 'wincmd p'
            vim.cmd 'AerialCloseAll'
            require 'aerial'.setup {
              layout = {
                max_width = M.width * 2 + 2,
                min_width = M.width * 2 + 2,
              },
            }
            vim.cmd 'AerialOpen right'
          end
        else
          vim.keymap.set({ 'n', }, '<MiddleMouse>', function() esc(1) end, { buffer = ev.buf, desc = 'MiniMap esc', })
          vim.keymap.set({ 'v', }, '<MiddleMouse>', function() esc(2) end, { buffer = ev.buf, desc = 'MiniMap esc', })
          vim.keymap.set({ 'n', }, 'q', function() esc(1) end, { buffer = ev.buf, desc = 'MiniMap esc', })
          vim.keymap.set({ 'v', }, 'q', function() esc(2) end, { buffer = ev.buf, desc = 'MiniMap esc', })
          vim.keymap.set({ 'n', }, '<2-LeftMouse>', function() cr(1) end, { buffer = ev.buf, desc = 'MiniMap cr', })
          vim.keymap.set({ 'v', }, '<2-LeftMouse>', function() cr(2) end, { buffer = ev.buf, desc = 'MiniMap cr', })
          vim.keymap.set({ 'n', 'v', }, '<ScrollWheelUp>', function() up() end, { buffer = ev.buf, desc = 'MiniMap up', })
          vim.keymap.set({ 'n', 'v', }, '<ScrollWheelDown>', function() down() end, { buffer = ev.buf, desc = 'MiniMap down', })
        end
      end)
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
