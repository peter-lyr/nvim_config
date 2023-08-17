local M = {}

local patterns = {
  '.git',
}

require 'project_nvim'.setup {
  manual_mode = false,
  detection_methods = { 'pattern', 'lsp', },
  patterns = patterns,
}

local historyfile = require 'plenary.path':new(require 'project_nvim.utils.path'.historyfile)

if not historyfile:exists() then
  historyfile:touch()
end

M.refreshhistory = function()
  local lines = historyfile:readlines()
  local newlines = {}
  for _, v in ipairs(lines) do
    local line = vim.fn.tolower(v)
    line = string.gsub(line, '\\', '/')
    if vim.tbl_contains(newlines, line) == false and require 'plenary.path':new(line):exists() then
      table.insert(newlines, line)
    end
  end
  table.sort(newlines)
  historyfile:write(table.concat(newlines, '\n'), 'w')
end

M.refreshhistory()

require 'telescope'.load_extension 'my_projects'

M.open = function()
  vim.cmd 'Telescope my_projects'
  vim.cmd [[call feedkeys("\<esc>\<esc>")]]
  vim.keymap.set({ 'n', 'v', }, '<leader>sk', ':<c-u>Telescope my_projects<cr>',
    { silent = true, desc = 'Telescope my_projects', })
  vim.cmd [[call feedkeys(":Telescope my_projects\<cr>")]]
end

return M
