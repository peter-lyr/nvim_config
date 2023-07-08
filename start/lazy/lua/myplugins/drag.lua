local opt = vim.fn.expand('$VIMRUNTIME') .. '\\pack\\nvim_config\\opt\\'

return {
  {
    name = 'drag',
    dir = opt .. 'drag',
    lazy = true,
    event = { "FocusLost", },
  },
}
