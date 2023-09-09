return {
  'preservim/nerdcommenter',
  lazy = true,
  event = { "BufReadPost", "BufNewFile", },
  init = function()
    vim.g.NERDSpaceDelims = 1
    vim.g.NERDDefaultAlign = "left"
    vim.g.NERDCommentEmptyLines = 1
    vim.g.NERDTrimTrailingWhitespace = 1
    vim.g.NERDToggleCheckAllLines = 1
    vim.g.NERDCustomDelimiters = {
      markdown = {
        left = '<!--',
        right = '-->',
        leftAlt = '[',
        rightAlt = ']: #',
      },
      c = {
        left = '//',
        right = '',
        leftAlt = '/*',
        rightAlt = '*/',
      },
    }
  end,
  keys = {
    { '<leader>co',        "}kvip:call nerdcommenter#Comment('x', 'invert')<CR>", mode = { 'n', }, desc = 'comment invert', },
    { '<leader>cp',        "}kvip:call nerdcommenter#Comment('x', 'toggle')<CR>", mode = { 'n', }, desc = 'comment a paragraph', },
    { '<leader>c}',        "V}k:call nerdcommenter#Comment('x', 'toggle')<CR>", mode = { 'n', }, desc = 'comment paragraph till end', },
    { '<leader>c{',        "V{j:call nerdcommenter#Comment('x', 'toggle')<CR>", mode = { 'n', }, desc = 'comment paragraph till start', },
    { '<leader>cG',        "VG:call nerdcommenter#Comment('x', 'toggle')<CR>",  mode = { 'n', }, desc = 'comment till end of line', },
    { '<leader>cgg',       "Vgg:call nerdcommenter#Comment('x', 'toggle')<CR>", mode = { 'n', }, desc = 'comment till start of line', },
    { '<leader>c<leader>', mode = { 'n', 'v', }, },
    { '<leader>cc',        mode = { 'n', 'v', }, },
    { '<leader>cu',        mode = { 'n', 'v', }, },
    { '<leader>ca',        mode = { 'n', 'v', }, },
    { '<leader>cA',        mode = { 'n', 'v', }, },
    { '<leader>cb',        mode = { 'n', 'v', }, },
    { '<leader>ci',        mode = { 'n', 'v', }, },
    { '<leader>cl',        mode = { 'n', 'v', }, },
    { '<leader>cm',        mode = { 'n', 'v', }, },
    { '<leader>cn',        mode = { 'n', 'v', }, },
    { '<leader>cs',        mode = { 'n', 'v', }, },
    { '<leader>cy',        mode = { 'n', 'v', }, },
  },
  config = function()
    vim.api.nvim_create_autocmd({ "BufEnter", }, {
      callback = function()
        if vim.bo.ft == 'python' then
          vim.g.NERDSpaceDelims = 0
        else
          vim.g.NERDSpaceDelims = 1
        end
      end,
    })
  end,
}
