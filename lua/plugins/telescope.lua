local S = require 'startup'

-- local plugin = 'nvim-telescope/telescope.nvim',
local plugin = 'peter-lyr/telescope.nvim'
local map = 'Telescope'

return {
  plugin,
  branch = '0.1.x',
  lazy = true,
  cmd = {
    'Telescope',
  },
  init = function()
    if not S.enable then
      require 'my_simple'.wkey('<leader>s', plugin, map)
      require 'my_simple'.wkey('<leader>f', plugin, map, 'Lsp')
      require 'my_simple'.wkey('<leader>g', plugin, map, 'Git')
    end
    -- local mark = vim.api.nvim_buf_get_mark(0, '"')
    -- vim.api.nvim_input_mouse('left', 'press', '', 0, mark[1], mark[2])
  end,
  config = function()
    require 'my_simple'.load_require(plugin, 'map.' .. map)
  end,
}
