return {
  {
    name = 'options',
    dir = '',
    event = { 'VeryLazy', },
    lazy = false,
    config = function()
      require 'core.options'
    end,
  },
  {
    name = 'maps',
    dir = '',
    event = { 'VeryLazy', },
    lazy = false,
    config = function()
      require 'core.maps'
    end,
  },
}
