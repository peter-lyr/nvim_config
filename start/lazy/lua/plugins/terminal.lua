local S = require 'my_simple'
local f = 'terminal'

return {
  name = f,
  dir = S.get_create_opt_dir(f),
  lazy = true,
  keys = {
    S.gkey('<leader><f1>', 'cmd', f),
    S.gkey('<leader><f2>', 'ipython', f),
    S.gkey('<leader><f3>', 'bash', f),
    S.gkey('<leader><f4>', 'powershell', f),
  },
  init = function()
    S.wkey('<leader><f1>s', 'send cmd', f)
    S.wkey('<leader><f2>s', 'send ipython', f)
    S.wkey('<leader><f3>s', 'send bash', f)
    S.wkey('<leader><f4>s', 'send powershell', f)
    S.wkey('<leader><f1>h', 'hide cmd', f)
    S.wkey('<leader><f2>h', 'hide ipython', f)
    S.wkey('<leader><f3>h', 'hide bash', f)
    S.wkey('<leader><f4>h', 'hide powershell', f)
  end,
  config = function()
    require 'terminal'
  end,
}
