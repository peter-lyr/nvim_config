local M = {}

require 'telescope'.load_extension 'ui-select'

M.ui_all = function()
  local descs = {}
  local keys = {}
  for i = 1, #TelescopeKeysUiAll do
    descs[#descs + 1] = TelescopeKeysUiAll[i]['desc']
    keys[#keys + 1] = vim.fn.substitute(TelescopeKeysUiAll[i][1], '<leader>', ' ', 'g')
  end
  vim.ui.select(descs, { prompt = 'telescope all', }, function(choice, idx)
    if not choice then
      return
    end
    vim.cmd(string.format([[call feedkeys("%s")]], keys[idx]))
  end)
end

return M
