return {
  'skywind3000/asyncrun.vim',
  lazy = true,
  cmd = {
    'AsyncRun',
    'AsyncStop',
    'AsyncReset',
  },
  keys = {
    -- AsyncStop
    {
      '<c-s-f9>',
      function()
        pcall(vim.cmd, 'AsyncStop')
      end,
      mode = { 'n', 'v' },
      silent = true,
      desc = 'AsyncStop'
    },
    {
      '<leader>v;',
      ':AsyncRun ',
      mode = { 'n', 'v' },
      silent = true,
      desc = 'AsyncRun'
    },

  }
}
