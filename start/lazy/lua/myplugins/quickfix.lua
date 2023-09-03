local opt = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\'

return {
  {
    name = 'quickfix',
    dir = opt .. 'quickfix',
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile', },
    dependencies = {
      require 'myplugins.core', -- maps.add
      require 'plugins.lualine',
    },
    keys = {

      -- toggle

      {
        'dm',
        function()
          require 'quickfix'.toggle()
        end,
        mode = { 'n', 'v', },
        silent = true,
        desc = 'qf toggle',
      },

    },
    config = function()
      require 'quickfix'
    end,
  },
}
