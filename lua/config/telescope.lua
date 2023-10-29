local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

local telescope = require 'telescope'
local actions = require 'telescope.actions'
local actions_layout = require 'telescope.actions.layout'

vim.cmd [[
autocmd User TelescopePreviewerLoaded setlocal rnu | setlocal number | setlocal wrap
]]

function M.get_setup_table(file_ignore_patterns)
  return {
    defaults = {
      winblend = 10,
      layout_strategy = 'horizontal',
      layout_config = {
        horizontal = {
          preview_cutoff = 0,
          width = 0.99,
          height = 0.99,
        },
      },
      preview = {
        hide_on_startup = false,
        check_mime_type = true,
        -- timeout = 2000,
      },
      mappings = {
        i = {
          ['<C-n>'] = actions.move_selection_next,
          ['<C-p>'] = actions.move_selection_previous,

          ['<C-c>'] = actions.close,

          ['<Down>'] = actions.move_selection_next,
          ['<Up>'] = actions.move_selection_previous,

          ['<CR>'] = actions.select_default,
          ['<C-x>'] = actions.select_horizontal,
          ['<C-v>'] = actions.select_vertical,
          ['<C-t>'] = actions.select_tab,

          ['<C-u>'] = actions.preview_scrolling_up,
          ['<C-d>'] = actions.preview_scrolling_down,

          -- ['<PageUp>'] = actions.results_scrolling_up,
          -- ['<PageDown>'] = actions.results_scrolling_down,

          -- ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
          -- ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
          ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
          ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
          -- ['<C-l>'] = actions.complete_tag,
          ['<C-/>'] = actions.which_key,
          ['<C-_>'] = actions.which_key, -- keys from pressing <C-/>
          ['<C-w>'] = { '<c-s-w>', type = 'command', },

          -- disable c-j because we dont want to allow new lines #2123
          -- ['<C-j>'] = actions.nop,

          ['<F5>'] = actions_layout.toggle_preview,

          ["<c-'>"] = actions.move_selection_next,
          ['<c-;>'] = actions.move_selection_previous,
          ['<a-j>'] = actions.move_selection_next,
          ['<a-k>'] = actions.move_selection_previous,
          ['<f1>'] = actions.move_selection_next,
          ['<f2>'] = actions.move_selection_previous,
          ['<a-s-j>'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_next(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5j', },
          },
          ['<a-s-k>'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_previous(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5k', },
          },
          ['<f3>'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_next(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5j', },
          },
          ['<f4>'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_previous(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5k', },
          },
          ['<c-j>'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_next(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5j', },
          },
          ['<c-k>'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_previous(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5k', },
          },
          ['<PageDown>'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_next(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5j', },
          },
          ['<PageUp>'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_previous(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5k', },
          },

          ['<ScrollWheelDown>'] = actions.move_selection_next,
          ['<ScrollWheelUp>'] = actions.move_selection_previous,
          ['<LeftMouse>'] = {
            actions.select_default, type = 'action',
            opts = { nowait = true, silent = true, },
          },
          ['<RightMouse>'] = actions_layout.toggle_preview,
          ['<MiddleMouse>'] = {
            actions.close, type = 'action',
            opts = { nowait = true, silent = true, },
          },

        },

        n = {
          ['<CR>'] = actions.select_default,
          ['<C-x>'] = actions.select_horizontal,
          ['<C-v>'] = actions.select_vertical,
          ['<C-t>'] = actions.select_tab,

          -- ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
          -- ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
          ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
          ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

          -- TODO: This would be weird if we switch the ordering.
          ['j'] = actions.move_selection_next,
          ['k'] = actions.move_selection_previous,
          ['H'] = actions.move_to_top,
          ['M'] = actions.move_to_middle,
          ['L'] = actions.move_to_bottom,

          ['<Down>'] = actions.move_selection_next,
          ['<Up>'] = actions.move_selection_previous,
          -- ['gg'] = actions.move_to_top,
          ['G'] = actions.move_to_bottom,

          ['<C-u>'] = actions.preview_scrolling_up,
          ['<C-d>'] = actions.preview_scrolling_down,

          -- ['<PageUp>'] = actions.results_scrolling_up,
          -- ['<PageDown>'] = actions.results_scrolling_down,

          ['?'] = actions.which_key,

          ['<leader>'] = {
            actions.select_default, type = 'action',
            opts = { nowait = true, silent = true, },
          },
          ['q'] = actions.close,
          ['<esc>'] = actions.close,

          ['<F5>'] = actions_layout.toggle_preview,

          ["<c-'>"] = actions.move_selection_next,
          ['<c-;>'] = actions.move_selection_previous,
          ['<f1>'] = actions.move_selection_next,
          ['<f2>'] = actions.move_selection_previous,
          ['<f3>'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_next(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5j', },
          },
          ['<f4>'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_previous(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5k', },
          },
          ['<c-j>'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_next(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5j', },
          },
          ['<c-k>'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_previous(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5k', },
          },
          ['<PageDown>'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_next(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5j', },
          },
          ['<PageUp>'] = {
            function(prompt_bufnr)
              for _ = 1, 5 do
                actions.move_selection_previous(prompt_bufnr)
              end
            end,
            type = 'action',
            opts = { nowait = true, silent = true, desc = '5k', },
          },

          ['<ScrollWheelDown>'] = actions.move_selection_next,
          ['<ScrollWheelUp>'] = actions.move_selection_previous,
          ['<LeftMouse>'] = {
            actions.select_default, type = 'action',
            opts = { nowait = true, silent = true, },
          },
          ['<RightMouse>'] = actions_layout.toggle_preview,
          ['<MiddleMouse>'] = {
            actions.close, type = 'action',
            opts = { nowait = true, silent = true, },
          },

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
  }
end

function M.add_ignore_patterns(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
  return t1
end

M.ignore_patterns = {}

M.add_ignore_patterns(M.ignore_patterns, {
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

-- M.add_ignore_patterns(t, {
--   'audio_lhdc',
--   'audio_test',
--   'MSVC',
-- })

-- M.add_ignore_patterns(t, {
--   'standard',
-- })

-- M.add_ignore_patterns(t, {
--   'test',
-- })

-- M.add_ignore_patterns(t, {
--   'map.txt',
--   '%.map',
--   '%.lst',
--   '%.S',
-- })

M.add_ignore_patterns(M.ignore_patterns, {
  '%.log',
})

telescope.setup(M.get_setup_table(M.ignore_patterns))

function M.search_all_en(all)
  if all == 1 then
    local temp = {}
    telescope.setup(M.get_setup_table(temp))
  else
    telescope.setup(M.get_setup_table(M.ignore_patterns))
  end
end

function M.find_files()
  M.search_all_en(0)
  vim.cmd 'Telescope find_files'
end

function M.find_files_all()
  M.search_all_en(1)
  vim.cmd 'Telescope find_files find_command=fd,--no-ignore,--hidden'
end

function M.live_grep()
  M.search_all_en(0)
  vim.cmd 'Telescope live_grep'
end

function M.live_grep_all()
  M.search_all_en(1)
  vim.cmd 'Telescope live_grep vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,--smart-case,--fixed-strings,-g,*'
end

function M.live_grep_def()
  M.search_all_en(0)
  vim.cmd [[ call feedkeys("\<esc>:Telescope live_grep cwd=\<c-r>=expand('%:p:h')\<cr>") ]]
end

-- function M.live_grep_rg()
--   local fname = vim.api.nvim_buf_get_name(0)
--   local dirs = B.get_file_dirs(fname)
--   B.ui_sel(dirs, 'telescope_rg_path', function(path)
--     if path then
--       B.ui_sel({ '--fixed-strings', '', }, 'telescope_rg_fixed_strings', function(choice)
--         if choice then
--           local fixed_strings = choice
--           local cmd = vim.fn.input('telescope_rg_patt: ', [[[\u4e00-\u9fa5]+]])
--           if #cmd > 0 then
--             B.system_run('asyncrun',
--               'rg --no-heading --with-filename --line-number --column --smart-case --no-ignore %s -g !*.js %s "%s"',
--               fixed_strings, cmd, path)
--           end
--         end
--       end)
--     end
--   end)
-- end

function M.search_history()
  vim.cmd 'Telescope search_history'
end

function M.command_history()
  vim.cmd 'Telescope command_history'
end

function M.commands()
  vim.cmd 'Telescope commands'
end

function M.buffers_cur()
  vim.cmd 'Telescope buffers cwd_only=true sort_mru=true ignore_current_buffer=true'
end

function M.jumplist()
  vim.cmd 'Telescope jumplist show_line=false'
end

function M.diagnostics()
  vim.cmd 'Telescope diagnostics'
end

function M.filetypes()
  vim.cmd 'Telescope filetypes'
end

function M.quickfix()
  vim.cmd 'Telescope quickfix'
end

function M.quickfixhistory()
  vim.cmd 'Telescope quickfixhistory'
end

function M.builtin()
  vim.cmd 'Telescope builtin'
end

function M.colorscheme()
  vim.cmd 'Telescope colorscheme'
end

function M.git_branches()
  vim.cmd 'Telescope git_branches'
end

function M.git_commits()
  vim.cmd 'Telescope git_commits'
end

function M.git_bcommits()
  vim.cmd 'Telescope git_bcommits'
end

function M.lsp_document_symbols()
  vim.cmd 'Telescope lsp_document_symbols'
end

function M.lsp_references()
  vim.cmd 'Telescope lsp_references'
end

function M.help_tags()
  vim.cmd 'Telescope help_tags'
end

function M.vim_options()
  vim.cmd 'Telescope vim_options'
end

function M.planets()
  vim.cmd 'Telescope planets'
end

function M.grep_string()
  vim.cmd 'Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search= grep_open_files=true'
end

function M.keymaps()
  vim.cmd 'Telescope keymaps'
end

function M.git_status()
  vim.cmd 'Telescope git_status'
end

function M.buffers()
  vim.cmd 'Telescope buffers'
end

--------------------
-- open config
--------------------

function M.open()
  vim.cmd('edit ' .. M.source)
end

function M.my_projects()
  B.call_sub(M.loaded, 'projects', 'my_projects')
end

return M
