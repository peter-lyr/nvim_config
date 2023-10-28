local S = require 'startup'

local plugin = 'gitpush'

return {
  name = plugin,
  dir = '',
  lazy = true,
  init = function()
    if not S.enable then
      require 'my_simple'.add_whichkey('<leader>g', plugin, 'GitPush')
    end
  end,
  config = function()
    require 'map.gitpush'
  end,
}
