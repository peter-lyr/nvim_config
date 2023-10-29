local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

function M.start()
  pcall(vim.cmd, 'MarkdownPreview')
end

function M.restart()
  vim.cmd 'MarkdownPreviewStop'
  vim.fn.timer_start(200, function()
    pcall(vim.cmd, 'MarkdownPreview')
  end)
end

function M.stop()
  pcall(vim.cmd, 'MarkdownPreviewStop')
end

return M
