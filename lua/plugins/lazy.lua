local lazy = {
  'dstein64/vim-startuptime',
  'navarasu/onedark.nvim',
  'nvim-lua/plenary.nvim',
  'nvim-tree/nvim-web-devicons',
  -- nvimtree
  'dbakker/vim-projectroot',
  'peter-lyr/vim-bbye',
  -- treesitter
  'andymass/vim-matchup',
  'nvim-treesitter/nvim-treesitter-context',
  'p00f/nvim-ts-rainbow',
  -- lsp
  'folke/neodev.nvim',
  'jay-babu/mason-null-ls.nvim',
  'jose-elias-alvarez/null-ls.nvim',
  'smjonas/inc-rename.nvim',
  'williamboman/mason-lspconfig.nvim',
  'williamboman/mason.nvim',
  --
  'LazyVim/LazyVim',
  ----
  'L3MON4D3/LuaSnip',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-path',
  'rafamadriz/friendly-snippets',
  'saadparwaiz1/cmp_luasnip',
  ----
  'paopaol/telescope-git-diffs.nvim',
  --------
  'skywind3000/asyncrun.vim',
  --------
  'nvim-telescope/telescope-ui-select.nvim',
  'ahmedkhalf/project.nvim',
  'peter-lyr/sha2',
}


local new = {}
for _, l in ipairs(lazy) do
  new[#new + 1] = { l, lazy = true, }
end
return new
