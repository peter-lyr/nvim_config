local M = {}
local B = require 'my_base'
M.source = debug.getinfo(1)['source']
package.loaded[B.get_loaded(M.source)] = nil
--------------------------------------------

local get_ftarget = function(node)
  return B.rep_slash_lower(node.absolute_path)
end

local get_dtarget = function(node)
  if node.type == 'directory' then
    return B.rep_slash_lower(node.absolute_path)
  end
  if node.type == 'file' then
    return B.rep_slash_lower(node.parent.absolute_path)
  end
  return nil
end

M.start_file = function(node)
  B.system_run('start', [[explorer "%s"]], get_ftarget(node))
end

M.start_dir = function(node)
  B.system_run('start', [[explorer "%s"]], get_dtarget(node))
end

-- bcomp.lua

M.bcomp1 = function(node)
  require 'bcomp'.diff1(node.absolute_path)
end

M.bcomp2 = function(node)
  require 'bcomp'.diff2(node.absolute_path)
end

M.bcomplast = function()
  require 'bcomp'.diff_last()
end

M.quicklook = function(node)
  B.system_run('start', [[QuickLook "%s"]], node.absolute_path)
end

return M
