return {
  'preservim/nerdcommenter',
  lazy = true,
  init = function()
    vim.g.NERDSpaceDelims = 1
    vim.g.NERDDefaultAlign = "left"
    vim.g.NERDCommentEmptyLines = 1
    vim.g.NERDTrimTrailingWhitespace = 1
    vim.g.NERDToggleCheckAllLines = 1
    vim.g.NERDCustomDelimiters = {
      markdown = {
        left = '<!--', right = '-->',
        leftAlt = '[', rightAlt = ']: #',
      },
      c = {
        left = '//', right = '',
        leftAlt = '/*', rightAlt = '*/',
      },
    }
  end,
  keys = {
    { '<leader>cp',  "vip:call nerdcommenter#Comment('x', 'toggle')<CR>", mode = { 'n', }, desc = 'comment a paragraph' },
    { '<leader>c}',  "V}k:call nerdcommenter#Comment('x', 'toggle')<CR>", mode = { 'n', }, desc = 'comment paragraph till end' },
    { '<leader>c{',  "V{j:call nerdcommenter#Comment('x', 'toggle')<CR>", mode = { 'n', }, desc = 'comment paragraph till start' },
    { '<leader>cG',  "VG:call nerdcommenter#Comment('x', 'toggle')<CR>",  mode = { 'n', }, desc = 'comment till end of line' },
    { '<leader>cgg', "Vgg:call nerdcommenter#Comment('x', 'toggle')<CR>", mode = { 'n', }, desc = 'comment till end of line' },
    '<leader>c<leader>',
    '<leader>cc',
    '<leader>cu',
    '<leader>ca',
    '<leader>cA',
    '<leader>cb',
    '<leader>ci',
    '<leader>cl',
    '<leader>cm',
    '<leader>cn',
    '<leader>cs',
    '<leader>cy',
  },
}
