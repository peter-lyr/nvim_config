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
        horizontal = {
          preview_cutoff = 0,
        },
      },
      preview = {
        hide_on_startup = false,
        check_mime_type = true,
        -- timeout = 2000,
      },
      mappings = {
        i = {
          ["<C-n>"] = false, -- actions.move_selection_next,
          ["<C-p>"] = false, -- actions.move_selection_previous,

          ["<C-c>"] = false, -- actions.close,

          ["<C-x>"] = false, -- actions.select_horizontal,
          ["<C-v>"] = false, -- actions.select_vertical,
          ["<C-t>"] = false, -- actions.select_tab,

          ["<C-q>"] = false, -- actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = false, -- actions.send_selected_to_qflist + actions.open_qflist,
          ["<C-l>"] = false, -- actions.complete_tag,
          ["<C-_>"] = false, -- actions.which_key, -- keys from pressing <C-/>
          ["<C-w>"] = false, -- { "<c-s-w>", type = "command" },

          -- sometimes use:
          -- ["<Down>"] = false, -- actions.move_selection_next,
          -- ["<Up>"] = false, -- actions.move_selection_previous,

          -- ["<CR>"] = false, -- actions.select_default,
          -- ["<C-u>"] = false, -- actions.preview_scrolling_up,
          -- ["<C-d>"] = false, -- actions.preview_scrolling_down,

          -- ["<PageUp>"] = false, -- actions.results_scrolling_up,
          -- ["<PageDown>"] = false, -- actions.results_scrolling_down,

          -- ["<Tab>"] = false, -- actions.toggle_selection + actions.move_selection_worse,
          -- ["<S-Tab>"] = false, -- actions.toggle_selection + actions.move_selection_better,
          -- ["<C-/>"] = false, -- actions.which_key,
        },
        n = {
          ['q'] = {
            actions.close, type = "action",
            opts = { nowait = true, silent = true }
          },

          ['s'] = actions.move_selection_next,
          ['w'] = actions.move_selection_previous,

          ['d'] = {
            actions.move_selection_next + actions.move_selection_next + actions.move_selection_next +
            actions.move_selection_next + actions.move_selection_next,
            type = "action",
            opts = { nowait = true, silent = true }
          },
          ['e'] = {
            actions.move_selection_previous + actions.move_selection_previous + actions.move_selection_previous +
            actions.move_selection_previous + actions.move_selection_previous,
            type = "action",
            opts = { nowait = true, silent = true }
          },

          ['f'] = actions.send_to_qflist + actions.open_qflist,

          ['x'] = actions.select_horizontal,
          ['v'] = actions.select_vertical,
          ['t'] = actions.select_tab,

          ['<leader>'] = {
            actions.select_default, type = "action",
            opts = { nowait = true, silent = true }
          },

          ['g'] = actions_layout.toggle_preview,
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
    extensions = {
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      }
    }
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

local p = require('plenary.path')

-- fzf

pcall(telescope.load_extension, 'fzf')

-- old files

vim.g.sqlite_clib_path = p:new(vim.g.pack_path):parent():parent():parent():parent():parent()
    :joinpath('sqlite3', 'sqlite3.dll').filename

pcall(telescope.load_extension, 'frecency')


local M = {}

M.nvim_config = p:new(vim.g.pack_path):joinpath('nvim_config')

M.open = function()
  vim.cmd('cd ' .. M.nvim_config.filename .. '|e ' .. 'start/lazy/lua/config/telescope.lua')
end

return M
