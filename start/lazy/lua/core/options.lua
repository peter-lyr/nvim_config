local opt = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\core\\'

return {
  {
    name = 'options',
    dir = opt .. 'options',
  },
}
