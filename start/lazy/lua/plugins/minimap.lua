return {
  'peter-lyr/minimap.vim',
  -- 'wfxr/minimap.vim',
  lazy = true,
  event = { 'BufReadPost', 'BufNewFile', },
  cmd = { 'Minimap', 'MinimapToggle', },
  keys = {
    { '<leader>am', function() require 'config.minimap'.open() end,  mode = { 'n', 'v', }, silent = true, desc = 'Minimap', },
    { '<leader>aM', function() require 'config.minimap'.close() end, mode = { 'n', 'v', }, silent = true, desc = 'MinimapClose', },
  },
  dependencies = {
    'wfxr/code-minimap',
    require 'plugins.whichkey',
  },
  init = function()
    require 'which-key'.register { ['<leader>a'] = { name = 'Side Panel', }, }
    vim.g.minimap_width = 10
    vim.g.minimap_block_filetypes = { 'NvimTree', 'help', 'fugitive', }
    vim.g.minimap_block_buftypes = { 'quickfix', 'prompt', }
    vim.g.minimap_background_processing = 1
  end,
  config = function()
    require 'config.minimap'
  end,
}
