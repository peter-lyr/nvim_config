vim.g.mapleader = " "
vim.g.boot_lua = vim.fn.expand('<sfile>')

local pack = vim.fn.expand("$VIMRUNTIME") .. '\\pack\\'

local lazypath = pack .. "lazy\\start\\lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
  vim.opt.rtp:prepend(lazypath)
end

local root = pack .. "lazy\\plugins"
local readme = pack .. "lazy\\readme"
local lockfile = pack .. "testnvim\\lazy-lock.json"

local lazy = require('lazy')

lazy.setup({
  spec = {
    { import = 'plugins' },
    { import = 'myplugins' },
  },
  root = root,
  readme = {
    root = readme,
  },
  lockfile = lockfile,
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
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
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
