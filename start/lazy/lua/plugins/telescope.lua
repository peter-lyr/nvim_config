-- ui all
local function f9_lhs_() return '<leader>sA' end
local function f9_desc() return 'Telescope ui_all' end
local function f9_____() require 'config.telescope'.ui_all() end

local function f1_lhs_() return '<leader>gf' end
local function f1_desc() return 'Telescope git_status' end
local function f1_____() require 'config.telescope'.git_status() end

local function f2_lhs_() return '<leader>svb' end
local function f2_desc() return 'Telescope buffers_cur' end
local function f2_____() require 'config.telescope'.buffers_cur() end

local function f3_lhs_() return '<leader>s<leader>' end
local function f3_desc() return 'Telescope find_files' end
local function f3_____() require 'config.telescope'.find_files() end

local function f4_lhs_() return '<leader>sj' end
local function f4_desc() return 'Telescope jumplist' end
local function f4_____() require 'config.telescope'.jumplist() end

local function f5_lhs_() return '<leader>se' end
local function f5_desc() return 'Telescope file_browser_cur' end
local function f5_____() require 'config.telescope'.file_browser_cur() end

local function f6_lhs_() return '<leader>sc' end
local function f6_desc() return 'Telescope command_history' end
local function f6_____() require 'config.telescope'.command_history() end

local function f7_lhs_() return '<leader>fl' end
local function f7_desc() return 'Telescope lsp_document_symbols' end
local function f7_____() require 'config.telescope'.lsp_document_symbols() end

local function f8_lhs_() return '<leader>sb' end
local function f8_desc() return 'Telescope buffers' end
local function f8_____() require 'config.telescope'.buffers() end

local function f10_lhs_() return '<leader>sa' end
local function f10_desc() return 'Telescope my_file_browser' end
local function f10_____() require 'config.telescope'.my_file_browser() end

local function nop() end

TelescopeKeyF12 = {
  { f1_lhs_(),  { '<c-s-f12><f1>', f1_____, mode = { 'n', 'v', }, silent = true, desc = f1_desc(), }, },
  { f2_lhs_(),  { '<c-s-f12><f2>', f2_____, mode = { 'n', 'v', }, silent = true, desc = f2_desc(), }, },
  { f3_lhs_(),  { '<c-s-f12><f3>', f3_____, mode = { 'n', 'v', }, silent = true, desc = f3_desc(), }, },
  { f4_lhs_(),  { '<c-s-f12><f4>', f4_____, mode = { 'n', 'v', }, silent = true, desc = f4_desc(), }, },
  { f5_lhs_(),  { '<c-s-f12><f5>', f5_____, mode = { 'n', 'v', }, silent = true, desc = f5_desc(), }, },
  { f6_lhs_(),  { '<c-s-f12><f6>', f6_____, mode = { 'n', 'v', }, silent = true, desc = f6_desc(), }, },
  { f7_lhs_(),  { '<c-s-f12><f7>', f7_____, mode = { 'n', 'v', }, silent = true, desc = f7_desc(), }, },
  { f8_lhs_(),  { '<c-s-f12><f8>', f8_____, mode = { 'n', 'v', }, silent = true, desc = f8_desc(), }, },
  { f9_lhs_(),  { '<c-s-f12><f9>', f9_____, mode = { 'n', 'v', }, silent = true, desc = f9_desc(), }, },
  { f10_lhs_(), { '<c-s-f12><f10>', f10_____, mode = { 'n', 'v', }, silent = true, desc = f10_desc(), }, },
}

TelescopeKeyF12Nop = {
  { '<c-s-f12><f1>',  nop, mode = { 'i', }, silent = true, desc = '', },
  { '<c-s-f12><f2>',  nop, mode = { 'i', }, silent = true, desc = '', },
  { '<c-s-f12><f3>',  nop, mode = { 'i', }, silent = true, desc = '', },
  { '<c-s-f12><f4>',  nop, mode = { 'i', }, silent = true, desc = '', },
  { '<c-s-f12><f5>',  nop, mode = { 'i', }, silent = true, desc = '', },
  { '<c-s-f12><f6>',  nop, mode = { 'i', }, silent = true, desc = '', },
  { '<c-s-f12><f7>',  nop, mode = { 'i', }, silent = true, desc = '', },
  { '<c-s-f12><f8>',  nop, mode = { 'i', }, silent = true, desc = '', },
  { '<c-s-f12><f9>',  nop, mode = { 'i', }, silent = true, desc = '', },
  { '<c-s-f12><f10>', nop, mode = { 'i', }, silent = true, desc = '', },
}

