return {
  'lukas-reineke/indent-blankline.nvim',
  lazy = true,
  event = { 'BufReadPost', 'BufNewFile', },
  opt = {
    space_char_blankline = ' ',
    char = '│',
    filetype_exclude = {
      'qf',
      'help',
      'lazy',
      'mason',
      'notify',
      'aerial',
      'startuptime',
      'minimap',
      'lspinfo',
      'noice',
    },
    show_trailing_blankline_indent = false,
    show_current_context = false,
  },
}
