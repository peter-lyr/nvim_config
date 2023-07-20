vim.g.mapleader = " "

local vimruntime = vim.fn.expand("$VIMRUNTIME")
local pack = vimruntime .. '\\pack\\'

vim.g.pack_path = pack

vim.g.events_log_en = 1
local events_log_dir = vim.fn.stdpath('data') .. '\\events_log\\'
vim.g.events_log = events_log_dir .. vim.fn.strftime("%Y%m%d-%H%M%S.log")
if vim.fn.isdirectory(events_log_dir) == 0 then
  vim.fn.system(string.format('md "%s"', events_log_dir))
end

function Log(ev, en)
  if vim.g.events_log_en == 1 and en == 1 then
    if ev and ev.buf and ev.event and ev.file then
      vim.fn.writefile({
        string.format([[%3.3f %-2d %-10s "%s"]],
          os.clock(), ev.buf, ev.event, ev.file)
      }, vim.g.events_log, 'a')
    end
  end
end

vim.api.nvim_create_user_command('EventsLogOpen', function()
  if vim.g.events_log_en == 1 then
    vim.cmd('e ' .. vim.g.events_log)
  end
end, { bang = true, nargs = "*", })

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
local lockfile = pack .. "nvim_config\\lazy-lock.json"

local lazy = require('lazy')

lazy.setup({
  -- defaults = {
  --   lazy = true,
  -- },
  spec = {
    { import = 'wait' },
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
      paths = { string.sub(vimruntime, 1, #vimruntime - 12) .. 'nvim-qt\\runtime' },
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
    custom_keys = {
      ["<localleader>l"] = nil,
      ["<localleader>t"] = nil,
    },
  },
})
