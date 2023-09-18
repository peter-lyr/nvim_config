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
  { '<leader>so',        function() require 'config.telescope'.frecency() end,             mode = { 'n', 'v', }, silent = true, desc = 'Telescope frecency', },
  { '<leader>svb',       function() require 'config.telescope'.buffers_cur() end,          mode = { 'n', 'v', }, silent = true, desc = 'Telescope buffers_cur', },
  { '<leader>sj',        function() require 'config.telescope'.jumplist() end,             mode = { 'n', 'v', }, silent = true, desc = 'Telescope jumplist', },
  { '<leader>fl',        function() require 'config.telescope'.lsp_document_symbols() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope lsp_document_symbols', },
  { '<leader>se',        function() require 'config.telescope'.file_browser_cur() end,     mode = { 'n', 'v', }, silent = true, desc = 'Telescope file_browser_cur', },
  { '<c-s-f12><f1>',     function() require 'config.telescope'.my_file_browser() end,      mode = { 'n', 'v', }, silent = true, desc = 'Telescope my_file_browser', },
  { '<c-s-f12><f2>',     function() require 'config.telescope'.git_status() end,           mode = { 'n', 'v', }, silent = true, desc = 'Telescope git_status', },
  { '<c-s-f12><f3>',     function() require 'config.telescope'.buffers() end,              mode = { 'n', 'v', }, silent = true, desc = 'Telescope buffers', },
  { '<c-s-f12><f4>',     function() require 'config.telescope'.find_files() end,           mode = { 'n', 'v', }, silent = true, desc = 'Telescope find_files', },
  { '<c-s-f12><f5>',     function() require 'config.telescope'.frecency() end,             mode = { 'n', 'v', }, silent = true, desc = 'Telescope frecency', },
  { '<c-s-f12><f6>',     function() require 'config.telescope'.buffers_cur() end,          mode = { 'n', 'v', }, silent = true, desc = 'Telescope buffers_cur', },
  { '<c-s-f12><f7>',     function() require 'config.telescope'.jumplist() end,             mode = { 'n', 'v', }, silent = true, desc = 'Telescope jumplist', },
  { '<c-s-f12><f8>',     function() require 'config.telescope'.lsp_document_symbols() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope lsp_document_symbols', },
  { '<c-s-f12><f9>',     function() require 'config.telescope'.file_browser_cur() end,     mode = { 'n', 'v', }, silent = true, desc = 'Telescope file_browser_cur', },
}

TelescopeKeys = {

  { '<leader>sk',         function() require 'config.telescope'.my_projects() end,               mode = { 'n', 'v', }, silent = true, desc = 'Telescope my_projects', },
  { '<leader>sv<leader>', function() require 'config.telescope'.find_files_all() end,            mode = { 'n', 'v', }, silent = true, desc = 'Telescope find_files_all', },
  { '<leader>sh',         function() require 'config.telescope'.search_history()() end,          mode = { 'n', 'v', }, silent = true, desc = 'Telescope search_history', },
  { '<leader>sc',         function() require 'config.telescope'.command_history() end,           mode = { 'n', 'v', }, silent = true, desc = 'Telescope command_history', },
  { '<leader>svc',        function() require 'config.telescope'.commands() end,                  mode = { 'n', 'v', }, silent = true, desc = 'Telescope commands', },
  { '<leader>sd',         function() require 'config.telescope'.diagnostics() end,               mode = { 'n', 'v', }, silent = true, desc = 'Telescope diagnostics', },
  { '<leader>sf',         function() require 'config.telescope'.filetypes() end,                 mode = { 'n', 'v', }, silent = true, desc = 'Telescope filetypes', },
  { '<leader>sz',         function() require 'config.telescope'.current_buffer_fuzzy_find() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope current_buffer_fuzzy_find', },
  { '<leader>sq',         function() require 'config.telescope'.quickfix() end,                  mode = { 'n', 'v', }, silent = true, desc = 'Telescope quickfix', },
  { '<leader>svq',        function() require 'config.telescope'.quickfixhistory() end,           mode = { 'n', 'v', }, silent = true, desc = 'Telescope quickfixhistory', },
  { '<leader>svva',       function() require 'config.telescope'.builtin() end,                   mode = { 'n', 'v', }, silent = true, desc = 'Telescope builtin', },
  { '<leader>svc',        function() require 'config.telescope'.colorscheme() end,               mode = { 'n', 'v', }, silent = true, desc = 'Telescope colorscheme', },

  -- git
  { '<leader>gh',         function() require 'config.telescope'.git_branches() end,              mode = { 'n', 'v', }, silent = true, desc = 'Telescope git_branches', },
  { '<leader>gtc',        function() require 'config.telescope'.git_commits() end,               mode = { 'n', 'v', }, silent = true, desc = 'Telescope git_commits', },
  { '<leader>gtb',        function() require 'config.telescope'.git_bcommits() end,              mode = { 'n', 'v', }, silent = true, desc = 'Telescope git_bcommits', },

  -- lsp
  { '<leader>fr',         function() require 'config.telescope'.lsp_references() end,            mode = { 'n', 'v', }, silent = true, desc = 'Telescope lsp_references', },

  -- config
  { '<leader>sO',         function() require 'config.telescope'.open() end,                      mode = { 'n', 'v', }, silent = true, desc = 'Telescope open config file', },

}

local keys = {

  -- rg
  { '<leader>sl',     function() require 'config.telescope'.live_grep() end,     mode = { 'n', 'v', }, silent = true, desc = 'Telescope live_grep', },
  { '<leader>svl',    function() require 'config.telescope'.live_grep_all() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope live_grep_all', },
  { '<leader>sL',     function() require 'config.telescope'.live_grep_def() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope live_grep_def', },
  { '<leader>s<c-l>', function() require 'config.telescope'.live_grep_rg() end,  mode = { 'n', 'v', }, silent = true, desc = 'Telescope live_grep_rg', },

  -- all
  { '<leader>sA',     function() require 'config.telescope'.ui_all() end,        mode = { 'n', 'v', }, silent = true, desc = 'Telescope ui_all', },
  { '<c-s-f12><f10>', function() require 'config.telescope'.ui_all() end,        mode = { 'n', 'v', }, silent = true, desc = 'Telescope ui_all', },

}

for _, k in ipairs(TelescopeKeysMore) do
  keys[#keys + 1] = k
end

for _, k in ipairs(TelescopeKeys) do
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
