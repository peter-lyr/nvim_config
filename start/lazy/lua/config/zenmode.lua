local M = {}

local get_highlight_value = function(dim_elements, hlgroup)
  return table.concat(dim_elements, ":" .. hlgroup .. ",") .. ":" .. hlgroup
end

M.config = {
  bgcolor = "#303030",
  highlight_group = "Dimit",
  dim_elements = {
    "ColorColumn",
    "CursorColumn",
    "CursorLine",
    "CursorLineFold",
    "CursorLineNr",
    "CursorLineSign",
    "EndOfBuffer",
    "FoldColumn",
    "LineNr",
    "NonText",
    "Normal",
    "SignColumn",
    "VertSplit",
    "Whitespace",
    "WinBarNC",
    "WinSeparator",
  },
}

M.blink_curwin = function()
  vim.api.nvim_set_hl(0, M.config.highlight_group, { bg = M.config.bgcolor })
  local current = vim.api.nvim_get_current_win()
  local dim_value = get_highlight_value(M.config.dim_elements, M.config.highlight_group)
  for _, w in pairs(vim.api.nvim_list_wins()) do
    local winhighlights = current == w and dim_value or ""
    vim.api.nvim_win_set_option(w, "winhighlight", winhighlights)
  end
  vim.fn.timer_start(200, function()
    for _, w in pairs(vim.api.nvim_list_wins()) do
      vim.api.nvim_win_set_option(w, "winhighlight", "")
    end
  end)
end

M.toggle = function()
  if vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) == 1 then
    require("zen-mode").toggle({ window = { width = 1 } })
  else
    M.blink_curwin()
  end
end

return M
