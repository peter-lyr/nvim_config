local M = {}

M.flag = ''

M.readpre_ev = {}
M.last_ev = {}

M.is_saved_images = function(ev, last_ev)
  -- drag an image file to md buffer.
  if not last_ev then
    return false
  end
  local curext = string.match(ev.file, '.+%.(%w+)$')
  local lastext = string.match(last_ev.file, '.+%.(%w+)$')
  if curext and #curext ~= 0 and vim.tbl_contains({ 'jpg', 'png', }, curext) == true then
    if lastext and #lastext ~= 0 and vim.tbl_contains({ 'md', }, lastext) == true then
      return true
    end
  end
  return false
end

M.readpre = function(ev, last_ev)
  M.readpre_ev = ev
  M.last_ev = last_ev
  if M.is_saved_images(ev, last_ev) == true then
    M.flag = 'saved_images'
    return 1
  else
    M.flag = ''
  end
  return nil
end

M.bufenter = function(ev)
  if M.flag == 'saved_images' then
    vim.cmd('b' .. M.last_ev.buf)
    vim.loop.new_timer():start(1000, 0, function()
      vim.schedule(function()
        vim.cmd('bw! ' .. M.readpre_ev.buf)
      end)
    end)
    require 'mkdimage'.dragimage('sel_png', M.readpre_ev.file)
    vim.cmd 'w!'
  end
end

return M
