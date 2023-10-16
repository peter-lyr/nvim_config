local M = {}

package.loaded['toggle'] = nil

M.diff = function(en)
  if en then
    vim.cmd 'diffthis'
  else
    local winid = vim.fn.win_getid()
    vim.cmd 'windo diffoff'
    vim.fn.win_gotoid(winid)
  end
end

M.wrap = function(en)
  if en then
    vim.cmd 'set wrap'
  else
    vim.cmd 'set nowrap'
  end
end

M.norenu = function(en)
  if en then
    vim.cmd 'set norelativenumber'
  else
    vim.cmd 'set relativenumber'
  end
end

M.signcolumn = function(en)
  if en then
    vim.cmd 'set signcolumn=auto:1'
  else
    vim.cmd 'set signcolumn=no'
  end
end

return M
