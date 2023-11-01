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
      require 'map.nvim_cmp'
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
    dependencies = {
      {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        event = 'LspAttach',
        opts = {
        },
      },
    },
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>f', 'neovim/nvim-lspconfig', 'Nvim_Lsp')
        require 'my_simple'.add_whichkey('<leader>fv', 'neovim/nvim-lspconfig', 'Nvim_Lsp', 'more')
      end
    end,
    config = function()
      require 'map.nvim_lsp'
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = true,
    version = '*', -- last release
    build = ':TSUpdate',
    ft = {
      'c', 'cpp',
      'python',
      'lua',
      'markdown',
    },
    config = function()
      require 'map.nvim_treesitter'
    end,
  },
}
