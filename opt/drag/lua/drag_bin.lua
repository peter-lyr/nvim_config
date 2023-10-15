local M = {}

package.loaded['drag_bin'] = nil

M.check = function(buf)
  local info = vim.fn.system(string.format('file -b --mime-type --mime-encoding "%s"', vim.api.nvim_buf_get_name(buf)))
  info = string.gsub(info, '%s', '')
  local info_l = vim.fn.split(info, ';')
  if info_l[2] and string.match(info_l[2], 'binary') and info_l[1] and not string.match(info_l[1], 'empty') then
    return 'Bdelete!'
  end
  return ''
end

return M
