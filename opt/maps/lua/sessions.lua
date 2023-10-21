local M = {}
local B = require 'my_base'
M.source = debug.getinfo(1)['source']
package.loaded[B.get_loaded(M.source)] = nil
--------------------------------------------

M.sessions_dir_path = B.get_std_data_dir_path 'sessions'
M.sessions_txt_path = B.get_create_file_path(M.sessions_dir_path, 'sessions.txt')

function M.sel()
  local files = B.fetch_existed_files(M.sessions_txt_path:readlines())
  B.ui_sel(files, 'sessions sel open', function(choice, idx)
    if choice then
      vim.cmd('edit ' .. choice)
    end
  end)
end

function M.load()
  for _, file in ipairs(B.fetch_existed_files(M.sessions_txt_path:readlines())) do
    vim.cmd('edit ' .. file)
  end
end

function M.save()
  local files = get_loaded_valid_bufs
  if #files > 0 then
    M.sessions_txt_path:write(vim.fn.join(files, '\n'), 'w')
  end
end

B.aucmd(M.source, 'VimLeavePre', { 'VimLeavePre', }, { callback = M.save, })

return M
