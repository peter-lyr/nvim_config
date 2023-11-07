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
    B.system_run(runway, [[cd %s && mingw32-make & pause]], build_dirs[1])
  elseif #build_dirs > 1 then
    B.ui_sel(build_dirs, 'make in build dir', function(build_dir)
      B.system_run(runway, [[cd %s && mingw32-make & pause]], build_dir)
    end)
  else
    B.notify_info 'no build dirs'
  end
end

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
    M.run_do(build_dirs[1], runway)
  elseif #build_dirs > 1 then
    B.ui_sel(build_dirs, 'make in build dir', function(build_dir)
      M.run_do(build_dir, runway)
    end)
  else
    B.notify_info 'no build dirs'
  end
end

return M
