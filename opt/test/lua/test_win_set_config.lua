local test_win_opt = function()
  local has_tabline = vim.o.showtabline == 2 or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
  local has_statusline = vim.o.laststatus > 0
  return {
    relative = 'editor',
    anchor = 'NE',
    row = has_tabline and 1 or 0,
    col = vim.o.columns,
    width = 100,
    height = vim.o.lines - vim.o.cmdheight - (has_tabline and 1 or 0) - (has_statusline and 1 or 0),
    focusable = true,
    style = 'minimal',
    zindex = 9,
  }
end

local win_opt = {
  winblend = 20,
}

local winid = vim.fn.win_getid()

vim.api.nvim_win_set_config(winid, test_win_opt())
for k, v in pairs(win_opt) do
  vim.api.nvim_win_set_option(winid, k, v)
end