TelescopeKeysLess = {
  { '<leader>svh',  function() require 'config.telescope'.help_tags() end,   mode = { 'n', 'v', }, silent = true, desc = 'Telescope help_tags', },
  { '<leader>svvo', function() require 'config.telescope'.vim_options() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope vim_options', },
  { '<leader>svvp', function() require 'config.telescope'.planets() end,     mode = { 'n', 'v', }, silent = true, desc = 'Telescope planets', },
  { '<leader>ss',   function() require 'config.telescope'.grep_string() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope grep_string', },
  { '<leader>sm',   function() require 'config.telescope'.keymaps() end,     mode = { 'n', 'v', }, silent = true, desc = 'Telescope keymaps', },
}

TelescopeKeysUiAll = {

  { '<leader>sk',         function() require 'config.telescope'.my_projects() end,               mode = { 'n', 'v', }, silent = true, desc = 'Telescope my_projects', },
  { '<leader>sv<leader>', function() require 'config.telescope'.find_files_all() end,            mode = { 'n', 'v', }, silent = true, desc = 'Telescope find_files_all', },
  { '<leader>sh',         function() require 'config.telescope'.search_history()() end,          mode = { 'n', 'v', }, silent = true, desc = 'Telescope search_history', },
  { '<leader>svc',        function() require 'config.telescope'.commands() end,                  mode = { 'n', 'v', }, silent = true, desc = 'Telescope commands', },
  { '<leader>sd',         function() require 'config.telescope'.diagnostics() end,               mode = { 'n', 'v', }, silent = true, desc = 'Telescope diagnostics', },
  { '<leader>sf',         function() require 'config.telescope'.filetypes() end,                 mode = { 'n', 'v', }, silent = true, desc = 'Telescope filetypes', },
  { '<leader>sz',         function() require 'config.telescope'.current_buffer_fuzzy_find() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope current_buffer_fuzzy_find', },
  { '<leader>sq',         function() require 'config.telescope'.quickfix() end,                  mode = { 'n', 'v', }, silent = true, desc = 'Telescope quickfix', },
  { '<leader>svq',        function() require 'config.telescope'.quickfixhistory() end,           mode = { 'n', 'v', }, silent = true, desc = 'Telescope quickfixhistory', },
  { '<leader>svva',       function() require 'config.telescope'.builtin() end,                   mode = { 'n', 'v', }, silent = true, desc = 'Telescope builtin', },
  { '<leader>svc',        function() require 'config.telescope'.colorscheme() end,               mode = { 'n', 'v', }, silent = true, desc = 'Telescope colorscheme', },
  { '<leader>so',         function() require 'config.telescope'.frecency() end,                  mode = { 'n', 'v', }, silent = true, desc = 'Telescope frecency', },

  -- git
  { '<leader>gh',         function() require 'config.telescope'.git_branches() end,              mode = { 'n', 'v', }, silent = true, desc = 'Telescope git_branches', },
  { '<leader>gtc',        function() require 'config.telescope'.git_commits() end,               mode = { 'n', 'v', }, silent = true, desc = 'Telescope git_commits', },
  { '<leader>gtb',        function() require 'config.telescope'.git_bcommits() end,              mode = { 'n', 'v', }, silent = true, desc = 'Telescope git_bcommits', },

  -- lsp
  { '<leader>fr',         function() require 'config.telescope'.lsp_references() end,            mode = { 'n', 'v', }, silent = true, desc = 'Telescope lsp_references', },

  -- config
  { '<leader>sO',         function() require 'config.telescope'.open() end,                      mode = { 'n', 'v', }, silent = true, desc = 'Telescope open config file', },

  -- right_click
  '<RightMouse>',

}

local keys = {

  -- rg
  { '<leader>sl',     function() require 'config.telescope'.live_grep() end,     mode = { 'n', 'v', }, silent = true, desc = 'Telescope live_grep', },
  { '<leader>svl',    function() require 'config.telescope'.live_grep_all() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope live_grep_all', },
  { '<leader>sL',     function() require 'config.telescope'.live_grep_def() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope live_grep_def', },
  { '<leader>s<c-l>', function() require 'config.telescope'.live_grep_rg() end,  mode = { 'n', 'v', }, silent = true, desc = 'Telescope live_grep_rg', },

  -- all
  { '<leader>sA',     function() require 'config.telescope'.ui_all() end,        mode = { 'n', 'v', }, silent = true, desc = 'Telescope ui_all', },

}

for _, k in ipairs(vim.deepcopy(TelescopeKeyF12)) do
  local kk = k[2]
  keys[#keys + 1] = kk
end

for _, k in ipairs(vim.deepcopy(TelescopeKeyF12)) do
  local kk = k[2]
  kk[1] = k[1]
  keys[#keys + 1] = kk
end

for _, k in ipairs(vim.deepcopy(TelescopeKeyF12Nop)) do
  keys[#keys + 1] = k
end

for _, k in ipairs(vim.deepcopy(TelescopeKeysUiAll)) do
  keys[#keys + 1] = k
end

for _, k in ipairs(vim.deepcopy(TelescopeKeysLess)) do
  keys[#keys + 1] = k
end

return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  lazy = true,
  cmd = {
    'Telescope',
  },
  keys = {
    '<leader>s',
    unpack(keys),
  },
  dependencies = {
    require 'plugins.plenary',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
      build = 'mingw32-make',
    },
    {
      'nvim-telescope/telescope-frecency.nvim',
      dependencies = { 'kkharji/sqlite.lua', },
    },
    -- 'nvim-telescope/telescope-file-browser.nvim',
    'peter-lyr/telescope-file-browser.nvim',
    require 'plugins.whichkey',
    'nvim-telescope/telescope-ui-select.nvim',
  },
  init = function()
    require 'which-key'.register { ['<leader>s'] = { name = 'Telescope', }, }
    require 'which-key'.register { ['<leader>sv'] = { name = 'Telescope more', }, }
    require 'which-key'.register { ['<leader>svv'] = { name = 'Telescope more', }, }
    require 'which-key'.register { ['<leader>gt'] = { name = 'Git Telescope', }, }
  end,
  config = function()
    require 'config.telescope'
  end,
}
