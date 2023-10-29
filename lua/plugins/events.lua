return {
  {
    name = 'bufreadpost',
    event = { 'BufReadPost', },
    dir = '',
    lazy = true,
    config = function()
      require 'event.BufReadPost'
    end,
  },
  {
    name = 'bufleave',
    event = { 'BufLeave', },
    dir = '',
    lazy = true,
    config = function()
      require 'event.BufLeave'
    end,
  },
  {
    name = 'filetype',
    event = { 'FileType', },
    dir = '',
    lazy = true,
    config = function()
      require 'event.FileType'
    end,
  },
  {
    name = 'insertenter',
    event = { 'InsertEnter', 'CmdlineEnter', 'TermEnter', },
    dir = '',
    lazy = true,
    config = function()
      require 'event.InsertEnter'
    end,
  },
  {
    name = 'textyankpost',
    event = { 'TextYankPost', },
    dir = '',
    lazy = true,
    config = function()
      -- Highlight on yank
      require 'my_base'.aucmd('textyankpost', 'TextYankPost', 'TextYankPost', {
        callback = function()
          vim.highlight.on_yank()
        end,
      })
    end,
  },
}
