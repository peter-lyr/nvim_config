return {
  'nvim-telescope/telescope-ui-select.nvim',
  lazy = true,
  dependencies = {
    require 'wait.telescope',
  },
  config = function()
    require 'telescope'.load_extension "ui-select"
  end,
}
