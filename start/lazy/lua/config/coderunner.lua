package.loaded['config.coderunner'] = nil

local M = {}

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
    s = s .. string.sub(p, 1, 2)
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

M.cmd_build = {
  'gcc $fileName -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o $fileNameWithoutExt',
}

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

-- local a = {
--   M.rebuild_en and
--   string.format('%s & del /s /q .cache & rd /s /q .cache & del /s /q build & rd /s /q build & cmake -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 & cd build', systemcd(dir))
--   or string.format('%s & cmake -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 & cd build', systemcd(dir)),
--   string.format('taskkill /f /im %s.exe & mingw32-make -j%d', curname, M.numberofcores * 2),
--   string.format('strip -s %s.exe & cd .', projname),
--   string.format('upx -qq --best %s.exe & cd .', projname),
--   string.format('copy /y %s.exe ..\\%s.exe', projname, curname),
--   'copy /y compile_commands.json ..\\compile_commands.json',
--   'cd ..',
--   string.format('%s.exe', curname),
-- }

M.get_cmd = function(...)
  local cmd = vim.fn.join(M.merge_tables(...), ' & echo ========== & ')
  return cmd
end

M.get_cmd_run = function()
  return M.get_cmd(M.cmd_run())
end

M.get_cmd_build = function()
  return M.get_cmd(M.cmd_pre(), M.cmd_compress(), M.cmd_build)
end

M.get_cmd_build_run = function()
  return M.get_cmd(M.cmd_pre(), M.cmd_compress(), M.cmd_build, M.cmd_run())
end

M.setup_ft = function(ft)
  require 'code_runner'.setup {
    filetype = ft,
  }
end

require 'code_runner'.setup {
  startinsert = true,
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

return M
