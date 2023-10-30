local S = require 'startup'

-- local plugin = 'nvim-telescope/telescope.nvim',
local plugin = 'peter-lyr/telescope.nvim'

return {
  plugin,
  branch = '0.1.x',
  lazy = true,
  cmd = {
    'Telescope',
  },
  init = function()
    if not S.load_whichkeys_txt_enable then
      require 'my_simple'.add_whichkey('<c-s-f12>', plugin, 'Telescope')
      require 'my_simple'.add_whichkey('<leader>s', plugin, 'Telescope')
      require 'my_simple'.add_whichkey('<leader>f', plugin, 'Telescope', 'Lsp')
      require 'my_simple'.add_whichkey('<leader>g', plugin, 'Telescope', 'Git')
    end
    -- local mark = vim.api.nvim_buf_get_mark(0, '"')
    -- vim.api.nvim_input_mouse('left', 'press', '', 0, mark[1], mark[2])
  end,
  config = function()
    require 'map.telescope'
  end,
}
