local M = {}

local function getfontnamesize()
  local fontname
  local fontsize
  for k, v in string.gmatch(vim.g.GuiFont, '(.*:h)(%d+)') do
    fontname, fontsize = k, v
  end
  return fontname, fontsize
end

local _, temp = getfontnamesize()
M.lastfontsize = temp
M.fontsizenormal = 9

M.up = function()
  local fontname, fontsize = getfontnamesize()
  fontsize = fontsize + 1
  M.lastfontsize = fontsize
  if fontsize <= 72 then
    vim.cmd('GuiFont! ' .. fontname .. fontsize)
    print('GuiFont! ' .. fontname .. fontsize)
  end
end

M.down = function()
  local fontname, fontsize = getfontnamesize()
  fontsize = fontsize - 1
  M.lastfontsize = fontsize
  if fontsize >= 1 then
    vim.cmd('GuiFont! ' .. fontname .. fontsize)
    print('GuiFont! ' .. fontname .. fontsize)
  end
end

M.normal = function()
  local fontname, fontsize = getfontnamesize()
  if (tonumber(fontsize) == M.fontsizenormal) == true then
    vim.cmd('GuiFont! ' .. fontname .. M.lastfontsize)
    print('GuiFont! ' .. fontname .. M.lastfontsize)
  else
    vim.cmd('GuiFont! ' .. fontname .. M.fontsizenormal)
    print('GuiFont! ' .. fontname .. M.fontsizenormal)
  end
end

M.min = function()
  local fontname, _ = getfontnamesize()
  M.lastfontsize = 1
  vim.cmd('GuiFont! ' .. fontname .. 1)
  print('GuiFont! ' .. fontname .. 1)
end

M.frameless = function()
  if vim.g.GuiWindowFrameless == 0 then
    vim.fn['GuiWindowFrameless'](1)
  else
    vim.fn['GuiWindowFrameless'](0)
  end
end

M.fullscreen = function()
  if vim.g.GuiWindowFullScreen == 0 then
    vim.fn['GuiWindowFullScreen'](1)
  else
    vim.fn['GuiWindowFullScreen'](0)
  end
end

return M
