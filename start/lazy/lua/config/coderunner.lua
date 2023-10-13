package.loaded['config.coderunner'] = nil

local M = {}

M.numberofcores = 1

local f = io.popen 'wmic cpu get NumberOfCores'
for dir in string.gmatch(f:read '*a', '([%S ]+)') do
  local NumberOfCores = vim.fn.str2nr(vim.fn.trim(dir))
  if NumberOfCores > 0 then
    M.numberofcores = NumberOfCores
  end
end
f:close()

M.merge_tables = function(...)
  local result = {}
  for _, t in ipairs { ..., } do
    for _, v in ipairs(t) do
      result[#result + 1] = v
    end
  end
  return result
end

local function system_cd(p)
  local s = ''
  if string.sub(p, 2, 2) == ':' then
    s = s .. string.sub(p, 1, 2) .. ' & '
  end
  if require 'plenary.path'.new(p):is_dir() then
    s = s .. 'cd ' .. p
  else
    s = s .. 'cd ' .. require 'plenary.path'.new(p):parent().filename
  end
  return s
end

M.cmd_pre = function(dir, fileNameWithoutExt)
  if dir and fileNameWithoutExt then
    return {
      system_cd(dir),
      'pwd',
      string.format('taskkill /f /im %s.exe', fileNameWithoutExt),
    }
  else
    return {
      'cd $dir',
      'pwd',
      'taskkill /f /im $fileNameWithoutExt.exe',
    }
  end
end

M.cmd_run = function(dir, fileNameWithoutExt)
  if dir and fileNameWithoutExt then
    return {
      string.format('%s\\%s.exe', dir, fileNameWithoutExt),
    }
  else
    return {
      '$dir\\$fileNameWithoutExt.exe',
    }
  end
end

M.cmd_compress = function(dir, fileNameWithoutExt)
  if dir and fileNameWithoutExt then
    return {
      string.format('strip -s %s\\%s.exe', dir, fileNameWithoutExt),
      string.format('upx -qq --best %s\\%s.exe', dir, fileNameWithoutExt),
    }
  else
    return {
      'strip -s $dir\\$fileNameWithoutExt.exe',
      'upx -qq --best $dir\\$fileNameWithoutExt.exe',
    }
  end
end

M.cmd_build = function(dir, projname, curname)
  if dir and projname and curname then
    local cmd = {}
    cmd[#cmd + 1] = system_cd(dir)
    if M.rebuild_en then
      cmd[#cmd + 1] = 'del /s /q .cache'
      cmd[#cmd + 1] = 'rd  /s /q .cache'
      cmd[#cmd + 1] = 'del /s /q build'
      cmd[#cmd + 1] = 'rd  /s /q build'
    end
    cmd[#cmd + 1] = 'cmake -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1'
    cmd[#cmd + 1] = 'cd build'
    cmd[#cmd + 1] = string.format('mingw32-make -j%d', M.numberofcores * 2)
    cmd[#cmd + 1] = string.format('copy /y %s.exe ..\\%s.exe', projname, curname)
    cmd[#cmd + 1] = 'copy /y compile_commands.json ..\\compile_commands.json'
    cmd[#cmd + 1] = 'cd ..'
    return cmd
  else
    return {
      'gcc $fileName -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o $fileNameWithoutExt',
    }
  end
end

M.get_cmd = function(...)
  local cmd = vim.fn.join(M.merge_tables(...), ' & echo ========== & ')
  return cmd
end

M.get_cmd_run = function()
  return M.get_cmd(
    M.cmd_run()
  )
end

M.get_cmd_build = function()
  return M.get_cmd(
    M.cmd_pre(),
    M.cmd_compress(),
    M.cmd_build()
  )
end

M.get_cmd_build_run = function()
  return M.get_cmd(
    M.cmd_pre(),
    M.cmd_compress(),
    M.cmd_build(),
    M.cmd_run()
  )
end

M.get_cmd_run_proj = function()
  return M.get_cmd(
    M.cmd_run(M.dir, M.curname)
  )
end

M.get_cmd_build_proj = function()
  return M.get_cmd(
    M.cmd_pre(M.dir, M.curname),
    M.cmd_build(M.dir, M.projname, M.curname),
    M.cmd_compress(M.dir, M.curname)
  )
end

M.get_cmd_build_run_proj = function()
  return M.get_cmd(
    M.cmd_pre(M.dir, M.curname),
    M.cmd_build(M.dir, M.projname, M.curname),
    M.cmd_compress(M.dir, M.curname),
    M.cmd_run(M.dir, M.curname)
  )
end

M.setup_ft = function(ft)
  require 'code_runner'.setup {
    filetype = ft,
  }
end

M.setup_proj = function(cmd)
  require 'code_runner'.setup {
    filetype = nil,
    project = {
      [M.dir] = {
        name = 'C Proj',
        description = 'Project with cmakelists',
        command = cmd,
      },
    },
  }
end

require 'code_runner'.setup {
  startinsert = false,
  filetype = {
    python = 'python -u',
    c = M.get_cmd_build(),
  },
}

M.done = function()
  local winid = vim.fn.win_getid()
  vim.cmd 'RunCode'
  if winid ~= vim.fn.win_getid() then
    vim.fn.timer_start(100, function()
      vim.cmd 'norm Gzz'
      vim.api.nvim_win_set_height(0, 15)
      local opt = { buffer = vim.fn.bufnr(), nowait = true, silent = true, }
      vim.keymap.set('n', 'q', '<cmd>close<cr>', opt)
      vim.keymap.set('n', '<esc>', '<cmd>close<cr>', opt)
    end)
  end
end

M.run = function()
  M.setup_ft { c = M.get_cmd_run(), }
  M.done()
end

M.build = function()
  M.setup_ft { c = M.get_cmd_build(), }
  M.done()
end

M.rebuild = function()
  M.setup_ft { c = M.get_cmd_build(), }
  M.done()
end

M.build_run = function()
  M.setup_ft { c = M.get_cmd_build_run(), }
  M.done()
end

M.rebuild_run = function()
  M.setup_ft { c = M.get_cmd_build_run(), }
  M.done()
end

-- 0: build and run
-- 1: build
-- 2: run
M.run_mode = 0
M.dir_bak = ''
M.curname_bak = ''

M.is_c_proj = function(run_mode)
  local c_proj = nil
  if vim.bo.ft == 'c' or vim.bo.ft == 'cpp' or vim.fn.expand '%:p:t' == 'CMakeLists.txt' then
    local parent_p = require 'plenary.path':new(vim.api.nvim_buf_get_name(0)):parent()
    local cmakelists = parent_p:joinpath 'CMakeLists.txt'
    M.dir = parent_p.filename
    if cmakelists:exists() then
      local content = cmakelists:read()
      M.projname = content:match 'set%(PROJECT_NAME ([%S]+)%)'
      M.curname = content:match '${PROJECT_SOURCE_DIR}/([%w%p]+).c'
      if M.projname == vim.fn.expand '%:p:t:r' or M.projname == 'common' then
        c_proj = 1
        if M.dir_bak ~= M.dir or M.curname_bak ~= M.curname or M.run_mode ~= run_mode then
          M.dir_bak = M.dir
          M.curname_bak = M.curname
          M.run_mode = run_mode
        end
      end
    end
    if not c_proj then
      M.run_mode = -1
    end
  end
  return c_proj
end

M.run_proj = function()
  if M.is_c_proj(2) then
    M.setup_proj(M.get_cmd_run_proj())
    M.done()
  end
end

M.build_proj = function()
  if M.is_c_proj(1) then
    M.rebuild_en = nil
    M.setup_proj(M.get_cmd_build_proj())
    M.done()
  end
end

M.rebuild_proj = function()
  if M.is_c_proj(1) then
    M.rebuild_en = 1
    M.setup_proj(M.get_cmd_build_proj())
    M.done()
  end
end

M.build_run_proj = function()
  if M.is_c_proj(0) then
    M.rebuild_en = nil
    M.setup_proj(M.get_cmd_build_run_proj())
    M.done()
  end
end

M.rebuild_run_proj = function()
  if M.is_c_proj(0) then
    M.build_run_proj()
    M.rebuild_en = 1
    M.setup_proj(M.get_cmd_build_run_proj())
    M.done()
  end
end

return M
