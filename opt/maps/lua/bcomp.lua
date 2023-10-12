local M = {}

package.loaded['bcomp'] = nil

M.file1 = ''
M.file2 = ''

M.diff1 = function(file)
  if not file then
    M.file1 = vim.api.nvim_buf_get_name(0)
  else
    M.file1 = file
  end
end

M.diff2 = function(file)
  if not file then
    M.file2 = vim.api.nvim_buf_get_name(0)
  else
    M.file2 = file
  end
  if vim.fn.filereadable(M.file1) == 1 and vim.fn.filereadable(M.file1) == 1 then
    vim.cmd(string.format([[silent !start /b /min cmd /c "bcomp "%s" "%s""]], M.file1, M.file2))
  end
end

M.diff_last = function()
  if vim.fn.filereadable(M.file1) == 1 and vim.fn.filereadable(M.file1) == 1 then
    vim.cmd(string.format([[silent !start /b /min cmd /c "bcomp "%s" "%s""]], M.file1, M.file2))
  else
    print('no compare.')
  end
end

vim.api.nvim_create_user_command('B1', function(params)
  M.diff1(unpack(params['fargs']))
end, { nargs = '*', })

vim.api.nvim_create_user_command('B2', function(params)
  M.diff2(unpack(params['fargs']))
end, { nargs = '*', })

vim.api.nvim_create_user_command('Bl', function(params)
  M.diff_last(unpack(params['fargs']))
end, { nargs = '*', })

return M
