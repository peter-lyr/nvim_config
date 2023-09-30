-- ui all
local function f9() require 'config.telescope'.ui_all() end
local function f9_desc() return 'Telescope ui_all' end

local function f1() require 'config.telescope'.git_status() end
local function f1_desc() return 'Telescope git_status' end

local function f2() require 'config.telescope'.buffers_cur() end
local function f2_desc() return 'Telescope buffers_cur' end

local function f3() require 'config.telescope'.find_files() end
local function f3_desc() return 'Telescope find_files' end

local function f4() require 'config.telescope'.jumplist() end
local function f4_desc() return 'Telescope jumplist' end

local function f5() require 'config.telescope'.file_browser_cur() end
local function f5_desc() return 'Telescope file_browser_cur' end

local function f6() require 'config.telescope'.command_history() end
local function f6_desc() return 'Telescope command_history' end

local function f7() require 'config.telescope'.lsp_document_symbols() end
local function f7_desc() return 'Telescope lsp_document_symbols' end

local function f8() require 'config.telescope'.buffers() end
local function f8_desc() return 'Telescope buffers' end

local function f10() require 'config.telescope'.my_file_browser() end
local function f10_desc() return 'Telescope my_file_browser' end

local function nop() end

TelescopeKeyF12 = {
  { '<c-s-f12><f1>',  f1,  mode = { 'n', 'v', }, silent = true, desc = f1_desc(), },
  { '<c-s-f12><f2>',  f2,  mode = { 'n', 'v', }, silent = true, desc = f2_desc(), },
  { '<c-s-f12><f3>',  f3,  mode = { 'n', 'v', }, silent = true, desc = f3_desc(), },
  { '<c-s-f12><f4>',  f4,  mode = { 'n', 'v', }, silent = true, desc = f4_desc(), },
  { '<c-s-f12><f5>',  f5,  mode = { 'n', 'v', }, silent = true, desc = f5_desc(), },
  { '<c-s-f12><f6>',  f6,  mode = { 'n', 'v', }, silent = true, desc = f6_desc(), },
  { '<c-s-f12><f7>',  f7,  mode = { 'n', 'v', }, silent = true, desc = f7_desc(), },
  { '<c-s-f12><f8>',  f8,  mode = { 'n', 'v', }, silent = true, desc = f8_desc(), },
  { '<c-s-f12><f9>',  f9,  mode = { 'n', 'v', }, silent = true, desc = f9_desc(), },
  { '<c-s-f12><f10>', f10, mode = { 'n', 'v', }, silent = true, desc = f10_desc(), },
  { '<c-s-f12><f1>',  nop, mode = { 'i', },      silent = true, desc = '', },
  { '<c-s-f12><f2>',  nop, mode = { 'i', },      silent = true, desc = '', },
  { '<c-s-f12><f3>',  nop, mode = { 'i', },      silent = true, desc = '', },
  { '<c-s-f12><f4>',  nop, mode = { 'i', },      silent = true, desc = '', },
  { '<c-s-f12><f5>',  nop, mode = { 'i', },      silent = true, desc = '', },
  { '<c-s-f12><f6>',  nop, mode = { 'i', },      silent = true, desc = '', },
  { '<c-s-f12><f7>',  nop, mode = { 'i', },      silent = true, desc = '', },
  { '<c-s-f12><f8>',  nop, mode = { 'i', },      silent = true, desc = '', },
  { '<c-s-f12><f9>',  nop, mode = { 'i', },      silent = true, desc = '', },
  { '<c-s-f12><f10>', nop, mode = { 'i', },      silent = true, desc = '', },
}

TelescopeKeysLess = {
  { '<leader>svh',  function() require 'config.telescope'.help_tags() end,   mode = { 'n', 'v', }, silent = true, desc = 'Telescope help_tags', },
  { '<leader>svvo', function() require 'config.telescope'.vim_options() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope vim_options', },
  { '<leader>svvp', function() require 'config.telescope'.planets() end,     mode = { 'n', 'v', }, silent = true, desc = 'Telescope planets', },
  { '<leader>ss',   function() require 'config.telescope'.grep_string() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope grep_string', },
  { '<leader>sm',   function() require 'config.telescope'.keymaps() end,     mode = { 'n', 'v', }, silent = true, desc = 'Telescope keymaps', },
}

TelescopeKeysMore = {
  { '<leader>sa',        function() require 'config.telescope'.my_file_browser() end,      mode = { 'n', 'v', }, silent = true, desc = 'Telescope my_file_browser', },
  { '<leader>gf',        function() require 'config.telescope'.git_status() end,           mode = { 'n', 'v', }, silent = true, desc = 'Telescope git_status', },
  { '<leader>sb',        function() require 'config.telescope'.buffers() end,              mode = { 'n', 'v', }, silent = true, desc = 'Telescope buffers', },
  { '<leader>s<leader>', function() require 'config.telescope'.find_files() end,           mode = { 'n', 'v', }, silent = true, desc = 'Telescope find_files', },
  { '<leader>sc',        function() require 'config.telescope'.command_history() end,      mode = { 'n', 'v', }, silent = true, desc = 'Telescope command_history', },
  { '<leader>svb',       function() require 'config.telescope'.buffers_cur() end,          mode = { 'n', 'v', }, silent = true, desc = 'Telescope buffers_cur', },
  { '<leader>sj',        function() require 'config.telescope'.jumplist() end,             mode = { 'n', 'v', }, silent = true, desc = 'Telescope jumplist', },
  { '<leader>fl',        function() require 'config.telescope'.lsp_document_symbols() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope lsp_document_symbols', },
  { '<leader>se',        function() require 'config.telescope'.file_browser_cur() end,     mode = { 'n', 'v', }, silent = true, desc = 'Telescope file_browser_cur', },
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

for _, k in ipairs(TelescopeKeyF12) do
  keys[#keys + 1] = k
end

for _, k in ipairs(TelescopeKeysMore) do
  keys[#keys + 1] = k
end

for _, k in ipairs(TelescopeKeysUiAll) do
  keys[#keys + 1] = k
end

for _, k in ipairs(TelescopeKeysLess) do
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
    'ahmedkhalf/project.nvim',
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
