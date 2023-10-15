return {
  'iamcco/markdown-preview.nvim',
  lazy = true,
  build = ':call mkdp#util#install()',
  ft = {
    'markdown',
  },
  cmd = {
    'MarkdownPreview',
    'MarkdownPreviewStop',
    'MarkdownPreviewToggle',
  },
  keys = {
    { '<leader>m<leader>', function() require 'config.markdown_preview'.start() end,   mode = { 'v', 'n', }, silent = true, desc = 'MarkdownPreview', },
    { '<leader>mm',        function() require 'config.markdown_preview'.restart() end, mode = { 'v', 'n', }, silent = true, desc = 'MarkdownPreview restart', },
    { '<leader>mq',        function() require 'config.markdown_preview'.stop() end,    mode = { 'v', 'n', }, silent = true, desc = 'MarkdownPreviewStop', },
  },
  dependencies = {
    require 'plugins.plenary',
  },
  init = function()
    vim.g.mkdp_theme           = 'dark'
    vim.g.mkdp_auto_close      = 0
    vim.g.mkdp_auto_start      = 1
    vim.g.mkdp_combine_preview = 1
    require 'config.whichkey'.add { ['<leader>m'] = { name = 'MarkdownPreview', }, }
  end,
}
