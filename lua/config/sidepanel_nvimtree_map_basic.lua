local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.tab()
  local api = require 'nvim-tree.api'
  api.node.open.preview()
  vim.cmd 'norm j'
end

function M.c_tab()
  local api = require 'nvim-tree.api'
  api.node.open.preview()
  vim.cmd 'norm k'
end

function M.close()
  require 'config.sidepanel_nvimtree'.close()
end

function M.system_run_and_close()
  require 'nvim-tree.api'.node.run.system()
  require 'config.sidepanel_nvimtree'.close()
end

function M.delete(node)
  B.cmd('Bdelete %s', node.absolute_path)
  require 'config.my_tabline'.update_bufs_and_refresh_tabline()
  vim.cmd 'norm j'
end

M.ausize_en = 1

function M.ausize_toggle()
  if M.ausize_en then
    M.ausize_en = nil
  else
    M.ausize_en = 1
  end
  print('ausize_en:', M.ausize_en)
end

function M.ausize(ev)
  if vim.bo.ft == 'NvimTree' and M.ausize_en then
    local winid = vim.fn.win_getid(vim.fn.bufwinnr(ev.buf))
    vim.fn.timer_start(10, function()
      if B.is_buf_ft('NvimTree', ev.buf) then
        local max = 0
        local min_nr = vim.fn.line 'w0'
        if min_nr == 1 then
          min_nr = 2
        end
        local max_nr = vim.fn.line 'w$'
        for line = min_nr, max_nr do
          local cnt = vim.fn.strdisplaywidth(vim.fn.getline(line))
          if max < cnt then
            max = cnt
          end
        end
        if max + 1 + 1 + #tostring(vim.fn.line 'w$') + 1 + 2 > require 'nvim-tree.view'.View.width then
          vim.api.nvim_win_set_width(winid, max + 5 + #tostring(vim.fn.line '$'))
        end
      end
    end)
  end
end

function M.wrap_node(fn)
  return function(node, ...)
    node = node or require 'nvim-tree.lib'.get_node_at_cursor()
    fn(node, ...)
  end
end

function M.basic_map(bufnr)
  local api = require 'nvim-tree.api'
  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true, }
  end

  vim.keymap.set('n', 'gd', M.wrap_node(M.delete), opts 'delete buf')

  ---

  vim.keymap.set('n', "<leader>'a", M.wrap_node(M.ausize_toggle), opts 'ausize_toggle')

  ---

  vim.keymap.set('n', '<c-f>', api.node.show_info_popup, opts 'Info')
  vim.keymap.set('n', 'dk', api.node.open.tab, opts 'Open: New Tab')
  vim.keymap.set('n', 'dl', api.node.open.vertical, opts 'Open: Vertical Split')
  vim.keymap.set('n', 'dj', api.node.open.horizontal, opts 'Open: Horizontal Split')
  vim.keymap.set('n', 'a', api.node.open.edit, opts 'Open')

  vim.keymap.set('n', '<Tab>', M.tab, opts 'Open Preview')
  vim.keymap.set('n', '<C-Tab>', M.c_tab, opts 'Open Preview')

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
  vim.keymap.set('n', 'q', M.close, opts 'Close')
  vim.keymap.set('n', '<c-q>', M.close, opts 'Close')

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
  vim.keymap.set('n', '<c-x>', M.system_run_and_close, opts 'Run System')
  vim.keymap.set('n', '<MiddleMouse>', api.node.run.system, opts 'Run System')
  vim.keymap.set('n', 'gx', api.node.run.cmd, opts 'Run Command')

  vim.keymap.set('n', 'f', api.live_filter.start, opts 'Filter')
  vim.keymap.set('n', 'gf', api.live_filter.clear, opts 'Clean Filter')
end

return M
