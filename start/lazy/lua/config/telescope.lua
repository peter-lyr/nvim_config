local telescope = require 'telescope'
local actions = require 'telescope.actions'
local actions_layout = require 'telescope.actions.layout'

vim.cmd [[
autocmd User TelescopePreviewerLoaded setlocal rnu | setlocal number | setlocal wrap
]]

require 'which-key'.register { ['<leader>gt'] = { name = 'Telescope', }, }

local fb_actions = require 'telescope._extensions.file_browser.actions'

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
          ['<C-n>'] = false, -- actions.move_selection_next,
          ['<C-p>'] = false, -- actions.move_selection_previous,

          ['<C-c>'] = false, -- actions.close,

          ['<C-x>'] = false, -- actions.select_horizontal,
          ['<C-v>'] = false, -- actions.select_vertical,
          ['<C-t>'] = false, -- actions.select_tab,

          ['<C-q>'] = false, -- actions.send_to_qflist + actions.open_qflist,
          ['<M-q>'] = false, -- actions.send_selected_to_qflist + actions.open_qflist,
          ['<C-l>'] = false, -- actions.complete_tag,
          ['<C-_>'] = false, -- actions.which_key, -- keys from pressing <C-/>

          -- normal <c-w>
          ['<C-w>'] = { '<c-s-w>', type = 'command', },

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
            actions.close, type = 'action',
            opts = { nowait = true, silent = true, },
          },

          ['s'] = actions.move_selection_next,
          ['w'] = actions.move_selection_previous,

          ['d'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_next(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5j', },
          },
          ['e'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_previous(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5k', },
          },

          ['f'] = actions.send_to_qflist + actions.open_qflist,

          ['x'] = actions.select_horizontal,
          ['v'] = actions.select_vertical,
          ['t'] = actions.select_tab,

          ['<leader>'] = {
            actions.select_default, type = 'action',
            opts = { nowait = true, silent = true, },
          },

          ['g'] = actions_layout.toggle_preview,
        },
      },
      file_ignore_patterns = file_ignore_patterns,
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--no-ignore',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--fixed-strings',
      },
      wrap_results = true,
    },
    extensions = {
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = 'smart_case',       -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
      my_file_browser = {
        mappings = {
          ['i'] = {
            ['<A-c>'] = false,  -- fb_actions.create,
            ['<S-CR>'] = false, -- fb_actions.create_from_prompt,
            ['<A-r>'] = false,  -- fb_actions.rename,
            ['<A-m>'] = false,  -- fb_actions.move,
            ['<A-y>'] = false,  -- fb_actions.copy,
            ['<A-d>'] = false,  -- fb_actions.remove,
            ['<C-o>'] = false,  -- fb_actions.open,
            ['<C-g>'] = false,  -- fb_actions.goto_parent_dir,
            ['<C-e>'] = false,  -- fb_actions.goto_home_dir,
            ['<C-w>'] = { '<c-s-w>', type = 'command', },
            ['<C-t>'] = false,  -- fb_actions.change_cwd,
            ['<C-f>'] = false,  -- fb_actions.toggle_browser,
            ['<C-h>'] = false,  -- fb_actions.toggle_hidden,
            ['<C-s>'] = false,  -- fb_actions.toggle_all,
            ['<bs>'] = false,   -- fb_actions.backspace,
          },
          ['n'] = {
            ['c'] = false, -- fb_actions.create,
            ['r'] = false, -- fb_actions.rename,
            ['m'] = false, -- fb_actions.move,
            ['y'] = false, -- fb_actions.copy,
            -- ["d"] = false, -- fb_actions.remove,
            ['o'] = false, -- fb_actions.open,
            -- ["g"] = false, -- fb_actions.goto_parent_dir,
            -- ["e"] = false, -- fb_actions.goto_home_dir,
            -- ["w"] = false, -- fb_actions.goto_cwd,
            -- ["t"] = false, -- fb_actions.change_cwd,
            -- ["f"] = false, -- fb_actions.toggle_browser,
            ['h'] = fb_actions.toggle_hidden,
            -- ["s"] = false, -- fb_actions.toggle_all,
          },
        },
      },
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

add(t, {
  '%.log',
})

telescope.setup(get_setup_table(t))

local M = {}

M.all = function(all)
  if all == 1 then
    local temp = {}
    telescope.setup(get_setup_table(temp))
  else
    telescope.setup(get_setup_table(t))
  end
end

M.find_files = function()
  M.all(0)
  vim.cmd 'Telescope find_files'
end

M.find_files_all = function()
  M.all(1)
  vim.cmd 'Telescope find_files find_command=fd,--no-ignore,--hidden'
end

M.live_grep = function()
  M.all(0)
  vim.cmd 'Telescope live_grep'
end

M.live_grep_all = function()
  M.all(1)
  vim.cmd 'Telescope live_grep vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,--smart-case,--fixed-strings,-g,*'
end

M.live_grep_def = function()
  M.all(0)
  vim.cmd [[ call feedkeys("\<esc>:Telescope live_grep cwd=\<c-r>=expand('%:p:h')\<cr>") ]]
end

local p = require 'plenary.path'

-- fzf

pcall(telescope.load_extension, 'fzf')

-- old files

vim.g.sqlite_clib_path = p:new(vim.g.pack_path):parent():parent():parent():parent():parent()
    :joinpath('sqlite3', 'sqlite3.dll').filename

pcall(telescope.load_extension, 'frecency')

-- file browser

pcall(telescope.load_extension, 'my_file_browser')

M.nvim_config = p:new(vim.g.pack_path):joinpath 'nvim_config'

M.open = function()
  vim.cmd('cd ' .. M.nvim_config.filename .. '|e ' .. 'start/lazy/lua/config/telescope.lua')
end

vim.api.nvim_create_autocmd({ 'BufEnter', }, {
  callback = function()
    if vim.fn.bufname() == '' then
      local bufnr = vim.fn.bufnr()
      if vim.api.nvim_buf_get_option(bufnr, 'buftype') == '' then
        vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')
      end
    end
  end,
})

return M
