return {
  name = 'verylazy',
  dir = require 'my_simple'.get_opt_dir 'verylazy',
  event = 'VeryLazy',
  config = function()
    require 'options'
    require 'startup'
  end
}
