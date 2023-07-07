local telescope = require('telescope')
local actions = require('telescope.actions')
local actions_layout = require('telescope.actions.layout')

vim.cmd([[
autocmd User TelescopePreviewerLoaded setlocal rnu | setlocal number | setlocal wrap
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

          ['qn'] = actions_layout.toggle_preview,

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

          ['n'] = actions_layout.toggle_preview,
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
--   'test',
-- })

-- add(t, {
--   'map.txt',
--   '%.map',
--   '%.lst',
--   '%.S',
-- })

telescope.setup(get_setup_table(t))

local M = {}

local p = require('plenary.path')

M.nvim_config = p:new(vim.g.pack_path):joinpath('nvim_config')

M.open = function()
  vim.cmd('cd ' .. M.nvim_config.filename .. '|e ' .. 'start/lazy/lua/config/telescope.lua')
end

return M
