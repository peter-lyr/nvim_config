return {
  'peter-lyr/my_drag',
  lazy = true,
  ft = {
    'markdown',
  },
  event = { 'FocusLost', },
  init = function()
    if not S.load_whichkeys_txt_enable then
      require 'my_simple'.add_whichkey('<leader>m', 'drag', 'My_Drag')
    end
  end,
  config = function()
    require 'map.my_drag'
  end,
}
