package.loaded['config.coderunner'] = nil

local M = {}

M.numberofcores = 1

local f = io.popen "wmic cpu get NumberOfCores"
for dir in string.gmatch(f:read "*a", "([%S ]+)") do
  local NumberOfCores = vim.fn.str2nr(vim.fn.trim(dir))
  if NumberOfCores > 0 then
    M.numberofcores = NumberOfCores
  end
end
f:close()

local path = require "plenary.path"

local function systemcd(p)
  local s = ''
  if string.sub(p, 2, 2) == ':' then
    s = s .. string.sub(p, 1, 2) .. ' && '
  end
  if require 'plenary.path'.new(p):is_dir() then
    s = s .. 'cd ' .. p
  else
    s = s .. 'cd ' .. require 'plenary.path'.new(p):parent().filename
  end
  return s
end

M.c0 = {
  'cd $dir &&',
  'pwd &&',
  'echo ============================================================ &&',
  'taskkill /f /im $fileNameWithoutExt.exe &',
  'echo ============================================================ &&',
  'gcc $fileName -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o $fileNameWithoutExt &&',
  'echo ============================================================ &&',
  'strip -s $dir\\$fileNameWithoutExt.exe &',
  'echo ============================================================ &&',
  'upx -qq --best $dir\\$fileNameWithoutExt.exe &',
  'echo ============================================================ &&',
  '$dir\\$fileNameWithoutExt.exe',
}

M.c1 = {
  'cd $dir &&',
  'pwd &&',
  'echo ============================================================ &&',
  'taskkill /f /im $fileNameWithoutExt.exe &',
  'echo ============================================================ &&',
  'gcc $fileName -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o $fileNameWithoutExt &&',
  'echo ============================================================ &&',
  'strip -s $dir\\$fileNameWithoutExt.exe &',
  'echo ============================================================ &&',
  'upx -qq --best $dir\\$fileNameWithoutExt.exe &',
  'echo ============================================================ &&',
  'echo build done',
}

M.c2 = {
  'cd $dir &&',
  'pwd &&',
  'echo ============================================================ &&',
  '$fileNameWithoutExt.exe &&',
  'echo ============================================================ &&',
  'echo run last done',
}

M.rebuild_en = nil

M.cp0 = function(dir, projname, curname)
  return table.concat({
    M.rebuild_en and
    string.format('%s & del /s /q .cache & rd /s /q .cache & del /s /q build & rd /s /q build & cmake -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 & cd build', systemcd(dir))
    or string.format('%s & cmake -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 & cd build', systemcd(dir)),
    'echo ============================================================',
    'pwd',
    'echo ============================================================',
    string.format('taskkill /f /im %s.exe & mingw32-make -j%d', curname, M.numberofcores * 2),
    -- string.format('taskkill /f /im %s.exe & mingw32-make', curname),
    'echo ============================================================',
    string.format('strip -s %s.exe & cd .', projname),
    'echo ============================================================',
    string.format('upx -qq --best %s.exe & cd .', projname),
    'echo ============================================================',
    string.format('copy /y %s.exe ..\\%s.exe', projname, curname),
    'echo ============================================================',
    'copy /y compile_commands.json ..\\compile_commands.json',
    'echo ============================================================',
    'cd ..',
    'pwd',
    'echo ============================================================',
    string.format('echo %s.exe', curname),
    'echo ============================================================',
    string.format('%s.exe', curname),
  }, ' && ')
end

M.cp1 = function(dir, projname, curname)
  return table.concat({
    M.rebuild_en and
    string.format('%s & del /s /q .cache & rd /s /q .cache & del /s /q build & rd /s /q build & cmake -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 & cd build', systemcd(dir))
    or string.format('%s & cmake -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 & cd build', systemcd(dir)),
    'echo ============================================================',
    'pwd',
    'echo ============================================================',
    string.format('taskkill /f /im %s.exe & mingw32-make -j%d', curname, M.numberofcores * 2),
    -- string.format('taskkill /f /im %s.exe & mingw32-make', curname),
    'echo ============================================================',
    string.format('strip -s %s.exe & cd .', projname),
    'echo ============================================================',
    string.format('upx -qq --best %s.exe & cd .', projname),
    'echo ============================================================',
    string.format('copy /y %s.exe ..\\%s.exe', projname, curname),
    'echo ============================================================',
    'copy /y compile_commands.json ..\\compile_commands.json',
    'echo ============================================================',
    string.format('echo %s.exe', curname),
    'echo ============================================================',
    'echo build done',
  }, ' && ')
end

M.cp2 = function(dir, curname)
  return table.concat({
    systemcd(dir),
    'pwd',
    'echo ============================================================',
    string.format('echo %s.exe', curname),
    'echo ============================================================',
    string.format('%s.exe', curname),
    'echo ============================================================',
    'echo run last done',
  }, ' && ')
end

require 'code_runner'.setup {
  -- mode = 'float',
  startinsert = true,
  filetype = {
    python = 'python -u',
    c = M.c0,
  },
}

-- 0: build and run
-- 1: build
-- 2: run
M.c_level = 0

M.c_projdir = ''
M.mainfile = ''

