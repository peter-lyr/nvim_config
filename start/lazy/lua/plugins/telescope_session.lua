return {
  "HUAHUAI23/telescope-session.nvim",
  lazy = true,
  event = { "QuitPre", },
  keys = {
    { '<leader>s<c-o>', function() require('config.telescope_session').open() end,      mode = { 'n', 'v' }, silent = true, desc = 'Telescope session open' },
    { '<leader>s<c-s>', function() require('config.telescope_session').save() end,      mode = { 'n', 'v' }, silent = true, desc = 'Telescope session save' },
    { '<leader>sS',     function() require('config.telescope_session').saveinput() end, mode = { 'n', 'v' }, silent = true, desc = 'Telescope session save' },
    { '<leader>s<c-l>', function() require('config.telescope_session').list() end,      mode = { 'n', 'v' }, silent = true, desc = 'Telescope session list' },
  },
  dependencies = {
    require('wait.telescope'),
    require('wait.plenary'),
  },
  config = function()
    require('config.telescope_session')
  end,
}
