local function f5_lhs_() return '<leader>se' end
local function f5_desc() return 'Telescope my_file_browser_cur' end
local function f5_____() require 'config.telescope_file_browser'.my_file_browser_cur() end

local function f10_lhs_() return '<leader>sa' end
local function f10_desc() return 'Telescope my_file_browser' end
local function f10_____() require 'config.telescope_file_browser'.my_file_browser() end

local telescopekeyf12_file_browser = {
  { f5_lhs_(),  { '<c-s-f12><f5>', f5_____, mode = { 'n', 'v', }, silent = true, desc = f5_desc(), }, },
  { f10_lhs_(), { '<c-s-f12><f10>', f10_____, mode = { 'n', 'v', }, silent = true, desc = f10_desc(), }, },
}

local keys = {}

for _, k in ipairs(vim.deepcopy(telescopekeyf12_file_browser)) do
  local kk = k[2]
  keys[#keys + 1] = kk
end

for _, k in ipairs(vim.deepcopy(telescopekeyf12_file_browser)) do
  local kk = k[2]
  kk[1] = k[1]
  keys[#keys + 1] = kk
end

return {
  -- 'nvim-telescope/telescope-file-browser.nvim',
  'peter-lyr/telescope-file-browser.nvim',
  lazy = true,
  keys = keys,
  dependencies = {
    require 'plugins.telescope',
  },
  config = function()
    require 'config.telescope_file_browser'
  end,
}