M.runbuild = function(rebuild_en)
  M.rebuild_en = rebuild_en
  pcall(vim.cmd, 'ProjectRootCD')
  local project = string.gsub(vim.fn.tolower(vim.call 'ProjectRootGet'), '\\', '/')
  if #project ~= 0 then
    local workspaces = require 'cbp2make'.get_workspaces(project)
    if #workspaces > 0 then
      require 'cbp2make'.build(workspaces)
      return
    end
  end
  local cmake_ok = nil
  if vim.bo.ft == 'c' or vim.bo.ft == 'cpp' or vim.fn.expand '%:p:t' == 'CMakeLists.txt' then
    local dir = path:new(vim.api.nvim_buf_get_name(0)):parent()
    local cmakelists = dir:joinpath 'CMakeLists.txt'
    if cmakelists:exists() then
      local content = cmakelists:read()
      local projname = content:match 'set%(PROJECT_NAME ([%S]+)%)'
      local mainfile = content:match '${PROJECT_SOURCE_DIR}/([%w%p]+).c'
      local curname = vim.fn.expand '%:p:t:r'
      if projname == curname or projname == 'common' then
        cmake_ok = 1
        if dir.filename ~= M.c_projdir or M.c_level ~= 10 or M.mainfile ~= mainfile then
          M.c_projdir = dir.filename
          M.c_level = 10
          M.mainfile = mainfile
          require 'code_runner'.setup {
            filetype = nil,
            project = {
              [dir.filename] = {
                name = "C Proj",
                description = "Project with cmakelists",
                command = M.cp0(dir.filename, projname, mainfile),
              },
            },
          }
        end
      end
    end
    if not cmake_ok then
      if M.c_level ~= 0 then
        M.c_level = 0
        require 'code_runner'.setup {
          filetype = {
            c = M.c0,
          },
          project = nil,
        }
      end
    end
  end
  vim.cmd 'RunCode'
end

M.build = function(rebuild_en)
  M.rebuild_en = rebuild_en
  pcall(vim.cmd, 'ProjectRootCD')
  local project = string.gsub(vim.fn.tolower(vim.call 'ProjectRootGet'), '\\', '/')
  if #project ~= 0 then
    local workspaces = require 'cbp2make'.get_workspaces(project)
    if #workspaces > 0 then
      require 'cbp2make'.build(workspaces)
      return
    end
  end
  local cmake_ok = nil
  if vim.bo.ft == 'c' or vim.bo.ft == 'cpp' or vim.fn.expand '%:p:t' == 'CMakeLists.txt' then
    local dir = path:new(vim.api.nvim_buf_get_name(0)):parent()
    local cmakelists = dir:joinpath 'CMakeLists.txt'
    if cmakelists:exists() then
      local content = cmakelists:read()
      local projname = content:match 'set%(PROJECT_NAME ([%S]+)%)'
      local mainfile = content:match '${PROJECT_SOURCE_DIR}/([%w%p]+).c'
      local curname = vim.fn.expand '%:p:t:r'
      if projname == curname or projname == 'common' then
        cmake_ok = 1
        if dir.filename ~= M.c_projdir or M.c_level ~= 11 or M.mainfile ~= mainfile then
          M.c_projdir = dir.filename
          M.c_level = 11
          M.mainfile = mainfile
          require 'code_runner'.setup {
            project = {
              [dir.filename] = {
                name = "C Proj",
                description = "Project with cmakelists",
                command = M.cp1(dir.filename, projname, mainfile),
              },
            },
          }
        end
      end
    end
    if not cmake_ok then
      if M.c_level ~= 1 then
        M.c_level = 1
        require 'code_runner'.setup {
          filetype = {
            c = M.c1,
          },
          project = nil,
        }
      end
    end
  end
  vim.cmd 'RunCode'
end

M.run = function()
  vim.cmd 'ProjectRootCD'
  if vim.bo.ft == 'c' or vim.bo.ft == 'cpp' or vim.fn.expand '%:p:t' == 'CMakeLists.txt' then
    local dir = path:new(vim.api.nvim_buf_get_name(0)):parent()
    local cmakelists = dir:joinpath 'CMakeLists.txt'
    local cmake_ok = nil
    if cmakelists:exists() then
      local content = cmakelists:read()
      local projname = content:match 'set%(PROJECT_NAME ([%S]+)%)'
      local mainfile = content:match '${PROJECT_SOURCE_DIR}/([%w%p]+).c'
      local curname = vim.fn.expand '%:p:t:r'
      if projname == curname or projname == 'common' then
        cmake_ok = 1
        if dir.filename ~= M.c_projdir or M.c_level ~= 12 or M.mainfile ~= mainfile then
          M.c_projdir = dir.filename
          M.c_level = 12
          M.mainfile = mainfile
          require 'code_runner'.setup {
            project = {
              [dir.filename] = {
                name = "C Proj",
                description = "Project with cmakelists",
                command = M.cp2(dir.filename, mainfile),
              },
            },
          }
        end
      end
    end
    if not cmake_ok then
      if M.c_level ~= 2 then
        M.c_level = 2
        require 'code_runner'.setup {
          filetype = {
            c = M.c2,
          },
          project = nil,
        }
      end
    end
  end
  vim.cmd 'RunCode'
end

return M
