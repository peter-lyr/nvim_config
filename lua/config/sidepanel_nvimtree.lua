local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

vim.cmd [[
  hi NvimTreeOpenedFile guibg=#238789
  hi NvimTreeModifiedFile guibg=#87237f
  hi NvimTreeSpecialFile guifg=brown gui=bold,underline
]]

function M.on_attach(bufnr)
  require 'config.sidepanel_nvimtree_map'.basic_map(bufnr)
  require 'config.sidepanel_nvimtree_map'.sel_map(bufnr)
end

M.default_opts = {
  on_attach = M.on_attach,
  update_focused_file = {
    -- enable = true,
    update_root = false,
  },
  git = {
    enable = true,
  },
  view = {
    width = 30,
    number = true,
    relativenumber = true,
  },
  sync_root_with_cwd = true,
  reload_on_bufenter = true,
  respect_buf_cwd = true,
  filesystem_watchers = {
    enable = true,
    debounce_delay = 50,
    ignore_dirs = { '*.git*', },
  },
  filters = {
    -- dotfiles = false,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },
  modified = {
    enable = true,
    show_on_dirs = false,
    show_on_open_dirs = false,
  },
  renderer = {
    highlight_git = true,
    highlight_opened_files = 'name',
    highlight_modified = 'name',
    special_files = { 'README.md', 'readme.md', },
    indent_markers = {
      enable = true,
    },
  },
  actions = {
    open_file = {
      window_picker = {
        chars = 'ASDFQWERJKLHNMYUIOPZXCVGTB1234789056',
        exclude = {
          filetype = { 'notify', 'packer', 'qf', 'diff', 'fugitive', 'fugitiveblame', 'minimap', 'aerial', },
          buftype = { 'nofile', 'terminal', 'help', },
        },
      },
    },
  },
}

function M.setup(conf)
  require 'nvim-tree'.setup(vim.tbl_deep_extend('force', M.default_opts, conf or {}))
end

M.setup()

-----------------------

M.nvimtree_opened = nil

function M.findfile()
  M.nvimtree_opened = 1
  vim.cmd 'NvimTreeFindFile'
end

function M.open()
  M.nvimtree_opened = 1
  vim.cmd 'NvimTreeOpen'
end

function M.close()
  M.nvimtree_opened = nil
  vim.cmd 'NvimTreeClose'
end

function M.restart()
  B.source_lua(M.source)
  M.open()
end

function M.findnext()
  M.nvimtree_opened = 1
  vim.cmd 'NvimTreeFindFile'
  vim.cmd 'norm jo'
end

function M.findprev()
  M.nvimtree_opened = 1
  vim.cmd 'NvimTreeFindFile'
  vim.cmd 'norm ko'
end

-------

require 'config.telescope_ui_sel'

function M.cd_opened_projs()
  local func = loadstring('return ' .. M.opened_projs_txt_path:read())
  if func then
    local projs = func()
    B.ui_sel(projs, 'sel dir to change', function(dir)
      if dir then
        pcall(vim.cmd, 'NvimTreeOpen')
        B.cmd('cd %s', dir)
      end
    end)
  end
end

M.depei = vim.fn.expand [[$HOME]] .. '\\DEPEI'

if vim.fn.isdirectory(M.depei) == 0 then
  vim.fn.mkdir(M.depei)
end

M.my_dirs = {
  B.rep_baskslash_lower(M.depei),
  B.rep_baskslash_lower(vim.fn.expand [[$HOME]]),
  B.rep_baskslash_lower(vim.fn.expand [[$TEMP]]),
  B.rep_baskslash_lower(vim.fn.expand [[$LOCALAPPDATA]]),
  B.rep_baskslash_lower(vim.fn.expand [[$VIMRUNTIME]]),
}

for i = 1, 26 do
  local dir = vim.fn.nr2char(64 + i) .. [[:\]]
  dir = B.rep_baskslash_lower(vim.fn.trim(dir, '/'))
  if vim.fn.isdirectory(dir) == 1 and vim.tbl_contains(M.my_dirs, dir) == false then
    M.my_dirs[#M.my_dirs + 1] = dir
  end
end

function M.cd_my_dirs()
  B.ui_sel(M.my_dirs, 'sel dir to change', function(dir)
    if dir then
      pcall(vim.cmd, 'NvimTreeOpen')
      B.cmd('cd %s', dir)
    end
  end)
end

M.git_repos_dir_path = B.get_create_std_data_dir 'git_repos'
M.git_repos_txt_path = B.get_create_file_path(M.git_repos_dir_path, 'git_repos.txt')
M.update_git_repos_py_path = M.source .. '.update_git_repos.py'

function M.get_all_repos()
  local git_repos = {}
  local lines = M.git_repos_txt_path:readlines()
  for _, line in ipairs(lines) do
    local dir_path = require 'plenary.path':new(vim.fn.trim(line))
    if dir_path:exists() == true then
      git_repos[#git_repos + 1] = dir_path.filename
    end
  end
  if #git_repos == 0 then
    M.update_git_repos()
    return {}
  end
  return git_repos
end

function M.cd_git_repos()
  local git_repos = M.get_all_repos()
  B.ui_sel(git_repos, 'sel dir to change', function(choice, _)
    if not choice then
      return
    end
    local dir_path = require 'plenary.path':new(vim.fn.trim(choice))
    if dir_path:exists() == true then
      vim.cmd 'NvimTreeOpen'
      vim.cmd('cd ' .. choice)
    end
  end)
end

function M.update_git_repos()
  B.system_run('start', '%s && python "%s" "%s"',
    B.system_cd(M.git_repos_dir_path), M.update_git_repos_py_path, M.git_repos_txt_path.filename)
end

return M
