local symbolsoutline = require('symbols-outline')

symbolsoutline.setup({
  keymaps = {
    close = { '<Esc>', 'q' },
    goto_location = { 'o', 'a' },
    focus_location = '<tab>',
    hover_symbol = 'J',
    toggle_preview = 'K',
    rename_symbol = 'r',
    code_actions = 'c',
    fold = 'h',
    unfold = 'l',
    fold_all = 'W',
    unfold_all = 'E',
    fold_reset = 'R',
  },
})

local M = {}

M.toggle = function()
  local symbolsoutline_opened = symbolsoutline.view:is_open()
  if symbolsoutline_opened then
    symbolsoutline_opened = nil
    for i = 1, vim.fn.winnr('$') do
      if vim.fn.getbufvar(vim.fn.winbufnr(i), '&ft') == 'Outline' then
        symbolsoutline_opened = true
        break
      end
    end
    if not symbolsoutline_opened then
      symbolsoutline.close_outline()
    end
  end
  symbolsoutline.toggle_outline()
end

return M
