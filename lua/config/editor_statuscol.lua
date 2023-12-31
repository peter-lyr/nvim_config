local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

local builtin = require 'statuscol.builtin'

local cfg = {
  bt_ignore = { 'terminal', 'nofile', },
  relculright = true,
  segments = {
    { text = { builtin.foldfunc, }, click = 'v:lua.ScFa', },
    {
      sign = { name = { 'Diagnostic', }, maxwidth = 2, colwidth = 1, auto = true, },
      click = 'v:lua.ScSa',
    },
    { text = { builtin.lnumfunc, }, click = 'v:lua.ScLa', },
    {
      sign = { name = { '.*', }, namespace = { '.*', }, maxwidth = 2, colwidth = 1, wrap = true, auto = true, },
      click = 'v:lua.ScSa',
    },
    { text = { '│', }, condition = { builtin.not_empty, }, },
  },
}

function M.init()
  require 'statuscol'.setup(cfg)
end

M.init()

return M
