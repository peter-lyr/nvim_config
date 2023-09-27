package.loaded['config.telescope'] = nil

local telescope = require 'telescope'
local actions = require 'telescope.actions'
local actions_layout = require 'telescope.actions.layout'

vim.cmd [[
autocmd User TelescopePreviewerLoaded setlocal rnu | setlocal number | setlocal wrap
]]

local fb_actions = require 'telescope._extensions.file_browser.actions'

local get_setup_table = function(file_ignore_patterns)
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

          ['<c-l>'] = { '<esc>', type = 'command', },

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

          ['<c-l>'] = {
            actions.close, type = 'action',
            opts = { nowait = true, silent = true, },
          },

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
    extensions = {
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = 'smart_case',       -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
      my_file_browser = {
        grouped = true,
        select_buffer = true,
        prompt_path = true,
        collapse_dirs = true,
        files = false,
        mappings = {
          ['i'] = {
            ['<A-c>'] = fb_actions.create,
            ['<S-CR>'] = fb_actions.create_from_prompt,
            ['<A-r>'] = fb_actions.rename,
            ['<A-m>'] = fb_actions.move,
            ['<A-y>'] = fb_actions.copy,
            ['<A-d>'] = fb_actions.remove,
            ['<C-o>'] = fb_actions.open,
            ['<C-g>'] = fb_actions.goto_parent_dir,
            ['<C-e>'] = fb_actions.goto_home_dir,
            ['<C-w>'] = fb_actions.goto_cwd,
            ['<C-t>'] = fb_actions.change_cwd,
            ['<C-f>'] = fb_actions.toggle_browser,
            ['<C-h>'] = fb_actions.toggle_hidden,
            ['<C-s>'] = fb_actions.toggle_all,
            ['<bs>'] = fb_actions.backspace,
          },
          ['n'] = {
            ['c'] = fb_actions.create,
            ['r'] = fb_actions.rename,
            ['m'] = fb_actions.move,
            ['y'] = fb_actions.copy,
            ['d'] = fb_actions.remove,
            ['o'] = fb_actions.open,
            ['g'] = fb_actions.goto_parent_dir,
            ['e'] = fb_actions.goto_home_dir,
            ['w'] = fb_actions.goto_cwd,
            ['t'] = fb_actions.change_cwd,
            ['f'] = fb_actions.toggle_browser,
            ['h'] = fb_actions.toggle_hidden,
            ['s'] = fb_actions.toggle_all,
            ['<leader>'] = fb_actions.open,
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

local function get_dirs(fname)
  local fpath = require 'plenary.path':new(fname)
  if not fpath:is_file() then
    vim.cmd 'ec "not file"'
    return nil
  end
  local dirs = {}
  for _ = 1, 24 do
    fpath = fpath:parent()
    local name = string.gsub(fpath.filename, '\\', '/')
    table.insert(dirs, name)
    if not string.match(name, '/') then
      break
    end
  end
  return dirs
end

M.live_grep_rg = function()
  local fname = vim.api.nvim_buf_get_name(0)
  local dirs = get_dirs(fname)
  if not dirs then
    return
  end
  vim.ui.select(dirs, { prompt = 'telescope_rg_path', }, function(choice)
    if not choice then
      return
    end
    local path = choice
    vim.ui.select({ '--fixed-strings', '', }, { prompt = 'telescope_rg_fixed_strings', }, function(choice)
      if not choice then
        return
      end
      local fixed_strings = choice
      local cmd = vim.fn.input('telescope_rg_patt: ', [[[\u4e00-\u9fa5]+]])
      if #cmd > 0 then
        vim.cmd(string.format('AsyncRun rg --no-heading --with-filename --line-number --column --smart-case --no-ignore %s -g !*.js %s "%s"', fixed_strings, cmd, path))
      end
    end)
  end)
end

--------------------
-- telescope
--------------------

M.search_history = function()
  vim.cmd 'Telescope search_history'
end

M.command_history = function()
  vim.cmd 'Telescope command_history'
end

M.commands = function()
  vim.cmd 'Telescope commands'
end

M.frecency = function()
  vim.cmd 'Telescope frecency'
end

M.buffers_cur = function()
  vim.cmd 'Telescope buffers cwd_only=true sort_mru=true ignore_current_buffer=true'
end

M.jumplist = function()
  vim.cmd 'Telescope jumplist show_line=false'
end

M.diagnostics = function()
  vim.cmd 'Telescope diagnostics'
end

M.filetypes = function()
  vim.cmd 'Telescope filetypes'
end

M.current_buffer_fuzzy_find = function()
  vim.cmd 'Telescope current_buffer_fuzzy_find'
end

M.quickfix = function()
  vim.cmd 'Telescope quickfix'
end

M.quickfixhistory = function()
  vim.cmd 'Telescope quickfixhistory'
end

M.builtin = function()
  vim.cmd 'Telescope builtin'
end

M.colorscheme = function()
  vim.cmd 'Telescope colorscheme'
end

M.git_branches = function()
  vim.cmd 'Telescope git_branches'
end

M.git_commits = function()
  vim.cmd 'Telescope git_commits'
end

M.git_bcommits = function()
  vim.cmd 'Telescope git_bcommits'
end

M.lsp_document_symbols = function()
  vim.cmd 'Telescope lsp_document_symbols'
end

M.lsp_references = function()
  vim.cmd 'Telescope lsp_references'
end

M.help_tags = function()
  vim.cmd 'Telescope help_tags'
end

M.vim_options = function()
  vim.cmd 'Telescope vim_options'
end

M.planets = function()
  vim.cmd 'Telescope planets'
end

M.grep_string = function()
  vim.cmd 'Telescope grep_string shorten_path=true word_match=-w only_sort_text=true search= grep_open_files=true'
end

M.keymaps = function()
  vim.cmd 'Telescope keymaps'
end

M.my_file_browser = function()
  vim.cmd 'Telescope my_file_browser'
end

M.git_status = function()
  vim.cmd 'Telescope git_status'
end

M.buffers = function()
  vim.cmd 'Telescope buffers'
end

--------------------
-- fzf
--------------------

pcall(telescope.load_extension, 'fzf')

--------------------
-- old files
--------------------

vim.g.sqlite_clib_path = require 'plenary.path':new(vim.g.pack_path):parent():parent():parent():parent():parent():joinpath('sqlite3', 'sqlite3.dll').filename

pcall(telescope.load_extension, 'frecency')

--------------------
-- file browser
--------------------

pcall(telescope.load_extension, 'my_file_browser')

M.file_browser_cur = function()
  vim.cmd(string.format('Telescope my_file_browser path=%s cwd_to_path=true files=true', vim.fn.expand '%:h'))
end

--------------------
-- open config
--------------------

M.nvim_config = require 'plenary.path':new(vim.g.pack_path):joinpath 'nvim_config'

M.open = function()
  vim.cmd('cd ' .. M.nvim_config.filename .. '|e ' .. 'start/lazy/lua/config/telescope.lua')
end

-- ui-select

require 'telescope'.load_extension 'ui-select'

--------------------
-- ui_all
--------------------

local descs = {}
local keys = {}
for i = 1, #TelescopeKeys do
  descs[#descs + 1] = TelescopeKeys[i]['desc']
  keys[#keys + 1] = vim.fn.substitute(TelescopeKeys[i][1], '<leader>', ' ', 'g')
end

M.ui_all = function()
  vim.ui.select(descs, { prompt = 'telescope all', }, function(choice, idx)
    if not choice then
      return
    end
    vim.cmd(string.format([[call feedkeys("%s")]], keys[idx]))
  end)
end

--------------------
-- project_nvim
--------------------

local patterns = {
  '.git',
}

require 'project_nvim'.setup {
  manual_mode = false,
  detection_methods = { 'pattern', 'lsp', },
  patterns = patterns,
}

vim.cmd 'autocmd BufRead * lua require("project_nvim.utils.history").write_projects_to_history()'

local historyfile = require 'plenary.path':new(require 'project_nvim.utils.path'.historyfile)

if not historyfile:exists() then
  historyfile:touch()
end

M.refreshhistory = function()
  local lines = historyfile:readlines()
  local newlines = {}
  for _, v in ipairs(lines) do
    local line = vim.fn.tolower(v)
    line = string.gsub(line, '\\', '/')
    if vim.tbl_contains(newlines, line) == false and require 'plenary.path':new(line):exists() then
      table.insert(newlines, line)
    end
  end
  table.sort(newlines)
  historyfile:write(table.concat(newlines, '\n'), 'w')
end

M.refreshhistory()

require 'telescope'.load_extension 'my_projects'

M.my_projects = function()
  vim.cmd 'Telescope my_projects'
  vim.cmd [[call feedkeys("\<esc>\<esc>")]]
  vim.keymap.set({ 'n', 'v', }, '<leader>sk', ':<c-u>Telescope my_projects<cr>',
    { silent = true, desc = 'Telescope my_projects', })
  vim.cmd [[call feedkeys(":Telescope my_projects\<cr>")]]
end

-- ====================
-- right click
-- ====================

M.menu_popup_way = 'nvim_open_win' -- nvim_open_win, ui_select

M.commands = {}

--------------------------
-- define menu popup way of nvim_open_win
--------------------------

M.winid = 0
M.bufnr = 0

M.buf_options = {
  filetype = 'menu',
  buftype = 'nofile',
  modifiable = false,
}

M.win_options = {
  signcolumn = 'no',
  number = true,
  -- winblend = 10,
}

M.win_open_opts = {
  relative = 'cursor',
  title = 'menu',
  border = 'rounded',
  row = 1,
  col = 0,
  style = 'minimal',
}

M.close = function()
  vim.api.nvim_win_close(M.winid, true)
end

M.run_at = function(index)
  local func = M.commands[index]
  if func then
    func()
  end
end

M.run_command = function()
  local line = vim.fn.line '.'
  M.close()
  M.run_at(line)
end

M.popup_menu = function(items)
  M.commands = {}
  M.bufnr = vim.api.nvim_create_buf(false, true)
  local cword = vim.fn.expand '<cword>'
  local win_width = vim.fn.strdisplaywidth(cword)
  local win_height = #vim.tbl_keys(items)
  local menus = {}
  for _, v in ipairs(items) do
    menus[#menus + 1] = v[1]
    M.commands[#M.commands + 1] = v[2]
    if vim.fn.strdisplaywidth(v[1]) > win_width then
      win_width = vim.fn.strdisplaywidth(v[1])
    end
  end
  win_width = win_width + 2 + vim.opt.numberwidth:get()
  vim.api.nvim_buf_set_lines(M.bufnr, 0, -1, true, menus)
  M.winid = vim.api.nvim_open_win(M.bufnr, true,
    vim.tbl_deep_extend('force', M.win_open_opts, {
      width = win_width,
      height = win_height,
      title = cword,
    }))
  for k, v in pairs(M.buf_options) do
    vim.api.nvim_buf_set_option(M.bufnr, k, v)
  end
  for k, v in pairs(M.win_options) do
    vim.api.nvim_win_set_option(M.winid, k, v)
  end
  local map_opt = function(desc)
    return { buffer = M.bufnr, desc = desc, }
  end
  vim.keymap.set({ 'n', 'v', }, '<2-LeftMouse>', M.run_command, map_opt 'run command')
  vim.keymap.set({ 'n', 'v', }, '<cr>', M.run_command, map_opt 'run command')
  vim.keymap.set({ 'n', 'v', }, '<esc>', M.close, map_opt 'esc')
  vim.api.nvim_create_autocmd({ 'BufLeave', }, {
    callback = M.close,
    once = true,
  })
end

M.ui_select_menu = function(items)
  local temp = {}
  for _, v in ipairs(items) do
    temp[#temp + 1] = v[1]
    M.commands[#M.commands + 1] = v[2]
  end
  vim.ui.select(temp, { prompt = 'menu ui_select', }, function(choice, idx)
    if not choice then
      return
    end
    M.run_at(idx)
  end)
end

--------------------------
-- define right click menu
--------------------------

M.toggle_menu_popup_way = function()
  if M.menu_popup_way == 'nvim_open_win' then
    M.menu_popup_way = 'ui_select'
  else
    M.menu_popup_way = 'nvim_open_win'
  end
end

M.copy_all_to_system_clipboard = function()
  local save_cursor = vim.fn.getpos '.'
  vim.cmd [[call feedkeys("ggVG\"+y")]]
  vim.fn.timer_start(10, function()
    pcall(vim.fn.setpos, '.', save_cursor)
    vim.cmd 'norm zz'
  end)
end

M.quit_all = function()
  vim.cmd 'qa!'
end

local items = {
  { 'toggle menu popup way',        M.toggle_menu_popup_way, },
  { 'copy all to system clipboard', M.copy_all_to_system_clipboard, },
  { 'quit all',                     M.quit_all, },
}

M.right_click = function()
  if M.menu_popup_way == 'nvim_open_win' then
    vim.cmd [[call feedkeys("\<LeftMouse>")]]
    vim.fn.timer_start(10, function()
      M.popup_menu(items)
    end)
  elseif M.menu_popup_way == 'ui_select' then
    M.ui_select_menu(items)
  end
end

return M
