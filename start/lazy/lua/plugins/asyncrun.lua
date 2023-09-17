return {
  'skywind3000/asyncrun.vim',
  lazy = true,
  cmd = { 'AsyncRun', 'AsyncStop', 'AsyncReset', },
  keys = {
    { '<c-s-f9>',   function() require 'config.asyncrun'.stop() end,  mode = { 'n', 'v', }, silent = true, desc = 'AsyncStop', },
    { '<leader>v;', function() require 'config.asyncrun'.input() end, mode = { 'n', 'v', }, silent = true, desc = 'AsyncRun', },
  },
}
