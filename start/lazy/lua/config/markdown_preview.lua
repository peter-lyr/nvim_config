local M = {}

M.start = function()
  vim.cmd 'MarkdownPreview'
end

M.restart = function()
  vim.cmd 'MarkdownPreviewStop'
  vim.fn.timer_start(20, function()
    vim.cmd 'MarkdownPreview'
  end)
end

M.stop = function()
  vim.cmd 'MarkdownPreviewStop'
end

return M
