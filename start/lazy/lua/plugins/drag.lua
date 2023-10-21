return {
  name = 'drag',
  dir = require 'my_simple'.get_opt_dir 'drag',
  lazy = true,
  event = { 'BufReadPre', 'BufNewFile', },
  keys = {
    { '<leader>mu', function() require 'drag_images'.update 'cur' end,        mode = { 'n', 'v', }, silent = true, desc = 'markdown images update cur', },
    { '<leader>mU', function() require 'drag_images'.update 'cwd' end,        mode = { 'n', 'v', }, silent = true, desc = 'markdown images update cwd', },
    { '<leader>mv', function() require 'drag_images'.paste 'jpg' end,         mode = { 'n', 'v', }, silent = true, desc = 'markdown paste jpg image', },
    { '<leader>mV', function() require 'drag_images'.paste 'png' end,         mode = { 'n', 'v', }, silent = true, desc = 'markdown paste png image', },
    { '<leader>my', function() require 'drag_images'.copy_text() end,         mode = { 'n', 'v', }, silent = true, desc = 'markdown copy <cfile> to "+', },
    { '<leader>mY', function() require 'drag_images'.copy_file() end,         mode = { 'n', 'v', }, silent = true, desc = 'markdown copy <cfile> to clipboard', },
    { '<s-f11>',    function() require 'drag_images'.copy_file() end,         mode = { 'n', 'v', }, silent = true, desc = 'markdown copy <cfile> to clipboard', },
    { '<leader>mE', function() require 'drag_bin'.edit_drag_bin_fts_md() end, mode = { 'n', 'v', }, silent = true, desc = 'drag bin to xxd fts edit', },
  },
  dependencies = {
    require 'plugins.plenary',
    'peter-lyr/vim-bbye',
    'peter-lyr/sha2',
    require 'plugins.projectroot',
  },
  config = function()
    require 'drag'
  end,
}
