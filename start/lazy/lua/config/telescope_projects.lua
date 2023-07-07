local M = {}

local patterns = {
  ".git",
}

require("project_nvim").setup({
  manual_mode = false,
  detection_methods = { "pattern", "lsp" },
  patterns = patterns,
})

M.refreshhistory = function()
  local historyfile = require('plenary.path'):new(require('project_nvim.utils.path').historyfile)
  local lines = historyfile:readlines()
  local newlines = {}
  for _, v in ipairs(lines) do
    local line = vim.fn.tolower(v)
    line = string.gsub(line, '\\', '/')
    if vim.tbl_contains(newlines, line) == false and require('plenary.path'):new(line):exists() then
      table.insert(newlines, line)
    end
  end
  table.sort(newlines)
  historyfile:write(table.concat(newlines, '\n'), 'w')
end

M.refreshhistory()

require('telescope').load_extension("projects")

M.open = function()
  vim.cmd('Telescope projects')
  vim.cmd([[call feedkeys("\<esc>\<esc>")]])
  vim.keymap.set({ 'n', 'v' }, '<leader>sp', ':<c-u>Telescope projects<cr>', { silent = true, desc = 'Telescope projects' })
  vim.cmd([[call feedkeys(":Telescope projects\<cr>")]])
end

return M
