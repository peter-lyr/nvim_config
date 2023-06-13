local opt = vim.fn.expand('$VIMRUNTIME') .. '\\pack\\testnvim2\\opt\\'

return {
  {
    name = 'options',
    dir = opt .. 'options',
  },
  {
    name = 'maps',
    dir = opt .. 'maps',
  },
}
