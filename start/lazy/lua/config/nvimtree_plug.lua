local M = {}

package.loaded['config.nvimtree_plug'] = nil

local function rep(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '/', '\\')
  return content
end

local get_ftarget = function(node)
  return rep(node.absolute_path)
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

M.start_file = function(node)
  vim.cmd('silent !start ' .. get_ftarget(node))
end

M.start_dir = function(node)
  vim.cmd('silent !start ' .. get_dtarget(node))
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
  vim.fn.system('QuickLook.exe ' .. node.absolute_path)
end

return M
