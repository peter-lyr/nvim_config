local telescope = require('telescope')
local actions = require('telescope.actions')
local actions_layout = require('telescope.actions.layout')

vim.cmd([[
autocmd User TelescopePreviewerLoaded setlocal number | setlocal wrap
]])

local get_setup_table = function(file_ignore_patterns)
  return {
    defaults = {
      layout_strategy = 'horizontal',
      layout_config = {
        height = 0.99,
        width = 0.99,
      },
      -- preview = {
      --   hide_on_startup = true,
      -- },
      mappings = {
        i = {
          ['<a-m>'] = actions.close,
          ['qm'] = actions.close,

          ['<a-j>'] = actions.move_selection_next,
          ['<a-k>'] = actions.move_selection_previous,

          ['<a-;>'] = actions.send_to_qflist + actions.open_qflist,
          ['q;'] = actions.send_to_qflist + actions.open_qflist,

          ['<c-j>'] = actions.select_horizontal,
          ['<c-l>'] = actions.select_vertical,
          ['<c-k>'] = actions.select_tab,

          ['<c-o>'] = actions.select_default,
          ['qo'] = actions.select_default,

          ['qw'] = actions_layout.toggle_preview,

          ['qj'] = function(prompt_bufnr)
            actions.move_selection_next(prompt_bufnr)
            vim.cmd([[call feedkeys("\<esc>")]])
          end,
          ['qk'] = function(prompt_bufnr)
            actions.move_selection_previous(prompt_bufnr)
            vim.cmd([[call feedkeys("\<esc>")]])
          end,
        },
        n = {
          ['<a-m>'] = actions.close,
          ['ql'] = actions.close,
          ['qm'] = actions.close,

          ['<a-j>'] = actions.move_selection_next,
          ['<a-k>'] = actions.move_selection_previous,

          ['<a-;>'] = actions.send_to_qflist + actions.open_qflist,
          ['q;'] = actions.send_to_qflist + actions.open_qflist,

          ['<c-j>'] = actions.select_horizontal,
          ['<c-l>'] = actions.select_vertical,
          ['<c-k>'] = actions.select_tab,

          ['qo'] = actions.select_default,
          ['<c-o>'] = actions.select_default,
          ['o'] = actions.select_default,

          ['w'] = actions_layout.toggle_preview,
        }
      },
      file_ignore_patterns = file_ignore_patterns,
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--fixed-strings',
      },
      wrap_results = false,
    },
  }
end

local add = function(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
  return t1
end

local t = {}

add(t, {
  '%.svn',
  '%.vs',
  '%.git',
  '%.cache',
  'obj',
  'build',
  'my%-neovim%-data',
  '%.js',
  '%.asc',
  '%.hex',
  'CMakeLists.txt',
})

-- add(t, {
--   'audio_lhdc',
--   'audio_test',
--   'MSVC',
-- })

-- add(t, {
--   'standard',
-- })

-- add(t, {
--   'map.txt',
--   '%.map',
--   '%.lst',
--   '%.S',
-- })

telescope.setup(get_setup_table(t))

vim.keymap.set({ 'n', 'v' }, '<leader>sh',         ':<c-u>Telescope search_history<cr>', { silent = true, desc = 'Telescope search_history' })
vim.keymap.set({ 'n', 'v' }, '<leader>sc',         ':<c-u>Telescope command_history<cr>', { silent = true, desc = 'Telescope command_history' })
vim.keymap.set({ 'n', 'v' }, '<leader>sC',         ':<c-u>Telescope commands<cr>', { silent = true, desc = 'Telescope commands' })

vim.keymap.set({ 'n', 'v' }, '<leader>so',         ':<c-u>Telescope oldfiles previewer=false<cr>', { silent = true, desc = 'Telescope oldfiles' })
vim.keymap.set({ 'n', 'v' }, '<leader>sf',         ':<c-u>Telescope find_files previewer=false<cr>', { silent = true, desc = 'Telescope find_files' })
vim.keymap.set({ 'n', 'v' }, '<leader>sb',         ':<c-u>Telescope buffers cwd_only=true sort_mru=true ignore_current_buffer=true<cr>', { silent = true, desc = 'Telescope buffers cwd_only' })
vim.keymap.set({ 'n', 'v' }, '<leader>sB',         ':<c-u>Telescope buffers<cr>', { silent = true, desc = 'Telescope buffers' })

vim.keymap.set({ 'n', 'v' }, '<leader>sl',         ':<c-u>Telescope live_grep<cr>', { silent = true, desc = 'Telescope live_grep' })
vim.keymap.set({ 'n', 'v' }, '<leader>ss',         ':<c-u>Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search= grep_open_files=true<cr>', { silent = true, desc = 'Telescope grep_string' })
vim.keymap.set({ 'n', 'v' }, '<leader>sz',         ':<c-u>Telescope current_buffer_fuzzy_find<cr>', { silent = true, desc = 'Telescope current_buffer_fuzzy_find' })

vim.keymap.set({ 'n', 'v' }, '<leader>sq',         ':<c-u>Telescope quickfix<cr>', { silent = true, desc = 'Telescope quickfix' })
vim.keymap.set({ 'n', 'v' }, '<leader>sQ',         ':<c-u>Telescope quickfixhistory<cr>', { silent = true, desc = 'Telescope quickfixhistory' })

vim.keymap.set({ 'n', 'v' }, '<leader><leader>sa', ':<c-u>Telescope builtin<cr>', { silent = true, desc = 'Telescope builtin' })
vim.keymap.set({ 'n', 'v' }, '<leader><leader>sc', ':<c-u>Telescope colorscheme<cr>', { silent = true, desc = 'Telescope colorscheme' })
vim.keymap.set({ 'n', 'v' }, '<leader><leader>sd', ':<c-u>Telescope diagnostics<cr>', { silent = true, desc = 'Telescope diagnostics' })
vim.keymap.set({ 'n', 'v' }, '<leader><leader>sf', ':<c-u>Telescope filetypes<cr>', { silent = true, desc = 'Telescope filetypes' })
vim.keymap.set({ 'n', 'v' }, '<leader><leader>sh', ':<c-u>Telescope help_tags<cr>', { silent = true, desc = 'Telescope help_tags' })
vim.keymap.set({ 'n', 'v' }, '<leader><leader>sj', ':<c-u>Telescope jumplist<cr>', { silent = true, desc = 'Telescope jumplist' })
vim.keymap.set({ 'n', 'v' }, '<leader><leader>sm', ':<c-u>Telescope keymaps<cr>', { silent = true, desc = 'Telescope keymaps' })
vim.keymap.set({ 'n', 'v' }, '<leader><leader>so', ':<c-u>Telescope vim_options<cr>', { silent = true, desc = 'Telescope vim_options' })
vim.keymap.set({ 'n', 'v' }, '<leader><leader>sp', ':<c-u>Telescope planets<cr>', { silent = true, desc = 'Telescope planets' })
