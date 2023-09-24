package.loaded['config.coderunner'] = nil

local M = {}

M.merge_tables = function(...)
  local result = {}
  for _, t in ipairs { ..., } do
    for _, v in ipairs(t) do
      result[#result+1] = v
    end
  end
  return result
end

M.cmd_pre = {
  'cd $dir',
  'pwd',
  'taskkill /f /im $fileNameWithoutExt.exe',
}

M.cmd_run = {
  '$dir\\$fileNameWithoutExt.exe',
}

M.cmd_build = {
  'gcc $fileName -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o $fileNameWithoutExt',
}

M.cmd_compress = {
  'strip -s $dir\\$fileNameWithoutExt.exe',
  'upx -qq --best $dir\\$fileNameWithoutExt.exe',
}

M.get_cmd = function(...)
  local cmd = vim.fn.join(M.merge_tables(...), ' & echo ========== & ')
  return cmd
end

M.get_cmd_run = function()
  return M.get_cmd(M.cmd_run)
end

M.get_cmd_build = function()
  return M.get_cmd(M.cmd_pre, M.cmd_compress, M.cmd_build)
end

M.get_cmd_build_run = function()
  return M.get_cmd(M.cmd_pre, M.cmd_compress, M.cmd_build, M.cmd_run)
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
  vim.cmd 'RunCode'
  vim.fn.timer_start(100, function()
    vim.cmd 'norm Gzz'
    vim.api.nvim_win_set_height(0, 15)
    local opt = { buffer = vim.fn.bufnr(), nowait = true, silent = true, }
    vim.keymap.set('n', 'q', '<cmd>close<cr>', opt)
    vim.keymap.set('n', '<esc>', '<cmd>close<cr>', opt)
  end)
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
