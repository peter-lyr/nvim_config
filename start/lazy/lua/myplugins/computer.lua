local opt = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\'

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

      { '<leader>rva',  function() require 'Windows'.monitor_30min() end,   mode = { 'n', 'v', }, silent = true, desc = 'monitor close timeout 30min', },
      { '<leader>rvva', function() require 'Windows'.monitor_1min() end,    mode = { 'n', 'v', }, silent = true, desc = 'monitor close timeout 1min', },

      -- 系统代理

      { '<leader>rvb',  function() require 'Windows'.proxy_on() end,        mode = { 'n', 'v', }, silent = true, desc = 'proxy_on', },
      { '<leader>rvvb', function() require 'Windows'.proxy_off() end,       mode = { 'n', 'v', }, silent = true, desc = 'proxy_off', },

      -- 环境变量

      { '<leader>rvc',  function() require 'Windows'.path() end,            mode = { 'n', 'v', }, silent = true, desc = 'open env path', },

      -- 声音属性

      { '<leader>rvd',  function() require 'Windows'.sound() end,           mode = { 'n', 'v', }, silent = true, desc = 'sound', },

    },
  },
}
