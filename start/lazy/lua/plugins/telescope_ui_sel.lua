-- ui all
local function f9_lhs_() return '<leader>sA' end
local function f9_desc() return 'Telescope ui_all' end
local function f9_____() require 'config.telescope_ui_sel'.ui_all() end

local telescopekeyf12_ui_sel = {
  { f9_lhs_(), { '<c-s-f12><f9>', f9_____, mode = { 'n', 'v', }, silent = true, desc = f9_desc(), }, },
}

local keys = {
  { '<leader>sA', function() require 'config.telescope'.ui_all() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope ui_all', },

}

for _, k in ipairs(vim.deepcopy(telescopekeyf12_ui_sel)) do
  local kk = k[2]
  keys[#keys + 1] = kk
end

for _, k in ipairs(vim.deepcopy(telescopekeyf12_ui_sel)) do
  local kk = k[2]
  kk[1] = k[1]
  keys[#keys + 1] = kk
end

return {
  'nvim-telescope/telescope-ui-select.nvim',
  lazy = true,
  keys = keys,
  dependencies = {
    require 'plugins.telescope',
  },
}
