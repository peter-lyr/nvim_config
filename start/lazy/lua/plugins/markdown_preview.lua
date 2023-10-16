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
    vim.g.mkdp_theme              = 'light'
    vim.g.mkdp_auto_close         = 0
    vim.g.mkdp_auto_start         = 0
    vim.g.mkdp_combine_preview    = 1
    vim.g.mkdp_command_for_global = 1
    -- Firefox Setup 55.0.exe test ok, http://ftp.mozilla.org/pub/firefox/releases/55.0/win64/zh-CN/Firefox%20Setup%2055.0.exe
    -- Firefox could not close itself when preview stop.
    -- vim.g.mkdp_browser         = 'firefox.exe'
    require 'config.whichkey'.add { ['<leader>m'] = { name = 'MarkdownPreview', }, }
  end,
  config = function()
    vim.fn.timer_start(20, function()
      require 'config.markdown_preview'.start()
    end)
  end,
}
