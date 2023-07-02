local cbp_files = {}
local project = ''

local Path = require("plenary.path")
local Scan = require("plenary.scandir")

local sdkcbp_dir = require("plenary.path"):new(vim.g.boot_lua):parent():parent():parent():parent():joinpath('opt', 'work', 'autoload', 'sdkcbp')

vim.g.cmake_app_py = sdkcbp_dir:joinpath('cmake_app.py').filename
vim.g.cmake_others_py = sdkcbp_dir:joinpath('cmake_others.py').filename

local rep = function(path)
  path, _ = string.gsub(path, '\\', '/')
  return path
end

local traverse_folder = function(abspath)
  local path = Path:new(abspath)
  local entries = Scan.scan_dir(path.filename, { hidden = false, depth = 3, add_dirs = false })
  for _, entry in ipairs(entries) do
    local entry_path_name = rep(entry)
    if string.match(entry_path_name, '%.([^%.]+)$') == 'cbp' then
      if vim.tbl_contains(cbp_files, entry_path_name) == false then
        table.insert(cbp_files, entry_path_name)
      end
    end
  end
end

local find_cbp = function(dtargets)
  local fname = vim.api.nvim_buf_get_name(0)
  local path = Path:new(fname)
  if not path:exists() then
    return
  end
  if path:is_file() then
    local dname
    if string.match(fname, '%.([^%.]+)$') == 'cbp' then
      fname = rep(fname)
      table.insert(cbp_files, fname)
      return
    else
      dname = path:parent()
    end
    dname = path
    local cnt = 100000
    while 1 do
      for _, dtarget in ipairs(dtargets) do
        local dpath = dname:joinpath(dtarget)
        if dpath:is_dir() then
          traverse_folder(dpath['filename'])
          break
        else
          local fpath = dname:joinpath(dtarget .. '.cbp')
          if fpath:exists() then
            table.insert(cbp_files, rep(fpath.filename))
            break
          end
        end
      end
      if project == rep(dname.filename) then
        break
      end
      dname = dname:parent()
      if #dname.filename > cnt then
        break
      end
      cnt = #dname.filename
    end
  end
end

local split_string = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "(.-)" .. sep) do
    table.insert(t, str)
  end
  return t
end

local cmake_app_do = function(app_cbp)
  print(app_cbp)
  local ll = split_string(app_cbp, 'app/projects')
  local mm = table.concat(ll, 'app/projects')
  local nn = string.match(app_cbp, 'app/projects/(.-)/')
  if not nn then
    nn = 'projects'
  end
  if string.match(app_cbp, 'app/projects') then
    -- vim.cmd(string.format([[silent !start cmd /c "chcp 65001 & python "%s" "%s" %s & timeout /t 3"]], vim.g.cmake_app_py, mm, nn))
    vim.cmd(string.format([[silent !start cmd /c "chcp 65001 & python "%s" "%s" %s & pause"]], vim.g.cmake_app_py, mm, nn))
    -- vim.cmd(string.format([[silent AsyncRun python "%s" "%s" %s]], vim.g.cmake_app_py, mm, nn))
  end
end

local cmake_app = function()
  local app_cbp
  if #cbp_files == 1 then
    app_cbp = cbp_files[1]
    cmake_app_do(app_cbp)
  else
    vim.ui.select(cbp_files, { prompt = 'select one of them' }, function(_, idx)
      -- print(choice, idx)
      app_cbp = cbp_files[idx]
      cmake_app_do(app_cbp)
    end)
  end
end

local cmake_others = function()
  local other_cbp = cbp_files[1]
  print(other_cbp)
  local path = Path:new(other_cbp)
  vim.cmd(string.format([[silent !start cmd /c "chcp 65001 & python "%s" "%s" & timeout /t 3"]], vim.g.cmake_others_py, path:parent().filename))
end

local M = {}

M.build = function()
  local fname = vim.api.nvim_buf_get_name(0)
  project = vim.fn['projectroot#get'](fname)
  project = rep(project)
  if #project == 0 then
    print('no projectroot:', fname)
  end
  cbp_files = {}
  find_cbp({ 'app' })
  if #cbp_files == 0 then
    find_cbp({ 'boot', 'masklib', 'spiloader' })
    if #cbp_files == 1 then
      cmake_others()
    end
  else
    cmake_app()
  end
end

return M
