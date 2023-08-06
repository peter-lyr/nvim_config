local M = {}

local path = require("plenary.path")

M.c0 = {
  'cd $dir &&',
  'pwd &&',
  'echo ============================================================ &&',
  'taskkill /f /im $fileNameWithoutExt.exe &',
  'echo ============================================================ &&',
  'gcc $fileName -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o $fileNameWithoutExt &&',
  'echo ============================================================ &&',
  'strip -s $dir\\$fileNameWithoutExt.exe &&',
  'echo ============================================================ &&',
  'upx -qq --best $dir\\$fileNameWithoutExt.exe &&',
  'echo ============================================================ &&',
  '$dir\\$fileNameWithoutExt.exe'
}

M.c1 = {
  'cd $dir &&',
  'pwd &&',
  'echo ============================================================ &&',
  'taskkill /f /im $fileNameWithoutExt.exe &',
  'echo ============================================================ &&',
  'gcc $fileName -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o $fileNameWithoutExt &&',
  'echo ============================================================ &&',
  'strip -s $dir\\$fileNameWithoutExt.exe &&',
  'echo ============================================================ &&',
  'upx -qq --best $dir\\$fileNameWithoutExt.exe &&',
  'echo ============================================================ &&',
  'echo build done'
}

M.c2 = {
  'cd $dir &&',
  'pwd &&',
  'echo ============================================================ &&',
  '$fileNameWithoutExt.exe &&',
  'echo ============================================================ &&',
  'echo run last done',
}

M.cp0 = function(projname, curname)
  return table.concat({
    'pwd',
    'echo ============================================================',
    'del /s /q .cache & rd /s /q .cache & del /s /q build & rd /s /q build & cmake -B build -G "MinGW Makefiles"',
    'echo ============================================================',
    'cd build',
    'echo ============================================================',
    'mingw32-make',
    'echo ============================================================',
    string.format('strip -s %s.exe', projname),
    'echo ============================================================',
    string.format('upx -qq --best %s.exe', projname),
    'echo ============================================================',
    string.format('copy %s.exe ..\\%s.exe', projname, curname),
    'echo ============================================================',
    'cd ..',
    'pwd',
    'echo ============================================================',
    string.format('echo %s.exe', curname),
    'echo ============================================================',
    string.format('%s.exe', curname),
  }, ' && ')
end

M.cp1 = function(projname, curname)
  return table.concat({
    'pwd',
    'echo ============================================================',
    'del /s /q .cache & rd /s /q .cache & del /s /q build & rd /s /q build & cmake -B build -G "MinGW Makefiles"',
    'echo ============================================================',
    'cd build',
    'echo ============================================================',
    'mingw32-make',
    'echo ============================================================',
    string.format('strip -s %s.exe', projname),
    'echo ============================================================',
    string.format('upx -qq --best %s.exe', projname),
    'echo ============================================================',
    string.format('copy %s.exe ..\\%s.exe', projname, curname),
    'echo ============================================================',
    string.format('echo %s.exe', curname),
    'echo ============================================================',
    'echo build done',
  }, ' && ')
end

M.cp2 = function(_, curname)
  return table.concat({
    'pwd',
    'echo ============================================================',
    string.format('echo %s.exe', curname),
    'echo ============================================================',
    string.format('%s.exe', curname),
    'echo ============================================================',
    'echo run last done',
  }, ' && ')
end

require('code_runner').setup({
  -- mode = 'float',
  startinsert = true,
  filetype = {
    python = 'python -u',
    c = M.c0,
  },
})

-- 0: build and run
-- 1: build
-- 2: run
M.c_level = 0

M.c_projdir = ''

M.runbuild = function()
  if vim.bo.ft ~= 'c' and vim.bo.ft ~= 'cpp' then
    return
  end
  vim.cmd('ProjectRootCD')
  local dir = path:new(vim.api.nvim_buf_get_name(0)):parent()
  local cmakelists = dir:joinpath('CMakeLists.txt')
  local cmake_ok = nil
  if cmakelists:exists() then
    local content = cmakelists:read()
    local projname = content:match('set%(PROJECT_NAME ([%S]+)%)')
    local curname = vim.fn.expand('%:p:t:r')
    if projname == curname or projname == 'common' then
      cmake_ok = 1
      if dir.filename ~= M.c_projdir or M.c_level ~= 10 then
        M.c_projdir = dir.filename
        M.c_level = 10
        require('code_runner').setup({
          project = {
            [dir.filename] = {
              name = "C Proj",
              description = "Project with cmakelists",
              command = M.cp0(projname, curname)
            }
          },
        })
      end
    end
  end
  if not cmake_ok then
    if M.c_level ~= 0 then
      M.c_level = 0
      require('code_runner').setup({
        filetype = {
          c = M.c0,
        },
        project = nil
      })
    end
  end
  vim.cmd('RunCode')
end

M.build = function()
  if vim.bo.ft ~= 'c' and vim.bo.ft ~= 'cpp' then
    return
  end
  vim.cmd('ProjectRootCD')
  local dir = path:new(vim.api.nvim_buf_get_name(0)):parent()
  local cmakelists = dir:joinpath('CMakeLists.txt')
  local cmake_ok = nil
  if cmakelists:exists() then
    local content = cmakelists:read()
    local projname = content:match('set%(PROJECT_NAME ([%S]+)%)')
    local curname = vim.fn.expand('%:p:t:r')
    if projname == curname or projname == 'common' then
      cmake_ok = 1
      if dir.filename ~= M.c_projdir or M.c_level ~= 11 then
        M.c_projdir = dir.filename
        M.c_level = 11
        require('code_runner').setup({
          project = {
            [dir.filename] = {
              name = "C Proj",
              description = "Project with cmakelists",
              command = M.cp1(projname, curname)
            }
          },
        })
      end
    end
  end
  if not cmake_ok then
    if M.c_level ~= 1 then
      M.c_level = 1
      require('code_runner').setup({
        filetype = {
          c = M.c1,
        },
        project = nil
      })
    end
  end
  vim.cmd('RunCode')
end

M.run = function()
  if vim.bo.ft ~= 'c' and vim.bo.ft ~= 'cpp' then
    return
  end
  vim.cmd('ProjectRootCD')
  local dir = path:new(vim.api.nvim_buf_get_name(0)):parent()
  local cmakelists = dir:joinpath('CMakeLists.txt')
  local cmake_ok = nil
  if cmakelists:exists() then
    local content = cmakelists:read()
    local projname = content:match('set%(PROJECT_NAME ([%S]+)%)')
    local curname = vim.fn.expand('%:p:t:r')
    if projname == curname or projname == 'common' then
      cmake_ok = 1
      if dir.filename ~= M.c_projdir or M.c_level ~= 12 then
        M.c_projdir = dir.filename
        M.c_level = 12
        require('code_runner').setup({
          project = {
            [dir.filename] = {
              name = "C Proj",
              description = "Project with cmakelists",
              command = M.cp2(projname, curname)
            }
          },
        })
      end
    end
  end
  if not cmake_ok then
    if M.c_level ~= 2 then
      M.c_level = 2
      require('code_runner').setup({
        filetype = {
          c = M.c2,
        },
        project = nil
      })
    end
  end
  vim.cmd('RunCode')
end

return M
