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
    B.notify_info 'no build dirs'
  end
end

------------------------

M.delete_all = 'delete all above'

function M.clean()
  local build_dirs = B.get_dirs_equal 'build'
  if #build_dirs == 1 then
    if #B.scan_files(build_dirs[1]) > 0 then
      B.system_run('start', [[del /s /q %s & rd /s /q %s]], build_dirs[1], build_dirs[1])
      B.notify_info { 'deleting build dir', build_dirs[1], }
    else
      B.notify_info { 'build dir is empty', build_dirs[1], }
    end
  elseif #build_dirs > 1 then
    table.insert(build_dirs, 1, M.delete_all)
    B.ui_sel(build_dirs, 'make in build dir', function(build_dir)
      if build_dir == M.delete_all then
        for _, dir in ipairs(build_dirs) do
          B.system_run('start', [[del /s /q %s & rd /s /q %s]], dir, dir)
        end
        table.insert(build_dirs, 1, 'deleting build dir')
        B.notify_info(build_dirs)
      else
        if #B.scan_files(build_dir) > 0 then
          B.system_run('start', [[del /s /q %s & rd /s /q %s]], build_dir, build_dir)
          B.notify_info { 'deleting build dir', build_dir, }
        else
          B.notify_info { 'build dir is empty', build_dir, }
        end
      end
    end)
  else
    B.notify_info 'no build dirs'
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

function M.run_do(build_dir, runway)
  if not runway then
    runway = 'asyncrun'
  end
  local exes = M.get_exes(build_dir)
  if #exes == 1 then
    B.system_run(runway, [[cd %s && %s & pause]], build_dir, exes[1])
  elseif #exes > 1 then
    B.ui_sel(exes, 'run which exe', function(exe)
      B.system_run(runway, [[cd %s && %s & pause]], build_dir, exe)
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
    B.notify_info 'no build dirs'
  end
end

-----------

function M.gcc()
  local cur_file = vim.api.nvim_buf_get_name(0)
  local fname = B.get_only_name(cur_file)
  local exe = fname .. '.exe'
  B.system_run('start',
    [[%s && gcc %s -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o %s & %s & pause]],
    B.system_cd(cur_file), fname, exe, exe)
end

return M
