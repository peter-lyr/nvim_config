local M = {}

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
  'upx -q --best $dir\\$fileNameWithoutExt.exe &&',
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

require('code_runner').setup({
  mode = 'float',
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

M.runbuild = function()
  if vim.bo.ft == 'c' then
    if M.c_level ~= 0 then
      M.c_level = 0
      require('code_runner').setup({
        filetype = {
          c = M.c0,
        },
      })
    end
  end
  vim.cmd('ProjectRootCD')
  vim.cmd('RunCode')
end

M.build = function()
  if vim.bo.ft == 'c' then
    if M.c_level ~= 1 then
      M.c_level = 1
      require('code_runner').setup({
        filetype = {
          c = M.c1,
        },
      })
    end
  end
  vim.cmd('ProjectRootCD')
  vim.cmd('RunCode')
end

M.run = function()
  if vim.bo.ft == 'c' then
    if M.c_level ~= 2 then
      M.c_level = 2
      require('code_runner').setup({
        filetype = {
          c = M.c2,
        },
      })
    end
  end
  vim.cmd('ProjectRootCD')
  vim.cmd('RunCode')
end

return M
