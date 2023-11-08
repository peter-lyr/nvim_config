local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

function M.make(runway)
  if not runway then
    runway = 'asyncrun'
  end
  local build_dirs = B.get_dirs_equal 'build'
  if #build_dirs == 1 then
    if #B.scan_files(build_dirs[1]) > 0 then
      B.system_run(runway, [[cd %s && mingw32-make & pause]], build_dirs[1])
      B.notify_info 'make...'
    else
      B.notify_info 'build dir is empty, cmake...'
      require 'config.my_cmake'.to_cmake()
    end
  elseif #build_dirs > 1 then
    B.ui_sel(build_dirs, 'make in build dir', function(build_dir)
      if #B.scan_files(build_dirs[1]) > 0 then
        B.notify_info 'make...'
        B.system_run(runway, [[cd %s && mingw32-make & pause]], build_dir)
      else
        B.notify_info 'build dir is empty, cmake...'
        require 'config.my_cmake'.to_cmake()
      end
    end)
  else
    B.notify_info 'no build dirs, cmake...'
    require 'config.my_cmake'.to_cmake()
  end
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
    local file = B.rep_baskslash_lower(entry)
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
    [[cd %s && copy /y %s ..\%s && cd .. && strip -s %s & upx -qq --best %s & %s & pause]],
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
  local exe = fname .. '.exe'
  local exe_name = B.get_only_name(exe)
  B.system_run('start',
    [[%s && gcc %s -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o %s & strip -s %s & upx -qq --best %s & %s & pause]],
    B.system_cd(cur_file), fname, exe_name, exe_name, exe_name, exe_name)
end

----------------

-- 环境变量:
--   INCLUDE: mingw64\x86_64-w64-mingw32\include

return M
