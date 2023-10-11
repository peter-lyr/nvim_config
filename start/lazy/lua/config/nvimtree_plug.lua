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

M.show_cwd_root_toggle = function()
  if M.show_cwd_root then
    M.show_cwd_root = nil
  else
    M.show_cwd_root = 1
  end
  vim.cmd 'wincmd p'
  vim.cmd 'wincmd p'
end

return M
