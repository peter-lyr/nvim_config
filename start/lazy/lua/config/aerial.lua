local M = {}

package.loaded['config.aerial'] = nil

local width = 24

require 'aerial'.setup {
  layout = {
    max_width = width,
    min_width = width,
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

M.open = function()
  vim.cmd 'AerialOpen right'
end

return M
