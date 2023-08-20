local opt = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\'

return {
  {
    name = 'quickfix',
    dir = opt .. 'quickfix',
    dependencies = {
      require 'myplugins.core', -- maps.add
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
    init = function()
      require 'quickfix'
    end,
  },
}
