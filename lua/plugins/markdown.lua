local S = require 'startup'

return {
  {
    'iamcco/markdown-preview.nvim',
    lazy = true,
    build = ':call mkdp#util#install()',
    ft = {
      'markdown',
    },
    init = function()
      vim.g.mkdp_theme              = 'light'
      vim.g.mkdp_auto_close         = 0
      vim.g.mkdp_auto_start         = 0
      vim.g.mkdp_combine_preview    = 1
      vim.g.mkdp_command_for_global = 1
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>m', 'iamcco/markdown-preview.nvim', 'markdown_preview')
      end
    end,
    config = function()
      require 'map.markdown_preview'
    end,
  },
}
