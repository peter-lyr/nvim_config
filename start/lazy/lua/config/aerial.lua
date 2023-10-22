local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
package.loaded[B.get_loaded(M.source)] = nil
--------------------------------------------

M.width = require 'config.minimap'.width

local default_opts = {
  layout = {
    max_width = M.width * 2,
    min_width = M.width * 2,
    preserve_equality = nil,
  },
  keymaps = {
    ['<C-s>'] = false,
    ['<C-j>'] = false,
    ['<C-k>'] = false,
    ['?'] = 'actions.show_help',
    ['a'] = 'actions.jump',
    ['<2-LeftMouse>'] = 'actions.jump',
    ['<MiddleMouse>'] = 'actions.close',
    ['<C-x>'] = 'actions.jump_split',
    ['<tab>'] = 'actions.scroll',
    ['o'] = 'actions.tree_toggle',
    ['O'] = 'actions.tree_toggle_recursive',
    ['l'] = 'actions.tree_open',
    ['L'] = 'actions.tree_open_recursive',
    ['h'] = 'actions.tree_close',
    ['H'] = 'actions.tree_close_recursive',
    ['r'] = 'actions.tree_increase_fold_level',
    ['R'] = 'actions.tree_open_all',
    ['p'] = 'actions.tree_decrease_fold_level',
    ['P'] = 'actions.tree_close_all',
  },
  filter_kind = false,
  backends = { 'markdown', 'lsp', 'treesitter', 'man', },
  -- backends = { "lsp", },
  post_jump_cmd = [[norm zz]],
  close_automatic_events = {},
  close_on_select = false,
  float = {
    relative = 'editor',
  },
}

require 'aerial'.setup(default_opts)

function M.setup(opts)
  opts = vim.tbl_deep_extend('force', default_opts, opts)
  require 'aerial'.setup(opts)
end

M.opened = nil

M.open = function()
  M.opened = 1
  vim.cmd 'AerialOpen right'
end

M.close = function()
  M.opened = 1
  vim.cmd 'AerialCloseAll'
end

function M.size_leave(ev)
  if vim.api.nvim_buf_get_option(ev.buf, 'filetype') == 'aerial' then
    M.setup {
      layout = {
        max_width = M.width + 2,
        min_width = M.width + 2,
      },
    }
    vim.api.nvim_win_set_width(0, M.width + 2)
  end
end

function M.size_enter(ev)
  if vim.api.nvim_buf_get_option(ev.buf, 'filetype') == 'aerial' then
    local width = M.width + 2
    if require 'config.minimap'.opened then
      width = M.width * 2 + 2
    end
    M.setup {
      layout = {
        max_width = width,
        min_width = width,
      },
    }
    vim.api.nvim_win_set_width(0, width)
  end
end

B.aucmd(M.source, 'BufLeave', { 'BufLeave', }, {
  callback = function(ev)
    M.size_leave(ev)
  end,
})

B.aucmd(M.source, 'BufEnter', { 'BufEnter', }, {
  callback = function(ev)
    M.size_enter(ev)
  end,
})

return M
