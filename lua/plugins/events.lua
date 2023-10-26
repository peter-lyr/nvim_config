return {
  {
    name = 'bufreadpost',
    event = { 'BufReadPost', },
    dir = '',
    lazy = true,
    config = function()
      require 'my_simple'.load_require('', 'event.' .. 'BufReadPost')
    end,
  },
  {
    name = 'bufleave',
    event = { 'BufLeave', },
    dir = '',
    lazy = true,
    config = function()
      require 'my_simple'.load_require('', 'event.' .. 'BufLeave')
    end,
  },
}
