local keys = {}

local telescopekeysuiall_frecency = {
  { '<leader>so', function() require 'config.telescope_frecency'.frecency() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope frecency', },
}

for _, k in ipairs(vim.deepcopy(telescopekeysuiall_frecency)) do
  keys[#keys + 1] = k
  TelescopeKeysUiAll[#TelescopeKeysUiAll + 1] = k
end

return {
  'nvim-telescope/telescope-frecency.nvim',
  lazy = true,
  keys = keys,
  dependencies = {
    require 'plugins.telescope',
  },
}
