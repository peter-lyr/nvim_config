package.loaded['config.nvimtree-oftendirs'] = nil

local M = {}

M.all_dirs = {}

local function systemcd(p)
  local s = ''
  if string.sub(p, 2, 2) == ':' then
    s = s .. string.sub(p, 1, 2) .. ' && '
  end
  if require 'plenary.path'.new(p):is_dir() then
    s = s .. 'cd ' .. p
  else
    s = s .. 'cd ' .. require 'plenary.path'.new(p):parent().filename
  end
  return s
end

---------------
-- 1. my dirs
---------------

local nv = require 'plenary.path':new(vim.fn.expand '$VIMRUNTIME'):parent():parent():parent():parent()

local mydirs = {}
local mydirs_existed = {}

M.init_mydirs = function()
  mydirs = {
    vim.fn.expand [[$HOME]],
    vim.fn.expand [[$TEMP]],
    vim.fn.expand [[$LOCALAPPDATA]],
    vim.fn.expand [[$VIMRUNTIME\pack]],
    vim.fn.expand [[$VIMRUNTIME\pack\nvim_config]],
    vim.fn.expand [[$VIMRUNTIME\pack\lazy\plugins]],
    nv.filename,
  }
  mydirs_existed = {}
  for _, dir in ipairs(mydirs) do
    if vim.fn.isdirectory(dir) then
      dir = vim.fn.tolower(dir)
      table.insert(mydirs_existed, dir)
      table.insert(M.all_dirs, dir)
    end
  end
  for i = 1, 26 do
    local dir = vim.fn.nr2char(64 + i) .. [[:\]]
    if vim.fn.isdirectory(dir) == 1 then
      dir = vim.fn.tolower(dir)
      table.insert(mydirs_existed, dir)
      table.insert(M.all_dirs, dir)
    end
  end
end

M.init_mydirs()

M.open_mydirs = function()
  vim.ui.select(vim.fn.sort(mydirs_existed), { prompt = 'my dirs', }, function(choice)
    if not choice then
      return
    end
    vim.cmd 'NvimTreeOpen'
    vim.loop.new_timer():start(10, 0, function()
      vim.schedule(function()
        vim.cmd('cd ' .. choice)
      end)
    end)
  end)
end

M.reopen_mydirs = function()
  M.init_mydirs()
  vim.ui.select(vim.fn.sort(mydirs_existed), { prompt = 'reopen my dirs', }, function(choice)
    if not choice then
      return
    end
    vim.cmd 'NvimTreeOpen'
    vim.loop.new_timer():start(10, 0, function()
      vim.schedule(function()
        vim.cmd('cd ' .. choice)
      end)
    end)
  end)
end

---------------
-- 2.1 path dirs
---------------

local pathdirs = {}

M.init_pathdirs = function()
  for pathdir in string.gmatch(vim.fn.expand [[$PATH]], '([^;]+);') do
    if vim.fn.isdirectory(pathdir) == 1 then
      pathdir = vim.fn.tolower(pathdir)
      if vim.tbl_contains(pathdirs, pathdir) == false then
        table.insert(pathdirs, pathdir)
      end
      if vim.tbl_contains(M.all_dirs, pathdir) == false then
        table.insert(M.all_dirs, pathdir)
      end
    end
  end
end

M.init_pathdirs()

M.open_pathdirs = function()
  vim.ui.select(vim.fn.sort(pathdirs), { prompt = 'path dirs', }, function(choice)
    if not choice then
      return
    end
    vim.cmd 'NvimTreeOpen'
    vim.loop.new_timer():start(10, 0, function()
      vim.schedule(function()
        vim.cmd('cd ' .. choice)
      end)
    end)
  end)
end

---------------
-- 2.2 path exe files
---------------

local pathfiles = {}

M.init_pathfiles = function()
  local scan_dir = require 'plenary.scandir'
  local exts = {}
  for ext in string.gmatch(vim.fn.expand [[$PATHEXT]], '([^;]+);') do
    table.insert(exts, vim.fn.tolower(ext))
  end
  for pathdir in string.gmatch(vim.fn.expand [[$PATH]], '([^;]+);') do
    local entries = scan_dir.scan_dir(pathdir, {
      hidden = false,
      depth = 1,
      add_dirs = false,
      search_pattern = function(e)
        return vim.tbl_contains(exts, vim.fn.tolower(string.match(e, '(%..+)$')))
      end,
    })
    for _, entry in ipairs(entries) do
      if vim.tbl_contains(pathfiles, entry) == false then
        table.insert(pathfiles, entry)
      end
    end
  end
end

M.init_pathfiles()

M.open_pathfiles = function()
  vim.ui.select(vim.fn.sort(pathfiles), { prompt = 'path files', }, function(choice)
    if not choice then
      return
    end
    vim.cmd(string.format([[silent !start /b /min cmd /c "%s && %s"]], systemcd(choice), choice))
  end)
end

---------------
-- 3. often dirs
---------------

local oftendirs = {}
local config = require 'plenary.path':new(vim.g.pack_path):joinpath('nvim_config', 'start', 'lazy', 'lua', 'config')
local oftendir_exe = config:joinpath 'nvimtree-oftendirs.exe'

M.init_oftendir = function()
  local res = true
  if not oftendir_exe:exists() then
    vim.cmd(string.format(
      [[silent !start /b /min cmd /c "%s && gcc nvimtree-oftendirs.c -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o nvimtree-oftendirs"]],
      systemcd(config.filename)))
    res = nil
  end
  local f = io.popen(oftendir_exe.filename)
  for dir in string.gmatch(f:read '*a', '([%S ]+)') do
    dir = vim.fn.tolower(dir)
    if vim.tbl_contains(oftendirs, dir) == false then
      table.insert(oftendirs, dir)
    end
    if vim.tbl_contains(M.all_dirs, dir) == false then
      table.insert(M.all_dirs, dir)
    end
  end
  f:close()
  return res
end

local exe_created = M.init_oftendir()

M.open_oftendirs = function()
  if not exe_created or not oftendir_exe:exists() then
    exe_created = M.init_oftendir()
    if exe_created then
      print(oftendir_exe .. ' created!')
    else
      print(oftendir_exe .. ' not created!')
    end
    return
  end
  vim.ui.select(vim.fn.sort(oftendirs), { prompt = 'often dirs', }, function(choice)
    if not choice then
      return
    end
    vim.cmd 'NvimTreeOpen'
    vim.loop.new_timer():start(10, 0, function()
      vim.schedule(function()
        vim.cmd('cd ' .. choice)
      end)
    end)
  end)
end

---------------
-- 10. explorer all dirs
---------------

M.explorer = function()
  vim.ui.select(vim.fn.sort(M.all_dirs), { prompt = 'explorer all dirs', }, function(choice)
    if not choice then
      return
    end
    vim.cmd(string.format([[silent !start /b /min cmd /c "%s && explorer %s"]], systemcd(choice), choice))
  end)
end

return M
