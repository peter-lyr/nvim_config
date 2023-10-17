local M = {}

package.loaded['config.sessions'] = nil

M.load = function()
  vim.cmd 'SessionsLoad'
end

M.save = function()
  vim.cmd 'SessionsSave'
end

M.stop = function()
  vim.cmd 'SessionsStop'
end

return M
