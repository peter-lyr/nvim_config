local M = {}

package.loaded['config.nvimtree-func'] = nil

local api = require 'nvim-tree.api'

M.nvimtree_opened = nil
M.focuslost_timer = 0
M.show_cwd_root = 1

local wrap_node = function(fn)
  return function(node, ...)
    node = node or require 'nvim-tree.lib'.get_node_at_cursor()
    fn(node, ...)
  end
end

local function root_folder_label(root_cwd)
  if M.show_cwd_root then
    return root_cwd
  end
  return vim.fn.fnamemodify(root_cwd, ':t')
end

local function show_cwd_root_toggle()
  if M.show_cwd_root then
    M.show_cwd_root = nil
  else
    M.show_cwd_root = 1
  end
  vim.cmd 'wincmd p'
  vim.cmd 'wincmd p'
end

local function plugins_map()
  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true, }
  end
  vim.keymap.set('n', '<c-bs>', wrap_node(show_cwd_root_toggle), opts 'Show cwd root or not')
end

local function close()
  api.tree.close()
  M.nvimtree_opened = nil
end

local function tab()
  api.node.open.preview()
  vim.cmd 'norm j'
end

local function c_tab()
  api.node.open.preview()
  vim.cmd 'norm k'
end

local function basic_map(bufnr)
  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true, }
  end
  vim.keymap.set('n', '<c-f>', api.node.show_info_popup, opts 'Info')
  vim.keymap.set('n', 'dk', api.node.open.tab, opts 'Open: New Tab')
  vim.keymap.set('n', 'dl', api.node.open.vertical, opts 'Open: Vertical Split')
  vim.keymap.set('n', 'dj', api.node.open.horizontal, opts 'Open: Horizontal Split')
  vim.keymap.set('n', 'a', api.node.open.edit, opts 'Open')

  vim.keymap.set('n', '<Tab>', tab, opts 'Open Preview')
  vim.keymap.set('n', '<C-Tab>', c_tab, opts 'Open Preview')

  vim.keymap.set('n', '<2-LeftMouse>', api.node.open.no_window_picker, opts 'Open')
  vim.keymap.set('n', '<CR>', api.node.open.no_window_picker, opts 'Open: No Window Picker')
  vim.keymap.set('n', 'o', api.node.open.no_window_picker, opts 'Open: No Window Picker')
  vim.keymap.set('n', 'do', api.node.open.no_window_picker, opts 'Open: No Window Picker')

  vim.keymap.set('n', 'c', api.fs.create, opts 'Create')
  vim.keymap.set('n', 'D', api.fs.remove, opts 'Delete')
  vim.keymap.set('n', 'C', api.fs.copy.node, opts 'Copy')
  vim.keymap.set('n', 'X', api.fs.cut, opts 'Cut')
  vim.keymap.set('n', 'p', api.fs.paste, opts 'Paste')

  vim.keymap.set('n', 'gr', api.fs.rename_sub, opts 'Rename: Omit Filename')
  vim.keymap.set('n', 'R', api.fs.rename, opts 'Rename')
  vim.keymap.set('n', 'r', api.fs.rename_basename, opts 'Rename: Basename')

  vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts 'Copy Absolute Path')
  vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts 'Copy Relative Path')
  vim.keymap.set('n', 'y', api.fs.copy.filename, opts 'Copy Name')

  vim.keymap.set('n', 'vo', api.tree.change_root_to_node, opts 'CD')
  vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts 'Up')

  vim.keymap.set('n', 'gb', api.tree.toggle_no_buffer_filter, opts 'Toggle No Buffer')
  vim.keymap.set('n', 'g.', api.tree.toggle_git_clean_filter, opts 'Toggle Git Clean')
  vim.keymap.set('n', '?', api.tree.toggle_help, opts 'Help')
  vim.keymap.set('n', '.', api.tree.toggle_hidden_filter, opts 'Toggle Dotfiles')
  vim.keymap.set('n', 'i', api.tree.toggle_gitignore_filter, opts 'Toggle Git Ignore')

  vim.keymap.set('n', '<c-r>', api.tree.reload, opts 'Refresh')
  vim.keymap.set('n', 'E', api.tree.expand_all, opts 'Expand All')
  vim.keymap.set('n', 'W', api.tree.collapse_all, opts 'Collapse')
  vim.keymap.set('n', 'q', wrap_node(close), opts 'Close')
  vim.keymap.set('n', '<esc>', wrap_node(close), opts 'Close')

  vim.keymap.set('n', '<leader>k', api.node.navigate.git.prev, opts 'Prev Git')
  vim.keymap.set('n', '<leader>j', api.node.navigate.git.next, opts 'Next Git')
  vim.keymap.set('n', '<leader>m', api.node.navigate.diagnostics.next, opts 'Next Diagnostic')
  vim.keymap.set('n', '<leader>n', api.node.navigate.diagnostics.prev, opts 'Prev Diagnostic')
  vim.keymap.set('n', '<c-i>', api.node.navigate.opened.prev, opts 'Prev Opened')
  vim.keymap.set('n', '<c-o>', api.node.navigate.opened.next, opts 'Next Opened')

  vim.keymap.set('n', '<a-m>', api.node.navigate.sibling.next, opts 'Next Sibling')
  vim.keymap.set('n', '<a-n>', api.node.navigate.sibling.prev, opts 'Previous Sibling')
  vim.keymap.set('n', '<c-m>', api.node.navigate.sibling.last, opts 'Last Sibling')
  vim.keymap.set('n', '<c-n>', api.node.navigate.sibling.first, opts 'First Sibling')

  vim.keymap.set('n', '<c-h>', api.node.navigate.parent, opts 'Parent Directory')
  vim.keymap.set('n', '<c-u>', api.node.navigate.parent_close, opts 'Close Directory')

  vim.keymap.set('n', 'x', api.node.run.system, opts 'Run System')
  vim.keymap.set('n', '<MiddleMouse>', api.node.run.system, opts 'Run System')
  vim.keymap.set('n', 'gx', api.node.run.cmd, opts 'Run Command')

  vim.keymap.set('n', 'f', api.live_filter.start, opts 'Filter')
  vim.keymap.set('n', 'gf', api.live_filter.clear, opts 'Clean Filter')
