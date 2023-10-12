local M = {}

package.loaded['work.upload'] = nil

M.upload = function(file)
  if not file then
    file = vim.api.nvim_buf_get_name(0)
  end
  vim.cmd(string.format([[silent !start /b /min cmd /c "C:\Program Files\FileServ\upload.bat "%s""]], file))
end

return M
