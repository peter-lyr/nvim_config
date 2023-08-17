local opt = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\'

return {
  {
    name = 'quickfix',
    dir = opt .. 'quickfix',
    dependencies = {
      -- 'benseefeldt/qf-format.nvim',
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
