local M = {}

local sha256 = require "sha2"
local path = require "plenary.path"

local note_dir = path:new(vim.g.pack_path):joinpath('nvim_config', 'opt', 'note', 'autoload')

vim.g.get_clipboard_image_ps1 = note_dir:joinpath 'GetClipboardImage.ps1'.filename
vim.g.update_markdown_image_src_py = note_dir:joinpath 'update_markdown_image_src.py'.filename

local pipe_txt_path = path:new(vim.fn.expand '$TEMP'):joinpath 'image_pipe.txt'

------------------
-- getimage
------------------

local human_readable_fsize = function(sz)
  if sz >= 1073741824 then
    sz = string.format("%.1f", sz / 1073741824.0) .. "G"
  elseif sz >= 10485760 then
    sz = string.format("%d", sz / 1048576) .. "M"
  elseif sz >= 1048576 then
    sz = string.format("%.1f", sz / 1048576.0) .. "M"
  elseif sz >= 10240 then
    sz = string.format("%d", sz / 1024) .. "K"
  elseif sz >= 1024 then
    sz = string.format("%.1f", sz / 1024.0) .. "K"
  else
    sz = sz
  end
  return sz
end

local rep = function(p)
  p, _ = string.gsub(p, '/', '\\')
  return p
end

local rep_reverse = function(p)
  p, _ = string.gsub(p, '\\', '/')
  return p
end

local replace = function(str)
  local arr = {}
  for _ in string.gmatch(str, "[^/]+") do
    table.insert(arr, "..")
  end
  return table.concat(arr, "/")
end

