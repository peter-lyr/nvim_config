local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

local patterns = {
  '.git',
}

require 'project_nvim'.setup {
  manual_mode = false,
  detection_methods = { 'pattern', 'lsp', },
  patterns = patterns,
}

vim.cmd 'autocmd BufRead * lua require("project_nvim.utils.history").write_projects_to_history()'

local historyfile = require 'plenary.path':new(require 'project_nvim.utils.path'.historyfile)

if not historyfile:exists() then
  historyfile:touch()
end

M.refresh_projectshistory = function()
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

M.refresh_projectshistory()

require 'telescope'.load_extension 'my_projects'

M.my_projects = function()
  vim.cmd 'Telescope my_projects'
  vim.cmd [[call feedkeys("\<esc>\<esc>")]]
  vim.keymap.set({ 'n', 'v', }, '<leader>sk', function()
    vim.cmd 'Telescope my_projects'
  end, { silent = true, desc = 'Telescope my_projects', })
  vim.fn.timer_start(20, function()
    vim.cmd [[call feedkeys(":Telescope my_projects\<cr>")]]
  end)
end

return M
