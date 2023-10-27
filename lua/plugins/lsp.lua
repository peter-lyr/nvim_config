local S = require 'startup'

local plugin = 'neovim/nvim-lspconfig'
local map = 'Lsp'

return {
  plugin,
  lazy = true,
  ft = {
    'c', 'cpp',
    'lua',
    'markdown',
    'python',
  },
  init = function()
    if not S.enable then
      require 'my_simple'.add_whichkey('<leader>f', plugin, map)
      require 'my_simple'.add_whichkey('<leader>fv', plugin, map, 'more')
    end
  end,
  config = function()
    require 'my_simple'.load_require(plugin, 'map.' .. map)
  end,
}