function M.getimage(sel_jpg)
  local fname = vim.api.nvim_buf_get_name(0)
  local projectroot_path = path:new(rep(vim.fn['projectroot#get'](fname)))
  if projectroot_path.filename == '' then
    print('not projectroot:', fname)
    return false
  end
  local datetime = os.date "%Y%m%d-%H%M%S-"
  local imagetype = sel_jpg == 'sel_jpg' and 'jpg' or 'png'
  local image_name = vim.fn.input(string.format('Input %s image name (no extension needed!): ', imagetype), datetime)
  if #image_name == 0 then
    print 'get image canceled!'
    return false
  end
  local ft = vim.bo.ft
  local cur_winid = vim.fn.win_getid()
  local linenr = vim.fn.line '.'
  local absolute_image_dir_path = projectroot_path:joinpath 'saved_images'
  if not absolute_image_dir_path:exists() then
    vim.fn.system(string.format('md "%s"', absolute_image_dir_path.filename))
    print("created ->", rep(absolute_image_dir_path.filename))
  end
  local only_image_name = image_name .. '.' .. imagetype
  local raw_image_path = absolute_image_dir_path:joinpath(only_image_name)
  if raw_image_path:exists() then
    print("existed:", rep(raw_image_path.filename))
    return false
  end
  pipe_txt_path:write('', 'w')
  local cmd = string.format('%s "%s" "%s" "%s"', vim.g.get_clipboard_image_ps1, rep(raw_image_path.filename), sel_jpg,
    rep(pipe_txt_path.filename))
  require 'terminal'.send('powershell', cmd, 0)
  local timer = vim.loop.new_timer()
  local timeout = 0
  timer:start(100, 100, function()
    vim.schedule(function()
      timeout = timeout + 1
      local pipe_content = pipe_txt_path:_read()
      local find = string.find(pipe_content, 'success')
      if find then
        timer:stop()
        local raw_image_data = raw_image_path:_read()
        print('save one image:', rep(raw_image_path.filename))
        local absolute_image_hash = string.sub(sha256.sha256(raw_image_data), 1, 8)
        local _md_path = absolute_image_dir_path:joinpath '_.md'
        _md_path:write(
          string.format('![%s-(%d)%s{%s}](%s)\n', only_image_name, #raw_image_data,
            human_readable_fsize(#raw_image_data),
            absolute_image_hash, only_image_name), 'a')
        if ft ~= 'markdown' then
          return false
        end
        local projectroot = rep_reverse(projectroot_path.filename)
        local file_dir = rep_reverse(path:new(fname):parent().filename)
        local rel = string.sub(file_dir, #projectroot + 1, -1)
        rel = replace(rel)
        local image_rel_path
        if #rel > 0 then
          image_rel_path = rel .. '/saved_images/' .. only_image_name
        else
          image_rel_path = 'saved_images/' .. only_image_name
        end
        if cur_winid ~= vim.fn.win_getid() then
          vim.fn.win_gotoid(cur_winid)
        end
        vim.fn.append(linenr, string.format('![%s{%s}](%s)', only_image_name, absolute_image_hash, image_rel_path))
      end
      if timeout > 30 then
        print 'get image timeout 3s'
        timer:stop()
      end
    end)
  end)
end

------------------
-- updatesrc
------------------

local get_saved_images_dirname = function(fname)
  local dir = path:new(fname):parent()
  local cnt = #dir.filename
  while 1 do
    cnt = #dir.filename
    local p = dir:joinpath 'saved_images'
    if p:exists() then
      return dir.filename
    end
    dir = dir:parent()
    if cnt < #dir.filename then
      break
    end
  end
  return nil
end

function M.updatesrc()
  local fname = vim.api.nvim_buf_get_name(0)
  if #fname == 0 then
    print 'no fname'
    return
  end
  local saved_images_dirname = get_saved_images_dirname(fname)
  if not saved_images_dirname then
    print 'no saved_images dir'
    return
  end
  local cmd = string.format('python %s "%s" "%s"', rep_reverse(vim.g.update_markdown_image_src_py),
    rep_reverse(saved_images_dirname), rep_reverse(fname))
  require 'terminal'.send('cmd', cmd, 0)
end

------------------
-- dragimage
------------------

function M.dragimage(sel_jpg, dragimagename)
  local fname = vim.api.nvim_buf_get_name(0)
  local projectroot_path = path:new(rep(vim.fn['projectroot#get'](fname)))
  if projectroot_path.filename == '' then
    print([[not projectroot:]], fname)
    return false
  end
  local datetime = os.date "%Y%m%d-%H%M%S-"
  local imagetype = sel_jpg == 'sel_jpg' and 'jpg' or 'png'
  local image_name = vim.fn.input(string.format('Input %s image name (no extension needed!): ', imagetype), datetime)
  if #image_name == 0 then
    print 'get image canceled!'
    return false
  end
  local cur_winid = vim.fn.win_getid()
  local linenr = vim.fn.line '.'
  local absolute_image_dir_path = projectroot_path:joinpath 'saved_images'
  if not absolute_image_dir_path:exists() then
    vim.fn.system(string.format('md "%s"', absolute_image_dir_path.filename))
    print("created ->", rep(absolute_image_dir_path.filename))
  end
  local only_image_name = image_name .. '.' .. imagetype
  local raw_image_path = absolute_image_dir_path:joinpath(only_image_name)
  if raw_image_path:exists() then
    print("existed:", rep(raw_image_path.filename))
    return false
  end
  vim.fn.system(string.format('copy "%s" "%s"', dragimagename, rep(raw_image_path.filename)))
  local raw_image_data = raw_image_path:_read()
  local absolute_image_hash = string.sub(sha256.sha256(raw_image_data), 1, 8)
  local _md_path = absolute_image_dir_path:joinpath '_.md'
  _md_path:write(string.format('![%s-(%d)%s{%s}](%s)\n', only_image_name, #raw_image_data,
    human_readable_fsize(#raw_image_data), absolute_image_hash, only_image_name), 'a')
  local projectroot = rep_reverse(projectroot_path.filename)
  local file_dir = rep_reverse(path:new(fname):parent().filename)
  local rel = string.sub(file_dir, #projectroot + 1, -1)
  rel = replace(rel)
  local image_rel_path
  if #rel > 0 then
    image_rel_path = rel .. '/saved_images/' .. only_image_name
  else
    image_rel_path = 'saved_images/' .. only_image_name
  end
  if cur_winid ~= vim.fn.win_getid() then
    vim.fn.win_gotoid(cur_winid)
  end
  vim.fn.append(linenr, string.format('![%s{%s}](%s)', only_image_name, absolute_image_hash, image_rel_path))
end

return M
