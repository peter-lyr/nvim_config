local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

M.image_root_dir = '.images'
M.image_root_md = '_.md'

M.markdowns_fts = {
  'md',
}

M.images_fts = {
  'jpg', 'png',
}

M.get_hash = function(file)
  return require 'sha2'.sha256(require 'plenary.path':new(file):_read())
end

M.get_relative_head = function(base_file, target_file)
  local relative = string.sub(target_file, #base_file + 2, #target_file)
  relative = vim.fn.fnamemodify(relative, ':h')
  if relative == '.' then
    return '.'
  end
  relative = string.gsub(relative, '(\\)', '/')
  return string.gsub(relative, '([^/]+)', '..')
end

M.copy_image = function(src, tgt)
  vim.fn.system(string.format('copy /y "%s" "%s"', src, tgt))
end

M.prepare = function(project, image_fname, markdown_fname)
  M.project = project
  M.image_fname = image_fname
  M.markdown_fname = markdown_fname
  M.markdown_rel_head_dot = M.get_relative_head(M.project, M.markdown_fname)
  M.image_root_dir_path = require 'plenary.path':new(M.project):joinpath(M.image_root_dir)
  if not M.image_root_dir_path:exists() then
    vim.fn.mkdir(M.image_root_dir_path.filename)
  end
  M.image_fname_tail = vim.fn.fnamemodify(M.image_fname, ':t')
  M.image_fname_tail_root = vim.fn.fnamemodify(M.image_fname_tail, ':r')
  M.image_fname_tail_ext = vim.fn.fnamemodify(M.image_fname_tail, ':e')
  M.image_hash_64 = M.get_hash(M.image_fname)
  M.image_hash_8 = string.sub(M.image_hash_64, 1, 8)
  M.image_hash_name = M.image_hash_8 .. '.' .. M.image_fname_tail_ext
  M.image_target_file = B.rep_slash_lower(M.image_root_dir_path:joinpath(M.image_hash_name).filename)
  M.image_root_md_path = M.image_root_dir_path:joinpath(M.image_root_md)
end

M.save_image = function()
  M.copy_image(M.image_fname, M.image_target_file)
end

M.append_info = function()
  local _url = B.rep_baskslash_lower(M.image_hash_name)
  local _line = string.format('%s![%s](%s)\n', M.image_hash_64, M.image_fname_tail_root, _url)
  M.image_root_md_path:write(_line, 'a')
end

M.has_hash_8 = function()
  local hash = M.image_root_dir .. '/' .. M.image_hash_8
  if string.match(require 'plenary.path':new(M.markdown_fname):read(), hash) then
    return hash
  end
  return nil
end

M.append_line_pre = function()
  local url = B.rep_baskslash_lower(
    require 'plenary.path':new(M.markdown_rel_head_dot):joinpath(
      M.image_root_dir, M.image_hash_8 .. '.' .. M.image_fname_tail_ext
    ).filename)
  return string.format('![%s](%s)', M.image_fname_tail_root, url)
end

M.append_line_do = function(line)
  vim.fn.append(vim.fn.line '.', line)
end

M.append_line = function()
  M.append_line_do(M.append_line_pre())
end

M.append_image = function(project, image_fname, markdown_fname)
  M.prepare(project, image_fname, markdown_fname)
  M.save_image()
  M.append_info()
  local callback = function(result)
    vim.cmd 'Bdelete!'
    vim.fn.timer_start(50, function()
      M.append_line_do(result)
    end)
  end
  return { callback, { M.append_line_pre(), }, }
end

M.asyncrunprepare = function()
  local l1 = 0
  AsyncrunTimer = nil
  AsyncrunTimer = vim.loop.new_timer()
  AsyncrunTimer:start(300, 100, function()
    vim.schedule(function()
      local temp = #vim.fn.getqflist()
      if l1 ~= temp then
        pcall(require 'quickfix'.ausize)
        l1 = temp
      end
    end)
  end)
  AsyncRunDone = function()
    if AsyncrunTimer then
      AsyncrunTimer:stop()
    end
    local l2 = vim.fn.getqflist()
    if #l2 > 2 then
      vim.notify(l2[1]['text'] .. '\n' .. l2[#l2 - 1]['text'] .. '\n' .. l2[#l2]['text'])
    else
      vim.notify(l2[1]['text'] .. '\n' .. l2[2]['text'])
    end
    vim.cmd 'au! User AsyncRunStop'
    vim.cmd 'e!'
  end
  vim.cmd [[au User AsyncRunStop call v:lua.AsyncRunDone()]]
end

local function system_run(way, str_format, ...)
  local cmd = string.format(str_format, ...)
  if way == 'start' then
    cmd = string.format([[silent !start cmd /c "%s"]], cmd)
    vim.cmd(cmd)
  elseif way == 'asyncrun' then
    cmd = string.format('AsyncRun %s', cmd)
    M.asyncrunprepare()
    vim.cmd(cmd)
  elseif way == 'term' then
    cmd = string.format('wincmd s|term %s', cmd)
    vim.cmd(cmd)
  end
end

M.update = function(cur)
  local drag_images_docs_update_py = require 'plenary.path':new(M.source .. '.update.py')
  local project = B.rep_slash_lower(vim.fn['ProjectRootGet']())
  local fname = vim.api.nvim_buf_get_name(0)
  local ext = string.match(fname, '%.([^.]+)$')
  if cur == 'cur' and 1 then
    if vim.tbl_contains(M.markdowns_fts, ext) == true then
      cur = fname
      B.notify_info('[updating] markdown image cur: `' .. vim.fn.fnamemodify(fname, ':t') .. '`')
    else
      B.notify_info('update markdown image cur [failed]: not markdown: `' .. vim.fn.fnamemodify(fname, ':t') .. '`')
      return
    end
  else
    B.notify_info('[updating] markdown image cwd: `' .. project .. '`')
    cur = ''
  end
  system_run('asyncrun', 'python "%s" "%s" "%s" "%s"', drag_images_docs_update_py, project, M.image_root_md, cur)
end

M.paste_check = function()
  local fname = vim.api.nvim_buf_get_name(0)
  local ext = string.match(fname, '%.([^.]+)$')
  if vim.tbl_contains(M.markdowns_fts, ext) == false then
    return ''
  end
  local project = B.rep_slash_lower(vim.fn['ProjectRootGet'](fname))
  if #project == 0 then
    B.notify_info('not in a project: `' .. fname .. '`')
    return ''
  end
  vim.g.temp_image_en = 0
  vim.cmd [[
    python << EOF
import vim
from PIL import ImageGrab, Image
img = ImageGrab.grabclipboard()
if isinstance(img, Image.Image):
  vim.command('let g:temp_image_en = 1')
EOF
  ]]
  return vim.g.temp_image_en
end

M.paste_do = function(png, no_input_image_name)
  local fname = vim.api.nvim_buf_get_name(0)
  local project = B.rep_slash_lower(vim.fn['ProjectRootGet'](fname))
  local image_name = vim.fn.strftime '%Y%m%d-%A-%H%M%S'
  if not no_input_image_name then
    image_name = vim.fn.input('Input ' .. png .. ' image name: ', vim.fn.strftime '%Y%m%d-%A-%H%M%S-')
  end
  vim.g.temp_image_file = require 'plenary.path':new(vim.fn.expand '$temp'):joinpath(image_name .. '.' .. png).filename
  vim.g.temp_image_ext = png
  vim.g.temp_image_drag = require 'plenary.path':new(M.source):parent().filename
  vim.cmd [[
  python << EOF
import vim
import subprocess
arg1 = vim.eval('g:temp_image_file')
arg2 = vim.eval('g:temp_image_ext')
cwd = vim.eval('g:temp_image_drag')
psxmlgen = subprocess.Popen([r'powershell.exe', '-ExecutionPolicy', 'Unrestricted', './my_drag_images.lua.GetClipboardImage.ps1', arg1, arg2], cwd=cwd)
psxmlgen.wait()
EOF
  ]]
  if require 'plenary.path':new(vim.g.temp_image_file):exists() then
    M.prepare(project, vim.g.temp_image_file, fname)
    M.save_image()
    M.append_info()
    M.append_line()
  else
    B.notify_info 'get image failed.'
  end
end

M.paste = function(png, no_input_image_name)
  if M.paste_check() == 0 then
    B.notify_info 'no image in clipboard.'
    return
  end
  M.paste_do(png, no_input_image_name)
end

M.copy_text = function()
  local cfile = require 'plenary.path':new(vim.loop.cwd()):joinpath(unpack(vim.fn.split(vim.fn.expand '<cfile>', '/'))).filename
  vim.fn.setreg('+', cfile)
  print('copy text to clipboard: ' .. cfile)
end

M.get_desktop = function()
  local my_drag_images_lua_desktop_c_path = require 'plenary.path':new(M.source .. '.desktop.c')
  local my_drag_images_lua_desktop_exe_path = my_drag_images_lua_desktop_c_path:parent():joinpath 'my_drag_images.lua.desktop.exe'
  if not my_drag_images_lua_desktop_exe_path:exists() then
    vim.cmd(string.format(
      [[silent !start /b /min cmd /c "%s && gcc my_drag_images.lua.desktop.c -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o my_drag_images.lua.desktop.exe"]],
      B.system_cd(my_drag_images_lua_desktop_c_path.filename)))
  end
  local f = io.popen(my_drag_images_lua_desktop_exe_path.filename)
  if f then
    for dir in string.gmatch(f:read '*a', '([%S ]+)') do
      f:close()
      return vim.fn.tolower(dir)
    end
    f:close()
  end
  return ''
end

M.drag_images_copy2clip_exe = require 'plenary.path':new(M.source .. '.copy2clip.exe')

M.copy_file = function()
  local cfile = require 'plenary.path':new(vim.loop.cwd()):joinpath(unpack(vim.fn.split(vim.fn.expand '<cfile>', '/'))).filename
  if require 'plenary.path':new(cfile):exists() then
    local desktop = M.get_desktop()
    local desktop_p = require 'plenary.path':new(desktop)
    if desktop_p:exists() then
      local line = vim.fn.getline '.'
      local fname = string.match(line, '%[([^%]]+)%]%([^%)]+%)')
      if fname then
        local ext = string.match(cfile, '%.([^.]+)$')
        local tgt = desktop_p:joinpath(fname .. '.' .. ext).filename
        vim.fn.system(string.format('copy /y "%s" "%s"', cfile, tgt))
        vim.fn.system(string.format('%s "%s"', M.drag_images_copy2clip_exe, tgt))
        print('copy file to clipboard: ' .. tgt)
      else
        vim.fn.system(string.format('%s "%s"', M.drag_images_copy2clip_exe, cfile))
        print('copy file to clipboard: ' .. cfile)
      end
    end
  else
    print('not exists: ' .. cfile)
  end
end

M.is_dragged = function(project, buf)
  local image_root_dir_path = require 'plenary.path':new(project):joinpath(M.image_root_dir)
  local image_root_md_path = image_root_dir_path:joinpath(M.image_root_md)
  if not require 'plenary.path':new(image_root_md_path):exists() then
    return nil
  end
  local content = image_root_md_path:read()
  local image_fname = B.rep_slash_lower(vim.api.nvim_buf_get_name(buf))
  if not require 'plenary.path':new(image_fname):exists() then
    return nil
  end
  local hash_64 = M.get_hash(image_fname)
  if string.match(content, hash_64) then
    return 1
  end
  return nil
end

M.check = function(buf)
  local markdown_fname = B.rep_slash_lower(require 'config.my_drag'.last_file)
  local project = B.rep_slash_lower(vim.fn['ProjectRootGet'](markdown_fname))
  if #project == 0 then
    B.notify_info('not in a project: ' .. markdown_fname)
    return ''
  end
  if M.is_dragged(project, buf) then
    local image_fname = B.rep_slash_lower(vim.api.nvim_buf_get_name(buf))
    B.notify_info('is dragged: ' .. image_fname)
    local callback = function(result)
      vim.cmd 'Bdelete!'
      M.prepare(project, image_fname, markdown_fname)
      local hash = M.has_hash_8()
      if hash then
        vim.fn.system('QuickLook.exe ' .. result)
        B.notify_info('In markdown: ' .. hash)
      else
        M.append_line()
      end
    end
    return { callback, { image_fname, }, }
  end
  local ext = string.match(markdown_fname, '%.([^.]+)$')
  if vim.tbl_contains(M.markdowns_fts, ext) == true then
    local image_fname = B.rep_slash_lower(vim.api.nvim_buf_get_name(buf))
    ext = string.match(image_fname, '%.([^.]+)$')
    if vim.tbl_contains(M.images_fts, ext) == true then
      return M.append_image(project, image_fname, markdown_fname)
    end
  end
  return ''
end

MClick = function()
  M.paste_do('jpg', 1)
end

M.middle_click = function()
  if vim.fn.getmousepos()['line'] == 0 then
    return '<MiddleMouse>'
  end
  if M.paste_check() == 1 then
    return ':<c-u>call v:lua.MClick()<cr>'
  end
  return '<MiddleMouse>'
end

vim.keymap.set({ 'n', 'v', }, '<MiddleMouse>', M.middle_click, { desc = '<MiddleMouse>', expr = true, })

return M
