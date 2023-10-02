return {
  'peter-lyr/code_runner.nvim',
  lazy = true,
  commit = '3c365982',
  keys = {
    { '<leader>rb',        function() require 'config.coderunner'.build() end,       mode = { 'n', 'v', }, silent = true, desc = 'code runner build', },
    { '<leader>rB',        function() require 'config.coderunner'.rebuild() end,     mode = { 'n', 'v', }, silent = true, desc = 'code runner rebuild', },
    { '<leader>r<leader>', function() require 'config.coderunner'.run() end,         mode = { 'n', 'v', }, silent = true, desc = 'code runner run', },
    { '<leader>rr',        function() require 'config.coderunner'.build_run() end,   mode = { 'n', 'v', }, silent = true, desc = 'code runner build_run', },
    { '<leader>rR',        function() require 'config.coderunner'.rebuild_run() end, mode = { 'n', 'v', }, silent = true, desc = 'code runner rebuild_run', },

    --c
    { '<c-f9>',            function() require 'config.coderunner_c'.build() end,     mode = { 'n', 'v', }, silent = true, desc = 'code runner c to_make and build', },
    { '<c-f10>',           function() require 'config.coderunner_c'.to_cmake() end,  mode = { 'n', 'v', }, silent = true, desc = 'code runner c to_cmake', },
  },
  dependencies = {
    require 'plugins.projectroot',
  },
  init = function()
    require 'which-key'.register { ['<leader>r'] = { name = 'CodeRunner', }, }
  end,
  config = function()
    require 'config.coderunner'
  end,
}
