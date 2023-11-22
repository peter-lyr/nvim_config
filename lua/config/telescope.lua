local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
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
          height = 0.90,
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
          ['<C-,>'] = actions.close,

          ['<Down>'] = actions.move_selection_next,
          ['<Up>'] = actions.move_selection_previous,

          ['<C-l>'] = actions.select_default,
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

          ['<c-g>'] = {
            '<c-r>=fnamemodify(bufname(g:last_buf), ":t")<cr>',
            type = 'command',
            opts = { nowait = true, silent = true, desc = '5j', },
          },

          ['<c-l>'] = {
            [[<c-r>=g:curline<cr>]],
            type = 'command',
            opts = { nowait = true, silent = true, desc = '5j', },
          },

          ['<c-=>'] = {
            [[<c-r>=trim(getreg("+"))<cr>]],
            type = 'command',
            opts = { nowait = true, silent = true, desc = '5j', },
          },

          ["<c-'>"] = {
            [[<c-r>=g:single_quote<cr>]],
            type = 'command',
            opts = { nowait = true, silent = true, desc = 'g:single_quote', },
          },

          ["<c-s-'>"] = {
            [[<c-r>=g:double_quote<cr>]],
            type = 'command',
            opts = { nowait = true, silent = true, desc = 'g:double_quote', },
          },

          ['<c-0>'] = {
            [[<c-r>=g:parentheses<cr>]],
            type = 'command',
            opts = { nowait = true, silent = true, desc = 'g:parentheses', },
          },

          ['<c-]>'] = {
            [[<c-r>=g:bracket<cr>]],
            type = 'command',
            opts = { nowait = true, silent = true, desc = 'g:bracket', },
          },

          ['<c-s-]>'] = {
            [[<c-r>=g:brace<cr>]],
            type = 'command',
            opts = { nowait = true, silent = true, desc = 'g:brace', },
          },

          ['<c-`>'] = {
            [[<c-r>=g:back_quote<cr>]],
            type = 'command',
            opts = { nowait = true, silent = true, desc = 'g:back_quote', },
          },

          ['<c-s-.>'] = {
            [[<c-r>=g:angle_bracket<cr>]],
            type = 'command',
            opts = { nowait = true, silent = true, desc = 'g:angle_bracket', },
          },

          -- ["<c-'>"] = actions.move_selection_next,
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
            actions.select_default,
            type = 'action',
            opts = { nowait = true, silent = true, },
          },
          ['<RightMouse>'] = actions_layout.toggle_preview,
          ['<MiddleMouse>'] = {
            actions.close,
            type = 'action',
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
            actions.select_default,
            type = 'action',
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
            actions.select_default,
            type = 'action',
            opts = { nowait = true, silent = true, },
          },
          ['<RightMouse>'] = actions_layout.toggle_preview,
          ['<MiddleMouse>'] = {
            actions.close,
            type = 'action',
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

-- M.add_ignore_patterns(M.ignore_patterns, {
--   'audio_lhdc',
--   'audio_test',
--   'MSVC',
-- })

-- M.add_ignore_patterns(M.ignore_patterns, {
--   'standard',
-- })

-- M.add_ignore_patterns(M.ignore_patterns, {
--   'test',
-- })

-- M.add_ignore_patterns(M.ignore_patterns, {
--   'map.txt',
--   '%.map',
--   '%.lst',
--   '%.S',
-- })

M.add_ignore_patterns(M.ignore_patterns, {
  'SDK_AB13X_S1266_20231117',
})

M.add_ignore_patterns(M.ignore_patterns, {
  '%.log',
})

telescope.setup(M.get_setup_table(M.ignore_patterns))

function M.setreg()
  vim.g.telescope_entered = true
  local bak = vim.fn.getreg '"'
  local save_cursor = vim.fn.getpos '.'
  local line = vim.fn.trim(vim.fn.getline '.')
  vim.g.curline = line
  if string.match(line, [[%']]) then
    vim.cmd "silent norm yi'"
    vim.g.single_quote = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, [[%"]]) then
    vim.cmd 'silent norm yi"'
    vim.g.double_quote = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, [[%`]]) then
    vim.cmd 'silent norm yi`'
    vim.g.back_quote = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, [[%)]]) then
    vim.cmd 'silent norm yi)'
    vim.g.parentheses = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, '%]') then
    vim.cmd 'silent norm yi]'
    vim.g.bracket = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, [[%}]]) then
    vim.cmd 'silent norm yi}'
    vim.g.brace = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  if string.match(line, [[%>]]) then
    vim.cmd 'silent norm yi>'
    vim.g.angle_bracket = vim.fn.getreg '"' ~= bak and vim.fn.getreg '"' or ''
    pcall(vim.fn.setpos, '.', save_cursor)
  end
  vim.fn.setreg('"', bak)
  B.set_timeout(4000, function()
    vim.g.telescope_entered = nil
  end)
end

function M.search_all_en(all)
  if all == 1 then
    local temp = {}
    telescope.setup(M.get_setup_table(temp))
  else
    telescope.setup(M.get_setup_table(M.ignore_patterns))
  end
end

M.cur_root = {}

function M.cur_root_sel_do(dir)
  M.cur_root[B.rep_baskslash_lower(vim.fn['ProjectRootGet'](dir))] = B.rep_baskslash_lower(dir)
end

function M.cur_root_sel()
  local dirs = B.get_file_dirs_till_git()
  if dirs and #dirs == 1 then
    M.cur_root_sel_do(dirs[1])
  else
    B.ui_sel(dirs, 'sel as telescope root', function(dir)
      M.cur_root_sel_do(dir)
    end)
  end
end

function M.find_files()
  M.setreg()
  M.search_all_en(0)
  local root_dir = B.rep_baskslash_lower(vim.fn['ProjectRootGet']())
  if not B.is(vim.tbl_contains(vim.tbl_keys(M.cur_root), root_dir)) then
    vim.cmd 'Telescope find_files'
  else
    B.cmd('Telescope find_files cwd=%s', M.cur_root[root_dir])
  end
end

function M.find_files_all()
  M.setreg()
  M.search_all_en(1)
  if not B.is(vim.tbl_contains(vim.tbl_keys(M.cur_root), root_dir)) then
    vim.cmd 'Telescope find_files find_command=fd,--no-ignore,--hidden'
  else
    B.cmd('Telescope find_files find_command=fd,--no-ignore,--hidden cwd=%s', M.cur_root[root_dir])
  end
end

function M.live_grep()
  M.setreg()
  M.search_all_en(0)
  if not B.is(vim.tbl_contains(vim.tbl_keys(M.cur_root), root_dir)) then
    vim.cmd 'Telescope live_grep'
  else
    B.cmd('Telescope live_grep cwd=%s', M.cur_root[root_dir])
  end
end

function M.live_grep_all()
  M.setreg()
  M.search_all_en(1)
  if not B.is(vim.tbl_contains(vim.tbl_keys(M.cur_root), root_dir)) then
    vim.cmd 'Telescope live_grep vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,--smart-case,--fixed-strings,-g,*'
  else
    B.cmd('Telescope live_grep vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,--smart-case,--fixed-strings,-g,* cwd=%s', M.cur_root[root_dir])
  end
end

function M.live_grep_def()
  M.setreg()
  M.search_all_en(0)
  B.ui_sel(B.get_file_dirs_till_git(), 'which cwd', function(cwd)
    if cwd then
      B.cmd([[Telescope live_grep cwd=%s]], cwd)
    end
  end)
end

function M.live_grep_def_all()
  M.setreg()
  M.search_all_en(0)
  B.ui_sel(B.get_file_dirs(), 'which cwd', function(cwd)
    if cwd then
      B.cmd([[Telescope live_grep cwd=%s]], cwd)
    end
  end)
end

function M.live_grep_rg_do(dir)
  if dir then
    B.ui_sel({ '--fixed-strings', '', }, 'telescope_rg_fixed_strings', function(opt)
      if opt then
        local fixed_strings = opt
        local cmd = vim.fn.input('telescope_rg_patt: ', [[[\u4e00-\u9fa5]+]])
        if #cmd > 0 then
          B.system_run('asyncrun',
            'rg --no-heading --with-filename --line-number --column --smart-case --no-ignore %s -g !*.js %s "%s"',
            fixed_strings, cmd, dir)
        end
      end
    end)
  end
end

function M.live_grep_rg()
  local dirs = B.get_file_dirs_till_git()
  if dirs and #dirs == 1 then
    M.live_grep_rg_do(dirs[1])
  else
    B.ui_sel(dirs, 'telescope_rg_path', function(dir)
      M.live_grep_rg_do(dir)
    end)
  end
end

function M.live_grep_rg_all()
  local dirs = B.get_file_dirs()
  if dirs and #dirs == 1 then
    M.live_grep_rg_do(dirs[1])
  else
    B.ui_sel(dirs, 'telescope_rg_path', function(dir)
      M.live_grep_rg_do(dir)
    end)
  end
end

function M.search_history()
  M.setreg()
  vim.cmd 'Telescope search_history'
end

function M.command_history()
  M.setreg()
  vim.cmd 'Telescope command_history'
end

function M.commands()
  M.setreg()
  vim.cmd 'Telescope commands'
end

function M.buffers_cur()
  M.setreg()
  vim.cmd 'Telescope buffers cwd_only=true sort_mru=true ignore_current_buffer=true'
end

function M.jumplist()
  M.setreg()
  vim.cmd 'Telescope jumplist show_line=false'
end

function M.diagnostics()
  M.setreg()
  vim.cmd 'Telescope diagnostics'
end

function M.filetypes()
  M.setreg()
  vim.cmd 'Telescope filetypes'
end

function M.quickfix()
  M.setreg()
  vim.cmd 'Telescope quickfix'
end

function M.quickfixhistory()
  M.setreg()
  vim.cmd 'Telescope quickfixhistory'
end

function M.builtin()
  M.setreg()
  vim.cmd 'Telescope builtin'
end

function M.colorscheme()
  M.setreg()
  vim.cmd 'Telescope colorscheme'
end

function M.git_branches()
  M.setreg()
  vim.cmd 'Telescope git_branches'
end

function M.git_commits()
  M.setreg()
  vim.cmd 'Telescope git_commits'
end

function M.git_bcommits()
  M.setreg()
  vim.cmd 'Telescope git_bcommits'
end

function M.lsp_document_symbols()
  M.setreg()
  vim.cmd 'Telescope lsp_document_symbols'
end

function M.lsp_references()
  M.setreg()
  vim.cmd 'Telescope lsp_references'
end

function M.help_tags()
  M.setreg()
  vim.cmd 'Telescope help_tags'
end

function M.vim_options()
  M.setreg()
  vim.cmd 'Telescope vim_options'
end

function M.planets()
  M.setreg()
  vim.cmd 'Telescope planets'
end

function M.grep_string()
  M.setreg()
  vim.cmd 'Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search= grep_open_files=true'
end

function M.keymaps()
  M.setreg()
  vim.cmd 'Telescope keymaps'
end

function M.git_status()
  M.setreg()
  vim.cmd 'Telescope git_status'
end

function M.buffers()
  M.setreg()
  vim.cmd 'Telescope buffers'
end

function M.nop()
  M.setreg()
end

----------

function M.buffers_term()
  M.buffers()
  B.set_timeout(80, function()
    vim.cmd [[call feedkeys("term")]]
  end)
end

--------------------
-- open config
--------------------

function M.open()
  vim.cmd('edit ' .. M.source)
end

function M.my_projects()
  M.setreg()
  require 'config.telescope_projects'.my_projects()
end

B.aucmd(M.source, 'BufEnter-telescope', { 'BufEnter', }, {
  callback = function(ev)
    local filetype = vim.api.nvim_buf_get_option(ev.buf, 'filetype')
    local buftype = vim.api.nvim_buf_get_option(ev.buf, 'buftype')
    local bufname = vim.api.nvim_buf_get_name(ev.buf)
    if filetype == '' and buftype == '' and bufname == '' then
      vim.api.nvim_buf_set_option(ev.buf, 'buftype', 'nofile')
    end
  end,
})

return M
