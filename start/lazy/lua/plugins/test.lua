return {
  name = 'maps',
  dir = require 'my_simple'.get_create_opt_dir 'maps',
  lazy = true,
  event = { 'CmdlineEnter', 'InsertEnter', 'ModeChanged', },
  init = function()
  end,
  config = function()
  end,
}
