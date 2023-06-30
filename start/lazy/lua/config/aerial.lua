require('aerial').setup({
  layout = {
    min_width = 28,
  },
  keymaps = {
    ['?'] = 'actions.show_help',
    ['o'] = 'actions.jump',
    ['a'] = 'actions.jump',
    ['<2-LeftMouse>'] = 'actions.jump',
    ['<C-v>'] = 'actions.jump_vsplit',
    ['<C-s>'] = 'actions.jump_split',
    ['<tab>'] = 'actions.scroll',
    ['<C-j>'] = 'actions.down_and_scroll',
    ['<C-k>'] = 'actions.up_and_scroll',
    ['{'] = 'actions.prev',
    ['}'] = 'actions.next',
    ['[['] = 'actions.prev_up',
    [']]'] = 'actions.next_up',
    -- ['q'] = 'actions.close',
    ['q'] = function()
      vim.api.nvim_win_set_width(0, 0)
      vim.cmd('wincmd p')
    end,
    -- ['a'] = 'actions.tree_toggle',
    ['O'] = 'actions.tree_toggle_recursive',
    ['zA'] = 'actions.tree_toggle_recursive',
    ['l'] = 'actions.tree_open',
    ['zo'] = 'actions.tree_open',
    ['L'] = 'actions.tree_open_recursive',
    ['zO'] = 'actions.tree_open_recursive',
    ['h'] = 'actions.tree_close',
    ['zc'] = 'actions.tree_close',
    ['H'] = 'actions.tree_close_recursive',
    ['zC'] = 'actions.tree_close_recursive',
    ['zr'] = 'actions.tree_increase_fold_level',
    ['zR'] = 'actions.tree_open_all',
    ['zm'] = 'actions.tree_decrease_fold_level',
    ['zM'] = 'actions.tree_close_all',
    ['zx'] = 'actions.tree_sync_folds',
    ['zX'] = 'actions.tree_sync_folds',
  },
  -- backends = { "lsp", "treesitter", "markdown", "man" },
  backends = { "lsp", },
  post_jump_cmd = [[norm zt]],
  close_automatic_events = {},
  close_on_select = false,
  float = {
    relative = 'editor',
  },
})

local M = {}

M.open = function()
  vim.cmd('AerialOpen right')
  pcall(vim.api.nvim_win_set_width, 0, vim.b[vim.fn.bufnr()].aerial_width)
end

return M
