return {
  'HUAHUAI23/telescope-session.nvim',
  lazy = true,
  event = { 'QuitPre', },
  cmd = {
    -- 'MySessionOpen',
  },
  keys = {
    { '<leader>sir',  function() require 'config.telescope_session'.all() end,       mode = { 'n', 'v', }, silent = true, desc = 'Telescope session open', },
    { '<leader>sio',  function() require 'config.telescope_session'.open() end,      mode = { 'n', 'v', }, silent = true, desc = 'Telescope session open', },
    { '<leader>sis',  function() require 'config.telescope_session'.save() end,      mode = { 'n', 'v', }, silent = true, desc = 'Telescope session save', },
    { '<leader>sivs', function() require 'config.telescope_session'.saveinput() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope session save', },
    { '<leader>sil',  function() require 'config.telescope_session'.list() end,      mode = { 'n', 'v', }, silent = true, desc = 'Telescope session list', },
  },
  dependencies = {
    require 'wait.telescope',
    require 'wait.plenary',
  },
  config = function()
    require 'config.telescope_session'
  end,
}
