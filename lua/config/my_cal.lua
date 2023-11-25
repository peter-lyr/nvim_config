local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.get_str_num(str, hex)
  vim.g.str = str
  vim.g.hex = hex and 1 or 0
  vim.g.str_is_num = nil
  vim.cmd [[
    python << EOF
import re
import vim
str = vim.eval('g:str')
hex = int(vim.eval('g:hex'))
if not hex:
  if len(str) > 2 and str[:2].lower() == '0x':
    hex = 1
  elif re.findall('[a-fA-F]', str):
    hex = 1
try:
  if hex:
    num = int(str, 16)
  else:
    num = int(str)
  vim.command(f'let g:str_is_num = 1')
  vim.command(f'let g:cnum = {num}')
except Exception as e:
  e = ','.join(e.args).replace("'", '"')
  vim.command(f"""lua require'my_base'.notify_error('get_str_num, error: {e}')""")
EOF
]]
  if vim.g.str_is_num then
    return vim.g.cnum
  end
  return nil
end

function M.count_bin(cword)
  local cnum = M.get_str_num(vim.fn.expand(cword))
  print(cnum)
end

return M
