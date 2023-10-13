return {
  'peter-lyr/code_runner.nvim',
  lazy = true,
  commit = '3c365982',
  keys = {
    -- cur
    { '<leader>rb',        function() require 'config.coderunner'.build() end,            mode = { 'n', 'v', }, silent = true, desc = 'code runner build', },
    { '<leader>rB',        function() require 'config.coderunner'.rebuild() end,          mode = { 'n', 'v', }, silent = true, desc = 'code runner rebuild', },
    { '<leader>r<leader>', function() require 'config.coderunner'.run() end,              mode = { 'n', 'v', }, silent = true, desc = 'code runner run', },
    { '<leader>rr',        function() require 'config.coderunner'.build_run() end,        mode = { 'n', 'v', }, silent = true, desc = 'code runner build_run', },
    { '<leader>rR',        function() require 'config.coderunner'.rebuild_run() end,      mode = { 'n', 'v', }, silent = true, desc = 'code runner rebuild_run', },

    -- proj
    { '<leader>rp',        function() require 'config.coderunner'.build_proj() end,       mode = { 'n', 'v', }, silent = true, desc = 'code runner build proj', },
    { '<leader>rP',        function() require 'config.coderunner'.rebuild_proj() end,     mode = { 'n', 'v', }, silent = true, desc = 'code runner rebuild proj', },
    { '<leader>r<cr>',     function() require 'config.coderunner'.run_proj() end,         mode = { 'n', 'v', }, silent = true, desc = 'code runner run proj', },
    { '<leader>ro',        function() require 'config.coderunner'.build_run_proj() end,   mode = { 'n', 'v', }, silent = true, desc = 'code runner build_run proj', },
    { '<leader>rO',        function() require 'config.coderunner'.rebuild_run_proj() end, mode = { 'n', 'v', }, silent = true, desc = 'code runner rebuild_run proj', },

    --c
    { '<f9>',              function() require 'config.coderunner_c'.justbuild() end,      mode = { 'n', 'v', }, silent = true, desc = 'code runner c to_make and justbuild', },
    { '<c-f9>',            function() require 'config.coderunner_c'.rebuild() end,        mode = { 'n', 'v', }, silent = true, desc = 'code runner c to_make and rebuild', },
    { '<c-f10>',           function() require 'config.coderunner_c'.to_cmake() end,       mode = { 'n', 'v', }, silent = true, desc = 'code runner c to_cmake', },
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
