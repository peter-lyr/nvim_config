local M = {}

local minimap = require 'mini.map'

minimap.setup {
  integrations = {
    minimap.gen_integration.builtin_search(),
    minimap.gen_integration.gitsigns(),
    minimap.gen_integration.diagnostic(),
  },
  symbols = {
    encode = minimap.gen_encode_symbols.dot '4x2',
    scroll_line = '█',
    scroll_view = '│',
  },
  window = {
    focusable = true,
    side = 'right',
    show_integration_count = true,
    width = 12,
    winblend = 25,
  },
}

M.auto_open = nil

pcall(vim.api.nvim_del_autocmd, vim.g.minimap_au_bufenter)

vim.g.minimap_au_bufenter = vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    if M.auto_open then
      minimap.open()
    end
  end,
})

M.open = function()
  minimap.open()
  M.auto_open = 1
end

M.close = function()
  minimap.close()
  M.auto_open = nil
end

M.toggle_focus = function()
  minimap.toggle_focus()
end

return M
