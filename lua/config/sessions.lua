local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

M.sessions_txt_path = B.get_create_file_path(B.get_create_std_data_dir 'sessions', 'sessions.txt')

require 'telescope'.load_extension 'ui-select'

function M.sel()
  local lines = M.sessions_txt_path:readlines()
  local files = B.fetch_existed_files(lines)
  B.ui_sel(files, 'sessions sel open', function(file, _)
    if file then
      vim.cmd('edit ' .. file)
    end
  end)
end

function M.load()
  local lines = M.sessions_txt_path:readlines()
  local files = B.fetch_existed_files(lines)
  for _, file in ipairs(files) do
    vim.cmd('edit ' .. file)
  end
end

function M.save()
  local files = B.get_loaded_valid_bufs()
  if #files > 0 then
    M.sessions_txt_path:write(vim.fn.join(files, '\n'), 'w')
  end
end

return M
