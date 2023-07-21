vim.g.mapleader = " "

local vimruntime = vim.fn.expand("$VIMRUNTIME")
local pack = vimruntime .. '\\pack\\'

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

require('lazy').setup({
  spec = {
    { import = 'nvt-min' },
  },
  root = pack .. "lazy\\plugins",
})

local file = require('plenary.path'):new(pack):joinpath('nvim_config', 'test.log').filename

pcall(vim.api.nvim_del_autocmd, vim.g.test_au1)

vim.g.test_au1 = vim.api.nvim_create_autocmd({
  "CursorMoved",
  "TextChanged",
  "OptionSet",
}, {
  callback = function(ev)
    vim.fn.writefile({ string.format([[%-3.3f %-2d %-20s - "%s"]], os.clock(), ev.buf, ev.event, ev.file) }, file, 'a')
  end,
})
