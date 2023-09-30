local keys = {}

local telescopekeysuiall_fzf = {
  { '<leader>sz', function() require 'config.telescope_fzf'.current_buffer_fuzzy_find() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope current_buffer_fuzzy_find', },
}

for _, k in ipairs(vim.deepcopy(telescopekeysuiall_fzf)) do
  keys[#keys + 1] = k
  TelescopeKeysUiAll[#TelescopeKeysUiAll + 1] = k
end

return {
  'nvim-telescope/telescope-fzf-native.nvim',
  lazy = true,
  keys = keys,
  -- build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
  build = 'mingw32-make',
  dependencies = {
    require 'plugins.telescope',
  },
  config = function()
    require 'config.telescope_fzf'
  end,
}
