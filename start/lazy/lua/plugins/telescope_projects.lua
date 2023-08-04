return {
  'ahmedkhalf/project.nvim',
  lazy = true,
  keys = {
    {
      '<leader>sk',
      function()
        require('config.telescope_projects').open()
      end,
      mode = { 'n', 'v' },
      silent = true,
      desc = 'Telescope projects'
    },
  },
  dependencies = {
    require('wait.telescope'),
    require('wait.plenary'),
  },
  config = function()
    require('config.telescope_projects')
  end,
}
