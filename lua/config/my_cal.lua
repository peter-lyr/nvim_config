local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.get_cword_num(cword)
  vim.g.cword = cword
  vim.g.cword_is_num = nil
  vim.cmd [[
    python << EOF
import vim
cword = vim.eval('g:cword')
try:
  if len(cword) > 2:
    if cword[:2].lower() == '0x':
      num = int(cword, 16)
    else:
      num = int(cword)
  else:
    num = int(cword)
  vim.command(f'let g:cword_is_num = 1')
  vim.command(f'let g:cnum = {num}')
except Exception as e:
  print('get_cword_num, e:', e)
EOF
]]
  if vim.g.cword_is_num then
    return vim.g.cnum
  end
  return nil
end

function M.count_bin(cword)
  local cnum = M.get_cword_num(vim.fn.expand(cword))
  print(cnum)
end

return M
