local M = {}

local dimit = require 'dimit'

dimit.setup {
  bgcolor = '#000000',
  dim_elements = {
    'ColorColumn',
    'CursorColumn',
    'CursorLine',
    'CursorLineFold',
    'CursorLineNr',
    'CursorLineSign',
    'EndOfBuffer',
    'FoldColumn',
    'LineNr',
    'NonText',
    'Normal',
    'SignColumn',
    'VertSplit',
    'Whitespace',
    'WinBarNC',
    -- "WinSeparator",
  },
}

if dimit.autocmd ~= nil then
  vim.api.nvim_del_autocmd(dimit.autocmd)
end

local get_highlight_value = function(dim_elements, hlgroup)
  return table.concat(dim_elements, ':' .. hlgroup .. ',') .. ':' .. hlgroup
end

dimit.dim_inactive = function()
  local config = dimit.config
  vim.api.nvim_set_hl(0, config.highlight_group, { bg = config.bgcolor, })
  local current = vim.api.nvim_get_current_win()
  local minimap = 0
  local bufnr = vim.fn.bufnr()
  if vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) == 0 and vim.fn.bufnr '-MINIMAP-' == bufnr then
    minimap = 1
  end
  local dim_value = get_highlight_value(config.dim_elements, config.highlight_group)
  for _, w in pairs(vim.api.nvim_list_wins()) do
    -- local alt = vim.fn.bufnr '#'
    -- local cur = vim.fn.winbufnr(w)
    -- if vim.api.nvim_buf_is_valid(alt) == true and
    --     vim.api.nvim_buf_get_option(alt, 'modifiable') == true and
    --     vim.fn.filereadable(vim.api.nvim_buf_get_name(alt)) == 1 and
    --     alt == cur then
    --   dim_value = get_highlight_value(config.dim_elements, "DimitAlt")
    -- end
    local winhighlights = current == w and '' or dim_value
    if minimap == 1 then
      if vim.tbl_contains(require 'bufferjump'.last_readable_winids, w) == true then
        winhighlights = ''
      end
    end
    vim.api.nvim_win_set_option(w, 'winhighlight', winhighlights)
  end
end

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter', 'WinClosed', }, {
  callback = function()
    vim.schedule(function()
      if not string.match(vim.bo.ft, 'aerial') then
        dimit.dim_inactive()
      end
    end)
  end,
})

return M
