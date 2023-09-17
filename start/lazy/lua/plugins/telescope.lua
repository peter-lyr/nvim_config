TelescopeKeysLess = {
  { '<leader>svh',  '<cmd>Telescope help_tags<cr>',                                                                                    mode = { 'n', 'v', }, silent = true, desc = 'Telescope help_tags', },
  { '<leader>svvo', '<cmd>Telescope vim_options<cr>',                                                                                  mode = { 'n', 'v', }, silent = true, desc = 'Telescope vim_options', },
  { '<leader>svvp', '<cmd>Telescope planets<cr>',                                                                                      mode = { 'n', 'v', }, silent = true, desc = 'Telescope planets', },
  { '<leader>ss',   '<cmd>Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search= grep_open_files=true<cr>', mode = { 'n', 'v', }, silent = true, desc = 'Telescope grep_string', },
  { '<leader>sm',   '<cmd>Telescope keymaps<cr>',                                                                                      mode = { 'n', 'v', }, silent = true, desc = 'Telescope keymaps', },
}

TelescopeKeysMore = {
  { '<leader>sa',         '<cmd>Telescope my_file_browser<cr>',                                                                             mode = { 'n', 'v', }, silent = true, desc = 'Telescope file_browser', },
  { '<leader>gf',        ':<c-u>Telescope git_status<cr>',                       mode = { 'n', 'v', }, silent = true, desc = 'Telescope git_status', },
  { '<leader>sb',        '<cmd>Telescope buffers<cr>',                           mode = { 'n', 'v', }, silent = true, desc = 'Telescope buffers', },
}

TelescopeKeys = {

  { '<leader>sk',         function() require 'config.telescope'.open_project() end,                                                         mode = { 'n', 'v', }, silent = true, desc = 'Telescope projects', },
  { '<leader>s<leader>', function() require 'config.telescope'.find_files() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope find_files', },
  { '<leader>sv<leader>', function() require 'config.telescope'.find_files_all() end,                                                       mode = { 'n', 'v', }, silent = true, desc = 'Telescope find_files all', },
  { '<leader>sh',         '<cmd>Telescope search_history<cr>',                                                                              mode = { 'n', 'v', }, silent = true, desc = 'Telescope search_history', },
  { '<leader>sc',         '<cmd>Telescope command_history<cr>',                                                                             mode = { 'n', 'v', }, silent = true, desc = 'Telescope command_history', },
  { '<leader>svc',        '<cmd>Telescope commands<cr>',                                                                                    mode = { 'n', 'v', }, silent = true, desc = 'Telescope commands', },
  { '<leader>so',         '<cmd>Telescope frecency<cr>',                                                                                    mode = { 'n', 'v', }, silent = true, desc = 'Telescope oldfiles', },
  { '<leader>svb',        '<cmd>Telescope buffers cwd_only=true sort_mru=true ignore_current_buffer=true<cr>',                              mode = { 'n', 'v', }, silent = true, desc = 'Telescope buffers cwd_only', },
  { '<leader>sj',         '<cmd>Telescope jumplist show_line=false<cr>',                                                                                    mode = { 'n', 'v', }, silent = true, desc = 'Telescope jumplist', },
  { '<leader>sd',         '<cmd>Telescope diagnostics<cr>',                                                                                 mode = { 'n', 'v', }, silent = true, desc = 'Telescope diagnostics', },
  { '<leader>sf',         '<cmd>Telescope filetypes<cr>',                                                                                   mode = { 'n', 'v', }, silent = true, desc = 'Telescope filetypes', },
  { '<leader>sz',         '<cmd>Telescope current_buffer_fuzzy_find<cr>',                                                                   mode = { 'n', 'v', }, silent = true, desc = 'Telescope current_buffer_fuzzy_find', },
  { '<leader>sq',         '<cmd>Telescope quickfix<cr>',                                                                                    mode = { 'n', 'v', }, silent = true, desc = 'Telescope quickfix', },
  { '<leader>svq',        '<cmd>Telescope quickfixhistory<cr>',                                                                             mode = { 'n', 'v', }, silent = true, desc = 'Telescope quickfixhistory', },
  { '<leader>svva',       '<cmd>Telescope builtin<cr>',                                                                                     mode = { 'n', 'v', }, silent = true, desc = 'Telescope builtin', },
  { '<leader>svc',        '<cmd>Telescope colorscheme<cr>',                                                                                 mode = { 'n', 'v', }, silent = true, desc = 'Telescope colorscheme', },

  -- git
  { '<leader>gh',         ':<c-u>Telescope git_branches<cr>',                                                                               mode = { 'n', 'v', }, silent = true, desc = 'Telescope git_branches', },
  { '<leader>gtc',        ':<c-u>Telescope git_commits<cr>',                                                                                mode = { 'n', 'v', }, silent = true, desc = 'Telescope git_commits', },
  { '<leader>gtb',        ':<c-u>Telescope git_bcommits<cr>',                                                                               mode = { 'n', 'v', }, silent = true, desc = 'Telescope git_bcommits', },

  -- lsp
  { '<leader>fl',         ':<c-u>Telescope lsp_document_symbols<cr>',                                                                       mode = { 'n', 'v', }, silent = true, desc = 'Telescope lsp_document_symbols', },
  { '<leader>fr',         ':<c-u>Telescope lsp_references<cr>',                                                                             mode = { 'n', 'v', }, silent = true, desc = 'Telescope lsp_references', },

  -- file browser
  { '<leader>sva',        function() vim.cmd(string.format('Telescope my_file_browser path=%s cwd_to_path=true', vim.fn.expand '%:h')) end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope file_browser cur', },

  -- config
  { '<leader>sO',         function() require 'config.telescope'.open() end,                                                                 mode = { 'n', 'v', }, silent = true, desc = 'Telescope open config file', },

}

local keys = {

  -- rg
  { '<leader>sl',     function() require 'config.telescope'.live_grep() end,     mode = { 'n', 'v', }, silent = true, desc = 'Telescope live_grep', },
  { '<leader>svl',    function() require 'config.telescope'.live_grep_all() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope live_grep all', },
  { '<leader>sL',     function() require 'config.telescope'.live_grep_def() end, mode = { 'n', 'v', }, silent = true, desc = 'Telescope live_grep def', },
  { '<leader>s<c-l>', function() require 'config.telescope'.live_grep_rg() end,  mode = { 'n', 'v', }, silent = true, desc = 'Telescope live_grep rg', },

  -- all
  { '<leader>sA',     function() require 'config.telescope'.ui_all() end,        mode = { 'n', 'v', }, silent = true, desc = 'Telescope ui_all', },

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
    'nvim-telescope/telescope-file-browser.nvim',
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
