local S = require 'startup'

return {
  {
    'phaazon/hop.nvim',
    lazy = true,
    keys = {
      { 's', ':HopChar1<cr>', mode = { 'n', }, silent = true, desc = 'HopChar1', },
    },
    config = function()
      require 'hop'.setup {
        keys = 'asdghklqwertyuiopzxcvbnmfj',
      }
    end,
  },
  {
    'monaqa/dial.nvim',
    lazy = true,
    keys = {
      { '<C-a>', function() return require 'dial.map'.inc_normal() end, expr = true, desc = 'Increment', },
      { '<C-x>', function() return require 'dial.map'.dec_normal() end, expr = true, desc = 'Decrement', },
    },
    config = function()
      require 'map.editor_dial'
    end,
  },
  {
    -- 'chentoast/marks.nvim',
    'peter-lyr/marks.nvim',
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile', },
    config = function()
      require 'map.editor_marks'
    end,
  },
  {
    'nvim-pack/nvim-spectre',
    lazy = true,
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>r', 'nvim-pack/nvim-spectre', 'Editor_Spectre')
      end
    end,
    config = function()
      require 'map.editor_spectre'
    end,
  },
  {
    'tpope/vim-surround',
    lazy = true,
    event = { 'CursorMoved', },
  },
  {
    'anuvyklack/pretty-fold.nvim',
    lazy = true,
    keys = { 'zm', 'zM', 'zc', 'zf', },
    config = function()
      vim.opt.foldmethod = 'indent'
      require 'pretty-fold'.setup()
    end,
  },
  {
    'luukvbaal/statuscol.nvim',
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile', },
    config = function()
      require 'map.editor_statuscol'
    end,
  },
  {
    'windwp/nvim-autopairs',
    lazy = true,
    event = 'InsertEnter',
    opts = {},
  },
  {
    'Pocco81/auto-save.nvim',
    lazy = true,
    event = { 'InsertEnter', 'TextChanged', },
    config = function()
      require 'map.editor_autosave'
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    lazy = true,
    main = 'ibl',
    event = { 'CursorMoved', 'CursorMovedI', },
    config = function()
      require 'map.editor_blankline'
    end,
  },
  {
    'echasnovski/mini.indentscope',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile', },
    config = function()
      require 'map.editor_indentscope'
    end,
  },
  {
    'google/vim-searchindex',
    lazy = true,
    event = { 'CursorMoved', },
  },
  {
    'numToStr/Comment.nvim',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile', },
    config = function()
      require 'map.editor_comment'
    end,
  },
  {
    'preservim/nerdcommenter',
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile', },
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>c', 'preservim/nerdcommenter', 'Editor_NerdCommenter')
      end
    end,
    keys = {
    },
    config = function()
      require 'map.editor_nerdcommenter'
    end,
  },
  {
    'natecraddock/sessions.nvim',
    lazy = true,
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>s', 'natecraddock/sessions.nvim', 'Editor_Sessions')
      end
      require 'my_base'.aucmd('my_window', 'VimLeave', 'VimLeave', {
        callback = function()
          require 'config.editor_sessions'.save()
        end,
      })
    end,
    config = function()
      require 'map.editor_sessions'
    end,
  },
}
