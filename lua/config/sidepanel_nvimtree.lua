local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

vim.cmd [[
  hi NvimTreeOpenedFile guibg=#238789
  hi NvimTreeModifiedFile guibg=#87237f
  hi NvimTreeSpecialFile guifg=brown gui=bold,underline
]]

function M.on_attach(bufnr)
  B.call_sub(M.loaded, 'map', 'basic_map', bufnr)
  B.call_sub(M.loaded, 'map', 'sel_map', bufnr)
end

M.default_opts = {
  on_attach = M.on_attach,
  update_focused_file = {
    -- enable = true,
    update_root = true,
  },
  git = {
    enable = true,
  },
  view = {
    width = 30,
    number = true,
    relativenumber = true,
  },
  sync_root_with_cwd = true,
  reload_on_bufenter = true,
  respect_buf_cwd = true,
  filesystem_watchers = {
    enable = true,
    debounce_delay = 50,
    ignore_dirs = { '*.git*', },
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

function M.setup(conf)
  require 'nvim-tree'.setup(vim.tbl_deep_extend('force', M.default_opts, conf or {}))
end

M.setup()

-----------------------

M.nvimtree_opened = nil

function M.findfile()
  M.nvimtree_opened = 1
  vim.cmd 'NvimTreeFindFile'
end

function M.open()
  M.nvimtree_opened = 1
  vim.cmd 'NvimTreeOpen'
end

function M.close()
  M.nvimtree_opened = nil
  vim.cmd 'NvimTreeClose'
end

function M.restart()
  B.source_lua(M.source)
  M.open()
end

return M
