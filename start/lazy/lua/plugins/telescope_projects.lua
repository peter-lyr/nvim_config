local keys = {}

local telescopekeysuiall_temp = {
  { '<leader>sk', function() require 'config.telescope_projects'.my_projects() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope my_projects', },
}

for _, k in ipairs(vim.deepcopy(telescopekeysuiall_temp)) do
  keys[#keys + 1] = k
  TelescopeKeysUiAll[#TelescopeKeysUiAll + 1] = k
end

return {
  'ahmedkhalf/project.nvim',
  lazy = true,
  keys = keys,
  dependencies = {
    require 'plugins.telescope',
  },
  config = function()
    require 'config.telescope_projects'
  end,
}
