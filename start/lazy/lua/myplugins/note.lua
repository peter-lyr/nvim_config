local opt = vim.fn.expand('$VIMRUNTIME') .. '\\pack\\nvim_config\\opt\\'

return {
  {
    name = 'note',
    dir = opt .. 'note',
    ft = {
      'markdown',
    },
    dependencies = {
      require('myplugins.core'), -- terminal sha2
    },
    keys = {
      { '<F3>p', function() require('mkdimage').getimage('sel_png') end,  mode = { 'n', 'v' }, silent = true, desc = 'getimage sel_png' },
      { '<F3>j', function() require('mkdimage').getimage('sel_jpg') end,  mode = { 'n', 'v' }, silent = true, desc = 'getimage sel_jpg' },
      { '<F3>u', function() require('mkdimage').updatesrc()         end,  mode = { 'n', 'v' }, silent = true, desc = 'updatesrc cur' },
    },
  },
}
