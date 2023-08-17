local opt = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\'

return {
  {
    name = 'python',
    dir = opt .. 'python',
    keys = {
      { '<F4>d', function() require 'draw'.draw() end, mode = { 'n', 'v', }, silent = true, desc = 'mkd delete export', },
    },
    dependencies = {
      require 'myplugins.core',  -- terminal
    },
  },
}
