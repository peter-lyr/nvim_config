local M = {}

local S = require 'my_simple'

M.gui_window_frameless_txt = S.get_create_file(S.get_create_std_data_dir 'gui-window-frameless', 'gui-window-frameless.txt')

if #vim.fn.trim(vim.fn.join(vim.fn.readfile(M.gui_window_frameless_txt), '')) == 0 then
  if vim.fn.exists 'g:GuiLoaded' and vim.g.GuiLoaded == 1 then
    S.set_timeout(10, function()
      vim.fn['GuiWindowFrameless'](1)
    end)
  end
end

return M
