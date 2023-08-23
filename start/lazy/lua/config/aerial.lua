require 'aerial'.setup {
  layout = {
    min_width = 28,
  },
  keymaps = {
    ['<C-s>'] = false,
    ['<C-j>'] = false,
    ['<C-k>'] = false,
    ['?'] = 'actions.show_help',
    ['a'] = 'actions.jump',
    ['<2-LeftMouse>'] = 'actions.jump',
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
  backends = { "markdown", "lsp", "treesitter", "man", },
  -- backends = { "lsp", },
  post_jump_cmd = [[norm zz]],
  close_automatic_events = {},
  close_on_select = false,
  float = {
    relative = 'editor',
  },
}

local M = {}

M.open = function()
  if vim.fn.buflisted(vim.fn.bufnr()) == 0 then
    if vim.g.lastbufwinid ~= -1 then
      vim.fn.win_gotoid(vim.g.lastbufwinid)
    else
      return
    end
  end
  vim.cmd 'AerialOpen right'
end

local scrolloff = vim.opt.scrolloff

vim.api.nvim_create_autocmd({ "BufEnter", }, {
  callback = function()
    if vim.bo.ft == 'aerial' then
      vim.opt.scrolloff = 99
    else
      vim.opt.scrolloff = scrolloff
    end
  end,
})

return M
