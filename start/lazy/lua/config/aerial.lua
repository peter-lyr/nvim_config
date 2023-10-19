local M = {}

package.loaded['config.aerial'] = nil

local width = 27

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

M.opened = nil

M.open = function()
  M.opened = 1
  vim.cmd 'AerialOpen right'
end

M.close = function()
  M.opened = 1
  vim.cmd 'AerialCloseAll'
end

pcall(vim.api.nvim_del_autocmd, vim.g.aerial_au_bufleave)

vim.g.aerial_au_bufleave = vim.api.nvim_create_autocmd({ 'BufLeave', }, {
  callback = function(ev)
    if vim.api.nvim_buf_get_option(ev.buf, 'filetype') == 'aerial' then
      vim.api.nvim_win_set_width(0, width)
    end
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.aerial_au_bufenter)

vim.g.aerial_au_bufenter = vim.api.nvim_create_autocmd('BufEnter', {
  callback = function(ev)
    if vim.api.nvim_buf_get_option(ev.buf, 'filetype') == 'aerial' then
      vim.fn.timer_start(20, function()
        if require 'config.minimap'.opened then
          require 'config.minimap'.close()
          vim.api.nvim_create_autocmd({ 'BufLeave', }, {
            callback = function()
              require 'config.minimap'.open()
            end,
            once = true,
          })
        end
      end)
    end
  end,
})

return M
