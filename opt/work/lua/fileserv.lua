local M = {}

M.upclip = function()
  if vim.g.GuiWindowFullScreen == 1 then
    vim.fn['GuiWindowFullScreen'](0)
    vim.fn.system([[start /min cmd /c "upclip.bat && exit"]])
    vim.fn['GuiWindowFullScreen'](1)
  else
    vim.fn.system([[start /min cmd /c "upclip.bat && exit"]])
  end
end

M.downclip = function()
  if vim.g.GuiWindowFullScreen == 1 then
    vim.fn['GuiWindowFullScreen'](0)
    vim.fn.system([[start /min cmd /c "downclip.bat && exit"]])
    vim.fn['GuiWindowFullScreen'](1)
  else
    vim.fn.system([[start /min cmd /c "downclip.bat && exit"]])
  end
end

return M
