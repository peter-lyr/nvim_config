local M = {}

local datapath = require("plenary.path"):new(vim.fn.expand("$VIMRUNTIME")):joinpath("my-neovim-data")

if not datapath:exists() then
  vim.fn.mkdir(datapath.filename)
end

local patterns = {
  ".git",
}

require("project_nvim").setup({
  manual_mode = false,
  datapath = datapath.filename,
  detection_methods = { "pattern", "lsp" },
  patterns = patterns,
})

require('telescope').load_extension("projects")

M.open = function()
  vim.cmd('Telescope projects')
  vim.cmd([[call feedkeys("\<esc>\<esc>")]])
  vim.keymap.set({ 'n', 'v' }, '<leader>sp', ':<c-u>Telescope projects<cr>', { silent = true, desc = 'Telescope projects' })
  vim.cmd([[call feedkeys(":Telescope projects\<cr>")]])
end

return M
