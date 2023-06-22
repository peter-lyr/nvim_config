return {
  'echasnovski/mini.indentscope',
  lazy = true,
  event = { 'CursorMoved', },
  config = function()
    require('mini.indentscope').setup({
      symbol = '┃',
    })
  end,
}
