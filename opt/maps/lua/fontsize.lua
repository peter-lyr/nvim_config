local M = {}

M.fontsizenormal = 9

local function getfontnamesize()
  local fontname
  local fontsize
  for k, v in string.gmatch(vim.g.GuiFont, "(.*:h)(%d+)") do
    fontname, fontsize = k, v
  end
  return fontname, fontsize
end

M.sizeup = function()
  local fontname, fontsize = getfontnamesize()
  fontsize = fontsize + 1
  if fontsize <= 72 then
    vim.cmd('GuiFont! ' .. fontname .. fontsize)
    print('GuiFont! ' .. fontname .. fontsize)
  end
end

M.sizedown = function()
  local fontname, fontsize = getfontnamesize()
  fontsize = fontsize - 1
  if fontsize >= 1 then
    vim.cmd('GuiFont! ' .. fontname .. fontsize)
    print('GuiFont! ' .. fontname .. fontsize)
  end
end

M.sizenormal = function()
  local fontname, _ = getfontnamesize()
  vim.cmd('GuiFont! ' .. fontname .. M.fontsizenormal)
  print('GuiFont! ' .. fontname .. M.fontsizenormal)
end

M.sizemin = function()
  local fontname, _ = getfontnamesize()
  vim.cmd('GuiFont! ' .. fontname .. 1)
  print('GuiFont! ' .. fontname .. 1)
end

return M
