vim.g.mapleader = ' '

local vimruntime = vim.fn.expand '$VIMRUNTIME'
local data = vim.fn.stdpath 'data' .. '\\'

local lazypath = data .. 'site\\pack\\lazy\\start\\lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

local root = data .. 'lazy\\plugins'
local readme = data .. 'lazy\\readme'
local lockfile = data .. 'lazy\\lazy-lock.json'

local lazy = require 'lazy'

lazy.setup {
  spec = {
    { import = 'plugins', },
  },
  root = root,
  readme = {
    root = readme,
  },
  lockfile = lockfile,
  performance = {
    rtp = {
      paths = { string.sub(vimruntime, 1, #vimruntime - 12) .. 'nvim-qt\\runtime', },
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  checker = {
    enabled = false,
  },
  change_detection = {
    enabled = false,
  },
  ui = {
    icons = {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
    custom_keys = {
      ['<localleader>l'] = nil,
      ['<localleader>t'] = nil,
    },
  },
}
