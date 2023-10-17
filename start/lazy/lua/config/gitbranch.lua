local M = {}

package.loaded['config.gitbranch'] = nil

vim.cmd 'Lazy load vim-gitbranch'

M.getbranchname = function()
  vim.cmd [[call feedkeys("\<c-r>=gitbranch#name()\<cr>")]]
end

return M