end

local on_attach = function(bufnr)
  basic_map(bufnr)
  plugins_map(bufnr)
end

vim.cmd [[
hi NvimTreeOpenedFile guibg=#238789
hi NvimTreeModifiedFile guibg=#87237f
hi NvimTreeSpecialFile guifg=brown gui=bold,underline
]]

local cfg_tbl = {
  on_attach = on_attach,
  update_focused_file = {
    -- enable = true,
    update_root = true,
  },
  sync_root_with_cwd = true,
  reload_on_bufenter = true,
  respect_buf_cwd = true,
  filesystem_watchers = {
    enable = false,
    debounce_delay = 50,
    ignore_dirs = { '*.git', },
  },
  filters = {
    dotfiles = true,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },
  modified = {
    enable = true,
    show_on_dirs = false,
    show_on_open_dirs = false,
  },
  renderer = {
    root_folder_label = root_folder_label,
    highlight_git = true,
    highlight_opened_files = 'name',
    highlight_modified = 'name',
    special_files = { 'README.md', 'readme.md', },
    indent_markers = {
      enable = true,
    },
  },
  actions = {
    open_file = {
      window_picker = {
        chars = 'ASDFQWERJKLHNMYUIOPZXCVGTB1234789056',
        exclude = {
          filetype = { 'notify', 'packer', 'qf', 'diff', 'fugitive', 'fugitiveblame', 'minimap', 'aerial', },
          buftype = { 'nofile', 'terminal', 'help', },
        },
      },
    },
  },
}

M.setup = function(conf)
  require 'nvim-tree'.setup(vim.tbl_deep_extend('force', cfg_tbl, conf or {}))
end

M.setup()

M.findfile = function()
  M.nvimtree_opened = 1
  vim.cmd 'NvimTreeFindFile'
end

M.open = function()
  M.nvimtree_opened = 1
  vim.cmd 'NvimTreeOpen'
end

M.close = function()
  M.nvimtree_opened = nil
  vim.cmd 'NvimTreeClose'
end

pcall(vim.api.nvim_del_autocmd, vim.g.nvimtree_au_focusgained)

vim.g.nvimtree_au_focusgained = vim.api.nvim_create_autocmd({ 'FocusGained', }, {
  callback = function()
    if M.focuslost_timer ~= 0 then
      M.focuslost_timer:stop()
    end
    M.focuslost_timer = 0
    if M.nvimtree_opened == 1 then
      local winid = vim.fn.win_getid()
      vim.cmd 'NvimTreeOpen'
      vim.fn.win_gotoid(winid)
    end
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.nvimtree_au_focuslost)

vim.g.nvimtree_au_focuslost = vim.api.nvim_create_autocmd({ 'FocusLost', }, {
  callback = function()
    if M.focuslost_timer ~= 0 then
      M.focuslost_timer:stop()
    end
    M.focuslost_timer = vim.loop.new_timer()
    M.focuslost_timer:start(1000 * 20, 0, function()
      vim.schedule(function()
        vim.cmd 'NvimTreeClose'
        M.focuslost_timer = 0
      end)
    end)
  end,
})

return M
