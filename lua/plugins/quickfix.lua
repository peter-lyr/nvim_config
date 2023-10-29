local S = require 'startup'

local plugin = 'kevinhwang91/nvim-bqf'

return {
  plugin,
  lazy = true,
  event = { 'QuickFixCmdPre', 'BufReadPost', 'BufNewFile', },
  init = function()
    if not S.load_whichkeys_txt_enable then
      require 'my_simple'.add_whichkey('d', plugin, 'QuickFix')
    end
  end,
  config = function()
    require 'map.quickfix'
  end,
}
