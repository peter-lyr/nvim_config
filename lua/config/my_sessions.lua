local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

M.sessions_txt_path = B.get_create_file_path(B.get_create_std_data_dir 'sessions', 'sessions.txt')

require 'config.telescope'
require 'telescope'.load_extension 'ui-select'

M.sel_all = 'open all above'

function M.open_all(projs)
  for _, files in pairs(projs) do
    for _, file in ipairs(files) do
      vim.cmd('edit ' .. file)
    end
  end
end

function M.get_projs()
  return loadstring('return ' .. M.sessions_txt_path:read())()
end

function M.sel()
  local projs = M.get_projs()
  local list = {}
  for proj, files in pairs(projs) do
    local only_names = {}
    for _, only_name in ipairs(files) do
      only_names[#only_names + 1] = B.get_only_name(only_name)
    end
    list[#list + 1] = string.format('%2d files | "%s" | %s', #files, proj, vim.fn.join(only_names, ' '))
  end
  if #list > 0 then
    table.insert(list, 1, M.sel_all)
    B.ui_sel(list, 'sessions sel proj open', function(proj, _)
      if proj == M.sel_all then
        M.open_all(projs)
        return
      end
      proj = string.match(proj, '%d+ files | "(.*)"')
      if proj then
        local files = projs[proj]
        table.insert(files, 1, M.sel_all)
        B.ui_sel(files, 'sessions sel file open', function(file, _)
          if file == M.sel_all then
            for _, f in ipairs(files) do
              vim.cmd('edit ' .. f)
            end
            return
          end
          if file then
            vim.cmd('edit ' .. file)
          end
        end)
      end
    end)
  end
end

function M.save()
  local files = B.get_loaded_valid_bufs()
  if #vim.tbl_keys(files) > 0 then
    M.sessions_txt_path:write(vim.inspect(files), 'w')
  end
end

return M
