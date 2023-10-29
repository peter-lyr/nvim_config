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
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>m', 'iamcco/markdown-preview.nvim', 'markdown_preview')
      end
    end,
    config = function()
      require 'config.markdown_preview'
    end,
  },
}
