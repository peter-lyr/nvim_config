return {
  {
    name = 'bufreadpost',
    event = { 'BufReadPost', },
    dir = '',
    lazy = true,
    config = function()
      require 'my_simple'.load_require('bufreadpost', 'event.' .. 'BufReadPost')
    end,
  },
}
