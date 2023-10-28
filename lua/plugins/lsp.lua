local S = require 'startup'

local plugin = 'neovim/nvim-lspconfig'

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
      require 'my_simple'.add_whichkey('<leader>f', plugin, 'Lsp')
      require 'my_simple'.add_whichkey('<leader>fv', plugin, 'Lsp', 'more')
    end
  end,
  config = function()
    require 'map.lsp'
  end,
}
