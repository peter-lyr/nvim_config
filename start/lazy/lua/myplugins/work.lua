local opt = vim.fn.expand('$VIMRUNTIME') .. '\\pack\\nvim_config\\opt\\'

return {
  {
    name = 'work',
    dir = opt .. 'work',
    lazy = true,
    keys = {
      { '<c-F9>', function() require('sdkcbp').build() end, mode = { 'n', 'v', }, silent = true, desc = 'sdkcbp build' },
    }
  },
}
