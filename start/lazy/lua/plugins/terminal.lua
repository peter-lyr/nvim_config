return {
  name = 'terminal',
  dir = require 'my_simple'.get_create_opt_dir 'terminal',
  lazy = true,
  keys = {

    -- toggle

    { '<leader><f1><f1>',  function() require 'terminal'.toggle 'cmd' end,                            mode = { 'n', 'v', }, silent = true, desc = 'terminal toggle cmd', },
    { '<leader><f2><f2>',  function() require 'terminal'.toggle 'ipython' end,                        mode = { 'n', 'v', }, silent = true, desc = 'terminal toggle ipython', },
    { '<leader><f3><f3>',  function() require 'terminal'.toggle 'bash' end,                           mode = { 'n', 'v', }, silent = true, desc = 'terminal toggle bash', },
    { '<leader><f4><f4>',  function() require 'terminal'.toggle 'powershell' end,                     mode = { 'n', 'v', }, silent = true, desc = 'terminal toggle powershell', },

    -- cd

    { '<leader><f1>w',     function() require 'terminal'.toggle('cmd', 'cwd') end,                    mode = { 'n', 'v', }, silent = true, desc = 'terminal cd cwd [cmd]', },
    { '<leader><f2>w',     function() require 'terminal'.toggle('ipython', 'cwd') end,                mode = { 'n', 'v', }, silent = true, desc = 'terminal cd cwd [ipython]', },
    { '<leader><f3>w',     function() require 'terminal'.toggle('bash', 'cwd') end,                   mode = { 'n', 'v', }, silent = true, desc = 'terminal cd cwd [bash]', },
    { '<leader><f4>w',     function() require 'terminal'.toggle('powershell', 'cwd') end,             mode = { 'n', 'v', }, silent = true, desc = 'terminal cd cwd [powershell]', },
    { '<leader><f1>.',     function() require 'terminal'.toggle('cmd', '.') end,                      mode = { 'n', 'v', }, silent = true, desc = 'terminal cd .   [cmd]', },
    { '<leader><f2>.',     function() require 'terminal'.toggle('ipython', '.') end,                  mode = { 'n', 'v', }, silent = true, desc = 'terminal cd .   [ipython]', },
    { '<leader><f3>.',     function() require 'terminal'.toggle('bash', '.') end,                     mode = { 'n', 'v', }, silent = true, desc = 'terminal cd .   [bash]', },
    { '<leader><f4>.',     function() require 'terminal'.toggle('powershell', '.') end,               mode = { 'n', 'v', }, silent = true, desc = 'terminal cd .   [powershell]', },
    { '<leader><f1>u',     function() require 'terminal'.toggle('cmd', 'u') end,                      mode = { 'n', 'v', }, silent = true, desc = 'terminal cd up  [cmd]', },
    { '<leader><f2>u',     function() require 'terminal'.toggle('ipython', 'u') end,                  mode = { 'n', 'v', }, silent = true, desc = 'terminal cd up  [ipython]', },
    { '<leader><f3>u',     function() require 'terminal'.toggle('bash', 'u') end,                     mode = { 'n', 'v', }, silent = true, desc = 'terminal cd up  [bash]', },
    { '<leader><f4>u',     function() require 'terminal'.toggle('powershell', 'u') end,               mode = { 'n', 'v', }, silent = true, desc = 'terminal cd up  [powershell]', },
    { '<leader><f1>-',     function() require 'terminal'.toggle('cmd', '-') end,                      mode = { 'n', 'v', }, silent = true, desc = 'terminal cd -   [cmd]', },
    { '<leader><f2>-',     function() require 'terminal'.toggle('ipython', '-') end,                  mode = { 'n', 'v', }, silent = true, desc = 'terminal cd -   [ipython]', },
    { '<leader><f3>-',     function() require 'terminal'.toggle('bash', '-') end,                     mode = { 'n', 'v', }, silent = true, desc = 'terminal cd -   [bash]', },
    { '<leader><f4>-',     function() require 'terminal'.toggle('powershell', '-') end,               mode = { 'n', 'v', }, silent = true, desc = 'terminal cd -   [powershell]', },

    -- send and show

    { '<leader><f1>s.',    function() require 'terminal'.send('cmd', 'curline', 'show') end,          mode = { 'n', 'v', }, silent = true, desc = 'terminal send curline   show [cmd]', },
    { '<leader><f2>s.',    function() require 'terminal'.send('ipython', 'curline', 'show') end,      mode = { 'n', 'v', }, silent = true, desc = 'terminal send curline   show [ipython]', },
    { '<leader><f3>s.',    function() require 'terminal'.send('bash', 'curline', 'show') end,         mode = { 'n', 'v', }, silent = true, desc = 'terminal send curline   show [bash]', },
    { '<leader><f4>s.',    function() require 'terminal'.send('powershell', 'curline', 'show') end,   mode = { 'n', 'v', }, silent = true, desc = 'terminal send curline   show [powershell]', },
    { '<leader><f1>sp',    function() require 'terminal'.send('cmd', 'paragraph', 'show') end,        mode = { 'n', 'v', }, silent = true, desc = 'terminal send paragraph show [cmd]', },
    { '<leader><f2>sp',    function() require 'terminal'.send('ipython', 'paragraph', 'show') end,    mode = { 'n', 'v', }, silent = true, desc = 'terminal send paragraph show [ipython]', },
    { '<leader><f3>sp',    function() require 'terminal'.send('bash', 'paragraph', 'show') end,       mode = { 'n', 'v', }, silent = true, desc = 'terminal send paragraph show [bash]', },
    { '<leader><f4>sp',    function() require 'terminal'.send('powershell', 'paragraph', 'show') end, mode = { 'n', 'v', }, silent = true, desc = 'terminal send paragraph show [powershell]', },
    { '<leader><f1>sc',    function() require 'terminal'.send('cmd', 'clipboard', 'show') end,        mode = { 'n', 'v', }, silent = true, desc = 'terminal send clipboard show [cmd]', },
    { '<leader><f2>sc',    function() require 'terminal'.send('ipython', 'clipboard', 'show') end,    mode = { 'n', 'v', }, silent = true, desc = 'terminal send clipboard show [ipython]', },
    { '<leader><f3>sc',    function() require 'terminal'.send('bash', 'clipboard', 'show') end,       mode = { 'n', 'v', }, silent = true, desc = 'terminal send clipboard show [bash]', },
    { '<leader><f4>sc',    function() require 'terminal'.send('powershell', 'clipboard', 'show') end, mode = { 'n', 'v', }, silent = true, desc = 'terminal send clipboard show [powershell]', },

    -- send and hide

    { '<leader><f1>h.',    function() require 'terminal'.send('cmd', 'curline', 'hide') end,          mode = { 'n', 'v', }, silent = true, desc = 'terminal send curline   hide [cmd]', },
    { '<leader><f2>h.',    function() require 'terminal'.send('ipython', 'curline', 'hide') end,      mode = { 'n', 'v', }, silent = true, desc = 'terminal send curline   hide [ipython]', },
    { '<leader><f3>h.',    function() require 'terminal'.send('bash', 'curline', 'hide') end,         mode = { 'n', 'v', }, silent = true, desc = 'terminal send curline   hide [bash]', },
    { '<leader><f4>h.',    function() require 'terminal'.send('powershell', 'curline', 'hide') end,   mode = { 'n', 'v', }, silent = true, desc = 'terminal send curline   hide [powershell]', },
    { '<leader><f1>hp',    function() require 'terminal'.send('cmd', 'paragraph', 'hide') end,        mode = { 'n', 'v', }, silent = true, desc = 'terminal send paragraph hide [cmd]', },
    { '<leader><f2>hp',    function() require 'terminal'.send('ipython', 'paragraph', 'hide') end,    mode = { 'n', 'v', }, silent = true, desc = 'terminal send paragraph hide [ipython]', },
    { '<leader><f3>hp',    function() require 'terminal'.send('bash', 'paragraph', 'hide') end,       mode = { 'n', 'v', }, silent = true, desc = 'terminal send paragraph hide [bash]', },
    { '<leader><f4>hp',    function() require 'terminal'.send('powershell', 'paragraph', 'hide') end, mode = { 'n', 'v', }, silent = true, desc = 'terminal send paragraph hide [powershell]', },
    { '<leader><f1>hc',    function() require 'terminal'.send('cmd', 'clipboard', 'hide') end,        mode = { 'n', 'v', }, silent = true, desc = 'terminal send clipboard hide [cmd]', },
    { '<leader><f2>hc',    function() require 'terminal'.send('ipython', 'clipboard', 'hide') end,    mode = { 'n', 'v', }, silent = true, desc = 'terminal send clipboard hide [ipython]', },
    { '<leader><f3>hc',    function() require 'terminal'.send('bash', 'clipboard', 'hide') end,       mode = { 'n', 'v', }, silent = true, desc = 'terminal send clipboard hide [bash]', },
    { '<leader><f4>hc',    function() require 'terminal'.send('powershell', 'clipboard', 'hide') end, mode = { 'n', 'v', }, silent = true, desc = 'terminal send clipboard hide [powershell]', },

    -- hideall

    { '<leader><f1><del>', function() require 'terminal'.hideall() end,                               mode = { 'n', 'v', }, silent = true, desc = 'terminal hide all', },
    { '<leader><f2><del>', function() require 'terminal'.hideall() end,                               mode = { 'n', 'v', }, silent = true, desc = 'terminal hide all', },
    { '<leader><f3><del>', function() require 'terminal'.hideall() end,                               mode = { 'n', 'v', }, silent = true, desc = 'terminal hide all', },
    { '<leader><f4><del>', function() require 'terminal'.hideall() end,                               mode = { 'n', 'v', }, silent = true, desc = 'terminal hide all', },

  },
  init = function()
    require 'config.whichkey'.add { ['<leader><f1>'] = { name = 'terminal cmd', }, }
    require 'config.whichkey'.add { ['<leader><f2>'] = { name = 'terminal ipython', }, }
    require 'config.whichkey'.add { ['<leader><f3>'] = { name = 'terminal bash', }, }
    require 'config.whichkey'.add { ['<leader><f4>'] = { name = 'terminal powershell', }, }
    require 'config.whichkey'.add { ['<leader><f1>s'] = { name = 'terminal send cmd', }, }
    require 'config.whichkey'.add { ['<leader><f2>s'] = { name = 'terminal send ipython', }, }
    require 'config.whichkey'.add { ['<leader><f3>s'] = { name = 'terminal send bash', }, }
    require 'config.whichkey'.add { ['<leader><f4>s'] = { name = 'terminal send powershell', }, }
    require 'config.whichkey'.add { ['<leader><f1>h'] = { name = 'terminal hide cmd', }, }
    require 'config.whichkey'.add { ['<leader><f2>h'] = { name = 'terminal hide ipython', }, }
    require 'config.whichkey'.add { ['<leader><f3>h'] = { name = 'terminal hide bash', }, }
    require 'config.whichkey'.add { ['<leader><f4>h'] = { name = 'terminal hide powershell', }, }
  end,
  config = function()
    require 'terminal'
  end,
}
