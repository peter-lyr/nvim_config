return {
  'lukas-reineke/indent-blankline.nvim',
  lazy = true,
  event = { 'CursorMoved', 'CursorMovedI', },
  opt = {
    space_char_blankline = ' ',
    char = '│',
    filetype_exclude = {
      'qf',
      'help',
      'lazy',
      'mason',
      'notify',
      'startuptime',
      'lspinfo',
      'noice',
    },
    show_trailing_blankline_indent = false,
    show_current_context = false,
  },
}
