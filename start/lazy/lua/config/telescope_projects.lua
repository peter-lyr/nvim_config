local M = {}

local patterns = {
  ".git",
}

require("project_nvim").setup({
  manual_mode = false,
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
