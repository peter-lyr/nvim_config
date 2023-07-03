local opt = vim.fn.expand('$VIMRUNTIME') .. '\\pack\\nvim_config\\opt\\'

return {
  {
    name = 'computer',
    lazy = true,
    dir = opt .. 'computer',
    keys = {

      ------------------------
      -- Windows.lua
      ------------------------

      -- 关闭显示器倒计时

      { '<F6>A', function() require('Windows').monitor_1min() end, mode = { 'n', 'v' },  silent = true, desc = 'monitor close timeout' },
      { '<F6>a', function() require('Windows').monitor_30min() end, mode = { 'n', 'v' }, silent = true, desc = 'monitor close timeout' },

    },
  },
}
