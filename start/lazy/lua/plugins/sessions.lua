return {
  'natecraddock/sessions.nvim',
  event = { 'VeryLazy', },
  keys = {
    { '<leader>s=',    function() require 'config.sessions'.save() end, mode = { 'n', 'v', }, silent = true, desc = 'Sessions save', },
    { '<leader>s-',    function() require 'config.sessions'.stop() end, mode = { 'n', 'v', }, silent = true, desc = 'Sessions load', },
    { '<leader>s<cr>', function() require 'config.sessions'.load() end, mode = { 'n', 'v', }, silent = true, desc = 'Sessions stop', },
  },
  init = function()
    require 'config.whichkey'.add { ['<leader>s'] = { name = 'Sessions', }, }
  end,
  config = function()
    require 'sessions'.setup {
      events = { 'VimLeave', },
      session_filepath = vim.fn.stdpath 'data' .. '/sessions',
      absolute = true,
    }
  end,
}
