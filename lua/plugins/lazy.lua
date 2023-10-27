local lazy = {
  'nvim-lua/plenary.nvim',
  'dstein64/vim-startuptime',
  'nvim-tree/nvim-web-devicons',
  'navarasu/onedark.nvim',
  -- nvimtree
  'dbakker/vim-projectroot',
  'peter-lyr/vim-bbye',
  -- treesitter
  'nvim-treesitter/nvim-treesitter-context',
  'p00f/nvim-ts-rainbow',
  'andymass/vim-matchup',
}

local new = {}
for _, l in ipairs(lazy) do
  new[#new + 1] = { l, lazy = true, }
end
return new
