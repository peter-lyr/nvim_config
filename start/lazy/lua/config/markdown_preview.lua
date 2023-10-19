local M = {}

package.loaded['config.markdown_preview'] = nil

M.start = function()
  pcall(vim.cmd, 'MarkdownPreview')
end

M.restart = function()
  vim.cmd 'MarkdownPreviewStop'
  vim.fn.timer_start(200, function()
    pcall(vim.cmd, 'MarkdownPreview')
  end)
end

M.stop = function()
  pcall(vim.cmd, 'MarkdownPreviewStop')
end

return M
