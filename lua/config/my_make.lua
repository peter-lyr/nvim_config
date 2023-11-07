local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

function M.make()
  local build_dirs = B.get_dirs_equal 'build'
  if #build_dirs == 1 then
    B.system_run('start', [[cd %s && mingw32-make]], build_dirs[1])
  elseif #build_dirs > 1 then
    B.ui_sel(build_dirs, 'make in build dir', function(build_dir)
      B.system_run('start', [[cd %s && mingw32-make]], build_dir)
    end)
  else
    B.notify_info 'no build dirs'
  end
end

return M
