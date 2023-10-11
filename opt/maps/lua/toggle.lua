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

return M
