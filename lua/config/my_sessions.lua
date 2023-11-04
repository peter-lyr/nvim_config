local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

M.sessions_dir_path = B.get_create_std_data_dir 'sessions'
M.sessions_txt_path = B.get_create_file_path(M.sessions_dir_path, 'sessions.txt')

require 'config.telescope_ui_sel'

M.sel_all = 'open all above'

function M.open_all(projs)
  for _, files in pairs(projs) do
    for _, file in ipairs(files) do
      vim.cmd('edit ' .. file)
    end
  end
end

function M.get_projs(fname)
  if not fname then
    return loadstring('return ' .. M.sessions_txt_path:read())()
  end
  return loadstring('return ' .. B.get_create_file_path(M.sessions_dir_path, fname):read())()
end

function M.sel(fname)
  local projs = M.get_projs(fname)
  local list = {}
  for proj, files in pairs(projs) do
    local only_names = {}
    for _, only_name in ipairs(files) do
      only_names[#only_names + 1] = B.get_only_name(only_name)
    end
    list[#list + 1] = string.format('%2d files   "%s"   %s', #files, proj, vim.fn.join(only_names, ' '))
  end
  if #list > 0 then
    table.insert(list, 1, M.sel_all)
    B.ui_sel(list, 'sessions sel proj open', function(proj, _)
      if proj == M.sel_all then
        M.open_all(projs)
        return
      end
      proj = string.match(proj, '%d+ files   "(.*)"')
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
  local files, cnt = B.get_loaded_valid_bufs()
  if #vim.tbl_keys(files) > 0 then
    M.sessions_txt_path:write(vim.inspect(files), 'w')
    local file = string.format(M.format, os.time(), #vim.tbl_keys(files), cnt)
    local last_sessions_txt_path = B.get_create_file_path(M.sessions_dir_path, file)
    last_sessions_txt_path:write(vim.inspect(files), 'w')
  end
end

M.format = 'sessions_%d_%dprojs_%dfiles.txt'
M.pattern = 'sessions_(%d+)_(%d+)projs_(%d+)files%.txt'

function M.sel_recent()
  local files = B.scan_files(M.sessions_dir_path, M.pattern)
  local new_files = {}
  table.sort(files)
  for i = #files, 1, -1 do
    local file = files[i]
    for timestamp, projs_cnt, files_cnt in string.gmatch(file, M.pattern) do
      new_files[#new_files + 1] = string.format('%14s  %d projs  %d files', B.time_diff(tonumber(timestamp, 10)), projs_cnt, files_cnt)
    end
  end
  B.ui_sel(new_files, 'which sessions to open', function(_, idx)
    M.sel(files[#files - idx + 1])
  end)
end

return M

