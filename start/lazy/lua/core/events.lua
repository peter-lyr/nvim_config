return {
  name = 'events',
  dir = require 'my_simple'.get_opt_dir 'events',
  event = {
    'TextYankPost',
    'BufReadPost',
    'BufWritePre',
    'FileType',
    'VimLeave',
  },
  config = function()
    require 'events'
    require 'scroll'
  end
}
