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

      { '<F6>A', function() require('Windows').monitor_1min() end, mode = { 'n', 'v' },  silent = true, desc = 'monitor close timeout 1min' },
      { '<F6>a', function() require('Windows').monitor_30min() end, mode = { 'n', 'v' }, silent = true, desc = 'monitor close timeout 30min' },

      -- 系统代理

      { '<F6>b', function() require('Windows').proxy_on() end, mode = { 'n', 'v' },  silent = true, desc = 'proxy_on' },
      { '<F6>B', function() require('Windows').proxy_off() end, mode = { 'n', 'v' }, silent = true, desc = 'proxy_off' },

    },
  },
}
