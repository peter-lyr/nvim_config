local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

function M.update(cur)
  require('config.my_drag_images').update(cur)
end

function M.paste(png, no_input_image_name)
  require('config.my_drag_images').paste(png, no_input_image_name)
end

function M.copy_text()
  require('config.my_drag_images').copy_text()
end

function M.copy_file()
  require('config.my_drag_images').copy_file()
end

function M.edit_drag_bin_fts_md()
  require('config.my_drag_bin').edit_drag_bin_fts_md()
end

-------------

M.is_dragging = true
M.post_cmd = ''
M.last_file = ''

function M.focuslost()
  M.is_dragging = true
end

function M.readpre(ev)
  if M.is_dragging == true then
    M.post_cmd = require('config.my_drag_images').check(ev.buf)
    if #M.post_cmd == 0 then
      M.post_cmd = require('config.my_drag_docs').check(ev.buf)
    end
    if #M.post_cmd == 0 then
      M.post_cmd = require('config.my_drag_bin').check_xxd(ev.buf)
      -- if #M.post_cmd == 0 then
      --   M.post_cmd = require('config.my_drag_bin').check_others(ev.buf)
      -- end
    end
  end
end

function M.readpost()
  if #M.post_cmd > 0 then
    if type(M.post_cmd) == 'string' then
      pcall(vim.cmd, M.post_cmd)
    elseif type(M.post_cmd) == 'table' then
      M.post_cmd[1](unpack(M.post_cmd[2]))
    end
  end
  M.post_cmd = ''
end

function M.bufenter(ev)
  M.last_file = ev.file
end

return M
