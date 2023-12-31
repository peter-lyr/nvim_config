local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

M.cores = 1

local f = io.popen 'wmic cpu get NumberOfCores'
if f then
  for dir in string.gmatch(f:read '*a', '([%S ]+)') do
    local NumberOfCores = vim.fn.str2nr(vim.fn.trim(dir))
    if NumberOfCores > 0 then
      M.cores = NumberOfCores
    end
  end
  f:close()
end

M.remake_en = nil
M.runnow_en = nil

function M.cmake_exe(dir)
  local CMakeLists = require 'plenary.path':new(dir):joinpath('CMakeLists.txt').filename
  local c = io.open(CMakeLists)
  if c then
    local res = c:read '*a'
    local exe = string.match(res, 'set%(PROJECT_NAME ([^%)]+)%)')
    if exe then
      return exe
    end
    c:close()
  end
  return nil
end

function M.make_do(runway, build_dir)
  if #B.scan_files(build_dir) > 0 then
    local pause = ''
    if runway == 'start' then
      pause = '& pause'
    end
    local run = ''
    if M.runnow_en then
      local exe_name = M.cmake_exe(vim.fn.fnamemodify(build_dir, ':h'))
      if exe_name then
        exe_name = exe_name .. '.exe'
        run = '& ' .. string.format(
          [[cd %s && copy /y %s ..\%s && cd .. && strip -s %s & upx -qq --best %s & echo ==============RUN============== & %s]],
          build_dir, exe_name, exe_name, exe_name, exe_name, exe_name)
      end
    end
    if M.remake_en then
      B.notify_info 'remake...'
      B.system_run(runway, [[cd %s && mingw32-make -B -j%d %s %s]], build_dir, M.cores, run, pause)
    else
      B.notify_info 'make...'
      B.system_run(runway, [[cd %s && mingw32-make -j%d %s %s]], build_dir, M.cores, run, pause)
    end
  else
    B.notify_info 'build dir is empty, cmake...'
    require 'config.my_cmake'.cmake()
  end
  M.remake_en = nil
  M.runnow_en = nil
end

function M.make(runway)
  if #vim.call 'ProjectRootGet' == 0 then
    B.notify_info 'not in a git repo'
    return
  end
  if not runway then
    runway = 'asyncrun'
  end
  local build_dirs = B.get_dirs_equal 'build'
  if #build_dirs == 1 then
    M.make_do(runway, build_dirs[1])
  elseif #build_dirs > 1 then
    B.ui_sel(build_dirs, 'make in build dir', function(build_dir)
      M.make_do(runway, build_dir)
    end)
  else
    B.notify_info 'no build dirs, cmake...'
    require 'config.my_cmake'.cmake()
  end
end

function M.remake(runway)
  M.remake_en = 1
  M.make(runway)
end

function M.make_run(runway)
  M.runnow_en = 1
  M.make(runway)
end

function M.remake_run(runway)
  M.remake_en = 1
  M.runnow_en = 1
  M.make(runway)
end

------------------------

M.delete_all = 'delete all above'
M.deleting = 'deleting build dir'

function M.clean_do(build_dir)
  if #B.scan_files(build_dir) > 0 then
    B.del_dir(build_dir)
    B.notify_info { M.deleting, build_dir, }
  else
    B.notify_info { 'build dir is empty', build_dir, }
  end
end

function M.clean()
  local build_dirs = B.get_dirs_equal 'build'
  if #build_dirs == 1 then
    M.clean_do(build_dirs[1])
  elseif #build_dirs > 1 then
    table.insert(build_dirs, 1, M.delete_all)
    B.ui_sel(build_dirs, 'make in build dir', function(build_dir)
      if build_dir == M.delete_all then
        for _, dir in ipairs(build_dirs) do
          B.del_dir(dir)
        end
        table.insert(build_dirs, 1, M.deleting)
        B.notify_info(build_dirs)
      else
        M.clean_do(build_dir)
      end
    end)
  else
    B.notify_info 'no build dirs, clean stopping...'
  end
end

--------------------

function M.get_exes(dir)
  local exes = {}
  local entries = require 'plenary.scandir'.scan_dir(dir, { hidden = false, depth = 32, add_dirs = false, })
  for _, entry in ipairs(entries) do
    local file = B.rep_backslash_lower(entry)
    if string.match(file, 'build/[^/]+%.([^%.]+)$') == 'exe' then
      if vim.tbl_contains(exes, file) == false then
        exes[#exes + 1] = file
      end
    end
  end
  return exes
end

function M.copy_exe_outside_build_dir_and_run(runway, build_dir, exe_name)
  B.system_run(runway,
    [[cd %s && copy /y %s ..\%s && cd .. && strip -s %s & upx -qq --best %s & echo ==============RUN============== & %s & pause]],
    build_dir, exe_name, exe_name, exe_name, exe_name, exe_name
  )
end

function M.run_do(build_dir, runway)
  if not runway then
    runway = 'asyncrun'
  end
  local exes = M.get_exes(build_dir)
  if #exes == 1 then
    M.copy_exe_outside_build_dir_and_run(runway, build_dir, B.get_only_name(exes[1]))
  elseif #exes > 1 then
    B.ui_sel(exes, 'run which exe', function(exe)
      M.copy_exe_outside_build_dir_and_run(runway, build_dir, B.get_only_name(exe))
    end)
  end
end

function M.run(runway)
  if not runway then
    runway = 'asyncrun'
  end
  local build_dirs = B.get_dirs_equal 'build'
  if #build_dirs == 1 then
    B.notify_info 'run...'
    M.run_do(build_dirs[1], runway)
  elseif #build_dirs > 1 then
    B.ui_sel(build_dirs, 'make in build dir', function(build_dir)
      B.notify_info 'run...'
      M.run_do(build_dir, runway)
    end)
  else
    B.notify_info 'no build dirs, run stopping...'
  end
end

-----------

function M.gcc()
  local cur_file = vim.api.nvim_buf_get_name(0)
  local fname = B.get_only_name(cur_file)
  local exe = string.sub(fname, 1, #fname - 2) .. '.exe'
  local exe_name = B.get_only_name(exe)
  B.system_run('start',
    [[%s && gcc %s -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O2 -o %s & strip -s %s & upx -qq --best %s & %s & pause]],
    B.system_cd(cur_file), fname, exe_name, exe_name, exe_name, exe_name)
end

----------------

-- 环境变量:
--   INCLUDE: mingw64\x86_64-w64-mingw32\include

return M
