local opt = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\'

return {
  name = 'verylazy',
  dir = opt .. 'verylazy',
  event = 'VeryLazy',
  config = function()
    require 'my_events'
    require 'my_options'
    require 'my_scroll'
  end,
}
