return {
  'CRAG666/code_runner.nvim',
  lazy = true,
  keys = {
    {
      '<leader>rr',
      function()
        require('config.coderunner').runbuild()
      end,
      mode = { 'n', 'v', },
      silent = true,
      desc = 'code runner run and build'
    },
    {
      '<leader>rb',
      function()
        require('config.coderunner').build()
      end,
      mode = { 'n', 'v', },
      silent = true,
      desc = 'code runner just build'
    },
    {
      '<leader>rf',
      function()
        require('config.coderunner').run()
      end,
      mode = { 'n', 'v', },
      silent = true,
      desc = 'code runner just run'
    },
  },
  dependencies = {
    require('wait.projectroot'),
  },
  config = function()
    require('config.coderunner')
  end,
}
