local S = require 'my_simple'

-- local plugin = 'nvim-telescope/telescope.nvim',
local plugin = 'peter-lyr/telescope.nvim'
local map = 'telescope'

return {
  plugin,
  branch = '0.1.x',
  lazy = true,
  cmd = {
    'Telescope',
  },
  init = function()
    S.wkey('<leader>svv', plugin, map, 'more and more')
    S.wkey('<leader>sv', plugin, map, 'more')
    S.wkey('<leader>s', plugin, map)
    S.wkey('<leader>g', plugin, map, 'Git')
    S.wkey('<leader>f', plugin, map, 'lsp')
    S.wkey('<leader>gt', plugin, map, 'Git more')
    -- local mark = vim.api.nvim_buf_get_mark(0, '"')
    -- vim.api.nvim_input_mouse('left', 'press', '', 0, mark[1], mark[2])
  end,
  config = function()
    S.load_require(plugin, 'map.' .. map)
  end,
}
