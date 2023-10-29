local S = require 'startup'

return {
  {
    'hrsh7th/nvim-cmp',
    lazy = true,
    version = false, -- last release is way too old
    ft = {
      'c', 'cpp',
      'lua',
      'markdown',
      'python',
    },
    config = function()
      require 'map.cmp'
    end,
  },
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    ft = {
      'c', 'cpp',
      'lua',
      'markdown',
      'python',
    },
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>f', 'neovim/nvim-lspconfig', 'Lsp')
        require 'my_simple'.add_whichkey('<leader>fv', plugin, 'Lsp', 'more')
      end
    end,
    config = function()
      require 'map.lsp'
    end,
  },
}
