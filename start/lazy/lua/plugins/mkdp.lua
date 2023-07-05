return {
  'iamcco/markdown-preview.nvim',
  lazy = true,
  ft = {
    'markdown',
  },
  keys = {
    { '<f3><f3>',   '<cmd>MarkdownPreview<cr>',     mode = { 'v', 'n', }, silent = true, desc = 'MarkdownPreview' },
    { '<f3><s-f3>', '<cmd>MarkdownPreviewStop<cr>', mode = { 'v', 'n', }, silent = true, desc = 'MarkdownPreviewStop' },
  },
  dependencies = {
    require('wait.plenary')
  },
  init = function()
    vim.g.mkdp_theme = 'dark'
    vim.g.mkdp_auto_close = 0
  end,
  config = function()
    vim.fn['mkdp#util#install']()
  end
}
