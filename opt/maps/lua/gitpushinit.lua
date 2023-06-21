local M = {}

M.push = function()
  local result = vim.fn.systemlist({ "git", "status", "-s" })
  print(vim.inspect(result), '===')
end

M.init = function()
end

return M
