local M = {}

local function getfontnamesize()
  local fontname
  local fontsize
  for k, v in string.gmatch(vim.g.GuiFont, '(.*:h)(%d+)') do
    fontname, fontsize = k, v
  end
  return fontname, fontsize
end

M.notify = function(info)
  vim.notify(info, 'info', {
    animate = false,
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
      vim.api.nvim_win_set_option(win, 'concealcursor', 'nvic')
    end,
    timeout = 1000 * 8,
  })
end

M.last_font_size_dir_p = require 'plenary.path':new(vim.fn.stdpath 'data'):joinpath 'last-font-size'
M.last_font_size_txt_p = M.last_font_size_dir_p:joinpath 'last-font-size.txt'

if not M.last_font_size_dir_p:exists() then
  vim.fn.mkdir(M.last_font_size_dir_p.filename)
end

if not M.last_font_size_txt_p:exists() then
  M.last_font_size_txt_p:write('9', 'w')
end

M.fontsizenormal = 9
local _, temp = getfontnamesize()
M.lastfontsize = temp
if (tonumber(temp) == M.fontsizenormal) == true then
  M.lastfontsize = M.last_font_size_txt_p:read()
end

vim.api.nvim_create_autocmd({ 'VimLeavePre', }, {
  callback = function()
    if M.lastfontsize ~= M.fontsizenormal then
      M.last_font_size_txt_p:write(M.lastfontsize, 'w')
    end
  end,
})

M.up = function()
  local fontname, fontsize = getfontnamesize()
  fontsize = fontsize + 1
  M.lastfontsize = fontsize
  if fontsize <= 72 then
    local cmd = 'GuiFont! ' .. fontname .. fontsize
    vim.cmd(cmd)
    M.notify(cmd)
  end
end

M.down = function()
  local fontname, fontsize = getfontnamesize()
  fontsize = fontsize - 1
  M.lastfontsize = fontsize
  if fontsize >= 1 then
    local cmd = 'GuiFont! ' .. fontname .. fontsize
    vim.cmd(cmd)
    M.notify(cmd)
  end
end

M.normal = function()
  local fontname, fontsize = getfontnamesize()
  if (tonumber(fontsize) == M.fontsizenormal) == true then
    local cmd = 'GuiFont! ' .. fontname .. M.lastfontsize
    vim.cmd(cmd)
    M.notify(cmd)
  else
    local cmd = 'GuiFont! ' .. fontname .. M.fontsizenormal
    vim.cmd(cmd)
    M.notify(cmd)
  end
end

M.min = function()
  local fontname, _ = getfontnamesize()
  M.lastfontsize = 1
  local cmd = 'GuiFont! ' .. fontname .. 1
  vim.cmd(cmd)
  M.notify(cmd)
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
