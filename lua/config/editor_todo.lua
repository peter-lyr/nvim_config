local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

require 'map.sidepanel_quickfix'

function M.TodoQuickFix(keywords)
  if not keywords then
    vim.cmd 'TodoQuickFix'
  else
    if type(keywords) == 'string' then
      keywords = { keywords, }
    end
    B.cmd('TodoQuickFix keywords=%s', vim.fn.join(keywords, ','))
  end
end

function M.TodoTelescope(keywords)
  if not keywords then
    vim.cmd 'TodoTelescope'
  else
    if type(keywords) == 'string' then
      keywords = { keywords, }
    end
    B.cmd('TodoTelescope keywords=%s', vim.fn.join(keywords, ','))
  end
end

function M.TodoLocList(keywords)
  if not keywords then
    vim.cmd 'TodoLocList'
  else
    if type(keywords) == 'string' then
      keywords = { keywords, }
    end
    B.cmd('TodoLocList keywords=%s', vim.fn.join(keywords, ','))
  end
end

local todo = require 'todo-comments.search'

M.todo_exclude_dirs = {}

function M.get_todo_exclude_dirs_txt_path()
  return B.get_create_file_path(vim.loop.cwd(), '.todo_exclude.txt')
end

function M.load_todo_exclude_dirs_txt()
  M.todo_exclude_dirs_txt_path = M.get_todo_exclude_dirs_txt_path()
  for _, dir in ipairs(M.todo_exclude_dirs_txt_path:readlines()) do
    dir = B.rep_backslash_lower(dir)
    if B.is(dir) and vim.tbl_contains(M.todo_exclude_dirs, dir) == false then
      M.todo_exclude_dirs[#M.todo_exclude_dirs + 1] = dir
    end
  end
  M.todo_exclude_dirs_txt_path:write(vim.fn.join(M.todo_exclude_dirs, '\r\n'), 'w')
end

function M.todo_exclude_this_dir(file)
  if M.todo_exclude_dirs then
    local proj_root = B.rep_backslash_lower(vim.fn['ProjectRootGet'](file))
    local dir_name = B.rep_backslash_lower(vim.fn.fnamemodify(file, ':h'))
    local dir = string.sub(dir_name, #proj_root + 2, #dir_name)
    for _, _dir in ipairs(M.todo_exclude_dirs) do
      if string.match(dir, _dir) then
        return 1
      end
    end
  end
  return nil
end

function M.open_todo_exclude_dirs_txt()
  vim.cmd 'wincmd s'
  B.cmd('e %s', M.get_todo_exclude_dirs_txt_path().filename)
end

todo.load_todo_exclude_dirs_txt = M.load_todo_exclude_dirs_txt
todo.todo_exclude_this_dir = M.todo_exclude_this_dir

return M
