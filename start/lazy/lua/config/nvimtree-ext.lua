local change_dir = require "nvim-tree.actions.root.change-dir"
local utils = require "nvim-tree.utils"
local _config = require 'nvim-tree'.config
local core = require "nvim-tree.core"

local M = {}

M.change_root = function(path, bufnr)
  -- skip if current file is in ignore_list
  if type(bufnr) == "number" then
    local ft = vim.api.nvim_buf_get_option(bufnr, "filetype") or ""
    for _, value in pairs(_config.update_focused_file.ignore_list) do
      if utils.str_find(path, value) or utils.str_find(ft, value) then
        return
      end
    end
  end
  -- don't find inexistent
  if vim.fn.filereadable(path) == 0 then
    return
  end
  local cwd = core.get_cwd()
  local vim_cwd = vim.fn.getcwd()
  -- test if in vim_cwd
  if utils.path_relative(path, vim_cwd) ~= path then
    if vim_cwd ~= cwd then
      change_dir.fn(vim_cwd)
    end
    return
  end
  -- test if in cwd
  if utils.path_relative(path, cwd) ~= path then
    return
  end
  -- otherwise test M.init_root
  if _config.prefer_startup_root and utils.path_relative(path, M.init_root) ~= path then
    change_dir.fn(M.init_root)
    return
  end
  -- otherwise root_dirs
  for _, dir in pairs(_config.root_dirs) do
    dir = vim.fn.fnamemodify(dir, ":p")
    if utils.path_relative(path, dir) ~= path then
      change_dir.fn(dir)
      return
    end
  end
  -- finally fall back to the folder containing the file
  -- change_dir.fn(vim.fn.fnamemodify(path, ":p:h"))
  change_dir.fn(vim.fn['ProjectRootGet'](path))
end

return M
