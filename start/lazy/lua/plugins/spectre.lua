return {
  'nvim-pack/nvim-spectre',
  lazy = true,
  keys = {
    { '<leader>re', function() require 'spectre'.open() end,                                   mode = { 'n', 'v', }, silent = true, desc = 'Open Spectre', },
    { '<leader>rs', function() require 'spectre'.open_visual { select_word = true, } end,      mode = { 'n', },      silent = true, desc = 'Search current word', },
    { '<leader>rs', function() require 'spectre'.open_visual() end,                            mode = { 'v', },      silent = true, desc = 'Search current word', },
    { '<leader>rc', function() require 'spectre'.open_file_search { select_word = true, } end, mode = { 'n', 'v', }, silent = true, desc = 'Search on current file', },
  },
  dependencies = {
    require 'plugins.whichkey',
  },
  init = function()
    require 'config.whichkey'.add { ['<leader>r'] = { name = 'Spectre', }, }
  end,
  config = function()
    require 'spectre'.setup()
  end,
}
