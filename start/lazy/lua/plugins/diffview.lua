local S = require 'my_simple'
local f = 'config.diffview'

return {
  'sindrets/diffview.nvim',
  lazy = true,
  cmd = {
    'DiffviewClose',
    'DiffviewFileHistory',
    'DiffviewFocusFiles',
    'DiffviewLog',
    'DiffviewOpen',
    'DiffviewRefresh',
    'DiffviewToggleFiles',
  },
  -- dependencies = {
  --   'nvim-tree/nvim-web-devicons',
  --   'paopaol/telescope-git-diffs.nvim',
  --   require 'plugins.telescope',
  --   require 'plugins.plenary',
  --   require 'plugins.treesitter',
  --   require 'plugins.whichkey',
  -- },
  keys = {
    S.gkey('<leader>gv', '', f),
  },
  config = function()
    require(f)
    require 'telescope'.load_extension 'git_diffs'
  end,
}
