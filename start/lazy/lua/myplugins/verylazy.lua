local opt = vim.fn.expand('$VIMRUNTIME') .. '\\pack\\nvim_config\\opt\\'

return {
  {
    name = 'verylazy',
    dir = opt .. 'verylazy',
    event = 'VeryLazy',
  },
}
