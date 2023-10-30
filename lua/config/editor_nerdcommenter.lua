local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

vim.g.NERDSpaceDelims = 1
vim.g.NERDDefaultAlign = 'left'
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

B.aucmd(M.source, 'BufEnter', { 'BufEnter', }, {
  callback = function()
    if vim.bo.ft == 'python' then
      vim.g.NERDSpaceDelims = 0
    else
      vim.g.NERDSpaceDelims = 1
    end
  end,
})

return M
