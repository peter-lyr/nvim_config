local m = require("nvim-tree.marks")
local p = require("plenary.path")
local s = require("plenary.scandir")

-- node: { "hidden", "absolute_path", "extension", "git_status", "type", "fs_stat", "executable", "name", "parent" }

local pp = p:new(vim.g.pack_path):joinpath('nvim_config', 'start', 'lazy', 'lua', 'config')

local recyclebin = pp:joinpath('nvimtree-recyclebin.exe').filename
local copy2clip = pp:joinpath('nvimtree-copy2clip.exe').filename

local M = {}

local rep = function(path)
  path, _ = string.gsub(path, '\\\\', '\\')
  path, _ = string.gsub(path, '//', '\\')
  path, _ = string.gsub(path, '/', '\\')
  return path
end

local get_dtarget = function(node)
  if node.type == 'directory' then
    return rep(node.absolute_path)
  end
  if node.type == 'file' then
    return rep(node.parent.absolute_path)
  end
  return nil
end

local get_fname_tail = function(fname)
  fname = string.gsub(fname, "/", "\\")
  local path = p:new(fname)
  if path:is_file() then
    fname = path:_split()
    return fname[#fname]
  elseif path:is_dir() then
    fname = path:_split()
    if #fname[#fname] > 0 then
      return fname[#fname]
    else
      return fname[#fname - 1]
    end
  end
  return ''
end

M.test = function(node)
  print(node.type)
end

M.toggle_sel = function(node)
  m.toggle_mark(node)
  local marks = m.get_marks()
  print('selected', #marks, 'items.')
  vim.cmd('norm j')
end

M.toggle_sel_up = function(node)
  m.toggle_mark(node)
  local marks = m.get_marks()
  print('selected', #marks, 'items.')
  vim.cmd('norm k')
end

M.empty_sel = function()
  m.clear_marks()
  print('empty selected.')
end

M.delete_sel = function()
  local marks = m.get_marks()
  local res = vim.fn.input("Confirm deletion " .. #marks .. " [N/y] ", "y")
  if vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES' }, res) == true then
    for _, v in ipairs(marks) do
      local absolute_path = v['absolute_path']
      local path = p:new(absolute_path)
      if path:is_dir() then
        local entries = s.scan_dir(absolute_path, { hidden = true, depth = 10, add_dirs = false })
        for _, entry in ipairs(entries) do
          pcall(vim.cmd, "bw! " .. rep(entry))
        end
      else
        pcall(vim.cmd, "bw! " .. rep(absolute_path))
      end
      vim.fn.system(string.format('%s "%s"', recyclebin, absolute_path:match('^(.-)\\*$')))
    end
    m.clear_marks()
    vim.g.tabline_done = 0
  else
    print('canceled!')
  end
end

M.move_sel = function(node)
  local dtarget = get_dtarget(node)
  if not dtarget then
    return
  end
  local marks = m.get_marks()
  local res = vim.fn.input(dtarget .. "\nConfirm movment " .. #marks .. " [N/y] ", "y")
  if vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES' }, res) == true then
    for _, v in ipairs(marks) do
      local absolute_path = v['absolute_path']
      if p:new(absolute_path):is_dir() then
        local dname = get_fname_tail(absolute_path)
        dname = string.format('%s\\%s', dtarget, dname)
        if p:new(dname):exists() then
          vim.cmd('redraw')
          local dname_new = vim.fn.input(absolute_path .. " ->\nExisted! Rename? ", dname)
          if #dname_new > 0 and dname_new ~= dname then
            vim.fn.system(string.format('move "%s" "%s"', string.sub(absolute_path, 1, #absolute_path - 1), dname_new))
          elseif #dname_new == 0 then
            print('cancel all!')
            return
          else
            vim.cmd('redraw')
            print(absolute_path .. ' -> failed!')
            goto continue
          end
        else
          vim.fn.system(string.format('move "%s" "%s"', string.sub(absolute_path, 1, #absolute_path - 1), dname))
        end
      else
        local fname = get_fname_tail(absolute_path)
        fname = string.format('%s\\%s', dtarget, fname)
        if p:new(fname):exists() then
          vim.cmd('redraw')
          local fname_new = vim.fn.input(absolute_path .. " ->\nExisted! Rename? ", fname)
          if #fname_new > 0 and fname_new ~= fname then
            vim.fn.system(string.format('move "%s" "%s"', absolute_path, fname_new))
          elseif #fname_new == 0 then
            print('cancel all!')
            return
          else
            vim.cmd('redraw')
            print(absolute_path .. ' -> failed!')
            goto continue
          end
        else
          vim.fn.system(string.format('move "%s" "%s"', absolute_path, fname))
        end
      end
      pcall(vim.cmd, "bw! " .. rep(absolute_path))
      ::continue::
    end
    m.clear_marks()
    vim.g.tabline_done = 0
  else
    print('canceled!')
  end
end

M.copy_sel = function(node)
  local dtarget = get_dtarget(node)
  if not dtarget then
    return
  end
  local marks = m.get_marks()
  local res = vim.fn.input(dtarget .. "\nConfirm copy " .. #marks .. " [N/y] ", "y")
  if vim.tbl_contains({ 'y', 'Y', 'yes', 'Yes', 'YES' }, res) == true then
    for _, v in ipairs(marks) do
      local absolute_path = v['absolute_path']
      if p:new(absolute_path):is_dir() then
        local dname = get_fname_tail(absolute_path)
        dname = string.format('%s\\%s', dtarget, dname)
        if p:new(dname):exists() then
          vim.cmd('redraw')
          local dname_new = vim.fn.input(absolute_path .. " ->\nExisted! Rename? ", dname)
          if #dname_new > 0 and dname_new ~= dname then
            if string.sub(dname_new, #dname_new, #dname_new) ~= '\\' then
              dname_new = dname_new .. '\\'
            end
            vim.fn.system(string.format('xcopy "%s" "%s" /s /e /f', absolute_path, dname_new))
          elseif #dname_new == 0 then
            print('cancel all!')
            return
          else
            vim.cmd('redraw')
            print(absolute_path .. ' -> failed!')
            goto continue
          end
        else
          if string.sub(dname, #dname, #dname) ~= '\\' then
            dname = dname .. '\\'
          end
          vim.fn.system(string.format('xcopy "%s" "%s" /s /e /f', absolute_path, dname))
        end
      else
        local fname = get_fname_tail(absolute_path)
        fname = string.format('%s\\%s', dtarget, fname)
        if p:new(fname):exists() then
          vim.cmd('redraw')
          local fname_new = vim.fn.input(absolute_path .. "\n ->Existed! Rename? ", fname)
          if #fname_new > 0 and fname_new ~= fname then
            vim.fn.system(string.format('copy "%s" "%s"', absolute_path, fname_new))
          elseif #fname_new == 0 then
            print('cancel all!')
            return
          else
            vim.cmd('redraw')
            print(absolute_path .. ' -> failed!')
            goto continue
          end
        else
          vim.fn.system(string.format('copy "%s" "%s"', absolute_path, fname))
        end
      end
      ::continue::
    end
    m.clear_marks()
  else
    print('canceled!')
  end
end

local temppath = p:new(vim.fn.expand('$temp'))

M.rename_sel = function(_)
  local marks = m.get_marks()
  local lines = {}
  for _, v in ipairs(marks) do
    local absolute_path = v.absolute_path
    if not p:new(absolute_path):is_dir() then
      table.insert(lines, absolute_path)
    end
  end
  for _, v in ipairs(marks) do
    local absolute_path = v.absolute_path
    if p:new(absolute_path):is_dir() then
      table.insert(lines, absolute_path)
    end
  end
  vim.cmd('hide')
  vim.cmd('new')
  local diff1 = vim.fn.bufnr()
  vim.cmd('set noro')
  vim.cmd('set ma')
  vim.fn.setline(1, lines)
  vim.cmd('diffthis')
  vim.cmd('set ro')
  vim.cmd('set noma')
  vim.cmd('vnew')
  local diff2 = vim.fn.bufnr()
  vim.cmd('set noro')
  vim.cmd('set ma')
  vim.fn.setline(1, lines)
  vim.cmd('diffthis')
  vim.cmd('call feedkeys("zR$")')
  local timer = vim.loop.new_timer()
  local tmp1 = 0
  local pattern = "^[:\\/%w%s%-%._%(%)%[%]一-龥]+$"
  timer:start(100, 100, function()
    vim.schedule(function()
      if (vim.fn.bufwinnr(diff1) == -1 or vim.fn.bufwinnr(diff2) == -1) then
        if vim.fn.bufwinnr(diff1) == -1 and vim.fn.bufwinnr(diff2) == -1 then
          tmp1 = tmp1 + 1
          if tmp1 > 10 * 60 * 5 then
            timer:stop()
            pcall(vim.cmd, diff1 .. 'bw!')
            pcall(vim.cmd, diff2 .. 'bw!')
            print('canceled!')
          end
          return
        end
        timer:stop()
        local lines1 = vim.fn.getbufline(diff1, 1, '$')
        local lines2 = vim.fn.getbufline(diff2, 1, '$')
        local cnt1 = 0
        local cnt2 = 0
        for _, v in ipairs(lines1) do
          if #vim.fn.trim(v) > 0 and string.match(v, pattern) then
            cnt1 = cnt1 + 1
          end
        end
        for _, v in ipairs(lines2) do
          if #vim.fn.trim(v) > 0 and string.match(v, pattern) then
            cnt2 = cnt2 + 1
          end
        end
        if cnt1 ~= cnt2 then
          pcall(vim.cmd, diff1 .. 'bw!')
          pcall(vim.cmd, diff2 .. 'bw!')
          print(cnt1, '~=', cnt2)
          return
        end
        local cnt = 1
        local cmds = {}
        for _, v in ipairs(lines1) do
          local v1 = vim.fn.trim(v)
          if #v1 > 0 and string.match(v1, pattern) then
            local v1path = p:new(v1)
            if v1path:is_dir() then
              if string.sub(v1, #v1, #v1) ~= '\\' then
                cmds[cnt] = { 0, v1 .. '\\' }
              else
                cmds[cnt] = { 0, v1 }
              end
            else
              cmds[cnt] = { 1, v1 }
            end
            cnt = cnt + 1
          end
        end
        for k, v in pairs(cmds) do
          local is_file = v[1]
          local src = v[2]
          src = string.gsub(src, '[/\\:]', '_')
          src = temppath:joinpath(src).filename
          if is_file == 0 then
            table.insert(cmds[k], src .. '\\')
          else
            table.insert(cmds[k], src)
          end
        end
        cnt = 1
        for _, v in ipairs(lines2) do
          local v1 = vim.fn.trim(v)
          if #v1 > 0 and string.match(v1, pattern) then
            local is_file = cmds[cnt][1]
            if is_file == 0 then
              if string.sub(v1, #v1, #v1) ~= '\\' then
                table.insert(cmds[cnt], v1 .. '\\')
              else
                table.insert(cmds[cnt], v1)
              end
            else
              table.insert(cmds[cnt], v1)
            end
            cnt = cnt + 1
          end
        end
        for _, v in pairs(cmds) do
          local s1 = v[2]
          local s2 = v[3]
          if v[1] == 0 then
            s1 = string.sub(v[2], 0, #v[2] - 1)
            s2 = string.sub(v[3], 0, #v[3] - 1)
          end
          vim.fn.system(string.format('move "%s" "%s"', s1, s2))
        end
        for _, v in pairs(cmds) do
          local s2 = v[3]
          local s3 = v[4]
          if v[1] == 0 then
            s2 = string.sub(v[3], 0, #v[3] - 1)
            s3 = string.sub(v[4], 0, #v[4] - 1)
          end
          vim.fn.system(string.format('move "%s" "%s"', s2, s3))
        end
        pcall(vim.cmd, diff1 .. 'bw!')
        pcall(vim.cmd, diff2 .. 'bw!')
        m.clear_marks()
      end
    end)
  end)
end

M.copy_2_clip = function()
  local marks = m.get_marks()
  local files = ""
  for _, v in ipairs(marks) do
    files = files .. " " .. '"' .. v.absolute_path .. '"'
  end
  vim.fn.system(string.format('%s%s', copy2clip, files))
  m.clear_marks()
end

M.paste_from_clip = function(node)
  local dtarget = get_dtarget(node)
  if not dtarget then
    return
  end
  local cmd = string.format(
    [[Get-Clipboard -Format FileDropList | ForEach-Object { Copy-Item -Path $_.FullName -Destination "%s" }]],
    dtarget)
  local save_cursor = vim.fn.getpos(".")
  require('terminal').send('powershell', cmd, 0)
  vim.fn.timer_start(200, function()
    vim.cmd('wincmd t')
    pcall(vim.fn.setpos, '.', save_cursor)
  end)
end

M.delete = function(node)
  if node.type == 'file' then
    vim.cmd('Bdelete ' .. node.absolute_path)
  elseif node.type == 'directory' then
    -- if node.has_children == true then
    -- end
  end
end

M.wipeout = function(node)
  if node.type == 'file' then
    vim.cmd('Bwipeout ' .. node.absolute_path)
  end
end

M.edgy_autosize_toggle = function()
  if vim.g.edgy_autosize_en == 1 then
    vim.g.edgy_autosize_en = 0
  else
    vim.g.edgy_autosize_en = 1
  end
end

M.explorer = function(node)
  local dtarget = get_dtarget(node)
  if not dtarget then
    return
  end
  vim.fn.system(string.format([[start /b cmd /c "explorer "%s""]], dtarget))
end

M.taskkill = function(node)
  if node.type == 'file' then
    if node.extension == 'exe' then
      local file = get_fname_tail(node.absolute_path)
      vim.fn.system('taskkill /f /im ' .. file)
    end
  end
end

M.ausize = function(_, short_dis)
  local width = 0
  local height = math.min(vim.fn.line('$'), vim.opt.lines:get() - 9)
  for linenr = 2, height do
    local len = vim.fn.strdisplaywidth(vim.fn.getline(linenr))
    if len > width then
      width = len
    end
  end
  local win = require("edgy.editor").get_win()
  if not win then
    return
  end
  local save_cursor = vim.fn.getpos(".")
  local temp = 2 + 4
  if vim.opt.nu:get() == true or vim.opt.rnu:get() == true then
    temp = temp + #tostring(vim.fn.line('$')) + 1
  end
  local ok = nil
  if width - win.width + temp > 0 or not short_dis then
    win:resize("width", width - win.width + temp)
    ok = 1
  end
  if height - win.height > 0 then
    win:resize("height", height - win.height)
    ok = 1
  end
  if ok then
    pcall(vim.fn.setpos, '.', save_cursor)
    vim.cmd("norm 99zH")
  end
end

M.diff1 = function(node)
  vim.cmd('Bcomp1 ' .. node.absolute_path)
end

M.diff2 = function(node)
  vim.cmd('Bcomp2 ' .. node.absolute_path)
end

return M
