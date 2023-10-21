local M = {}
local B = require 'my_base'
M.source = debug.getinfo(1)['source']
package.loaded[B.get_loaded(M.source)] = nil
--------------------------------------------

M.all_dirs = {}

---------------
-- 1. my dirs
---------------

M.nv_dir = require 'plenary.path':new(vim.fn.expand '$VIMRUNTIME')
  :parent():parent():parent():parent()

M.mydirs = {}
M.mydirs_existed = {}

M.init_mydirs = function()
  M.mydirs = {
    vim.fn.expand [[$HOME]],
    vim.fn.expand [[$VIMRUNTIME\pack\nvim_config]],
    M.nv_dir.filename,
  }
  M.mydirs_existed = {}
  for _, dir in ipairs(M.mydirs) do
    if vim.fn.isdirectory(dir) then
      dir = vim.fn.tolower(dir)
      table.insert(M.mydirs_existed, dir)
      table.insert(M.all_dirs, dir)
    end
  end
  for i = 1, 26 do
    local dir = vim.fn.nr2char(64 + i) .. [[:\]]
    if vim.fn.isdirectory(dir) == 1 then
      dir = vim.fn.tolower(dir)
      table.insert(M.mydirs_existed, dir)
      table.insert(M.all_dirs, dir)
    end
  end
end

M.init_mydirs()

M.open_mydirs = function()
  B.ui_sel(vim.fn.sort(M.mydirs_existed), 'my dirs', function(choice)
    if choice then
      vim.cmd 'NvimTreeOpen'
      B.set_timeout(10, function()
        vim.cmd('cd ' .. choice)
      end)
    end
  end)
end

M.reopen_mydirs = function()
  M.init_mydirs()
  B.ui_sel(vim.fn.sort(M.mydirs_existed), 'reopen my dirs', function(choice)
    if choice then
      vim.cmd 'NvimTreeOpen'
      B.set_timeout(10, function()
        vim.cmd('cd ' .. choice)
      end)
    end
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
      B.table_check_insert(pathdirs, pathdir)
      B.table_check_insert(M.all_dirs, pathdir)
    end
  end
end

M.init_pathdirs()

M.open_pathdirs = function()
  B.ui_sel(vim.fn.sort(pathdirs), 'path dirs', function(choice)
    if choice then
      vim.cmd 'NvimTreeOpen'
      B.set_timeout(10, function()
        vim.cmd('cd ' .. choice)
      end)
    end
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
      B.table_check_insert(pathfiles, entry)
    end
  end
end

M.init_pathfiles()

M.open_pathfiles = function()
  B.ui_sel(vim.fn.sort(pathfiles), 'path files', function(choice)
    if choice then
      B.system_run('start', "%s && %s", B.system_cd(choice), choice)
    end
  end)
end

---------------
-- 3. often dirs
---------------

M.oftendirs = {}
M.nvimtree_oftendirs_exe_path = B.get_file_path(B.get_dir_path({
  vim.g.pack_path, 'nvim_config', 'start', 'lazy', 'lua', 'config',
}), 'nvimtree_oftendirs.exe')

M.init_oftendir = function()
  local res = 1
  if not M.nvimtree_oftendirs_exe_path:exists() then
    B.system_run([["%s && gcc nvimtree_oftendirs.c -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o nvimtree_oftendirs"]],
      B.system_cd(M.nvimtree_oftendirs_exe_path.filename))
    res = nil
  end
  local f = io.popen(M.nvimtree_oftendirs_exe_path.filename)
  if f then
    for dir in string.gmatch(f:read '*a', '([%S ]+)') do
      dir = vim.fn.tolower(dir)
      B.table_check_insert(M.oftendirs, dir)
      B.table_check_insert(M.all_dirs, dir)
    end
    f:close()
  end
  return res
end

M.nvimtree_oftendirs_exe_created = M.init_oftendir()

M.open_oftendirs = function()
  if not M.nvimtree_oftendirs_exe_created or not M.nvimtree_oftendirs_exe_path:exists() then
    M.nvimtree_oftendirs_exe_created = M.init_oftendir()
    if M.nvimtree_oftendirs_exe_created then
      B.notify_info(M.nvimtree_oftendirs_exe_path .. ' created!')
    else
      B.notify_info(M.nvimtree_oftendirs_exe_path .. ' not created!')
      return
    end
  end
  B.ui_sel(vim.fn.sort(M.oftendirs), 'often dirs', function(choice)
    if choice then
      vim.cmd 'NvimTreeOpen'
      B.set_timeout(10, function()
        vim.cmd('cd ' .. choice)
      end)
    end
  end)
end

---------------
-- 10. explorer all dirs
---------------

M.explorer = function()
  B.ui_sel(vim.fn.sort(M.all_dirs), 'explorer all dirs', function(choice)
    if choice then
      B.system_run('start', "%s && explorer %s", B.system_cd(choice), choice)
    end
  end)
end

return M
