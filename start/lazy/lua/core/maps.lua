local opt = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\opt\\'

return {
  name = 'maps',
  dir = opt .. 'maps',
  lazy = true,
  event = { 'CmdlineEnter', 'InsertEnter', 'ModeChanged', },
  keys = {
  },
}
