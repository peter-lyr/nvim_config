local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
package.loaded[B.get_loaded(M.source)] = nil
--------------------------------------------

require 'luasnip.loaders.from_vscode'.lazy_load()
require 'luasnip.loaders.from_snipmate'.lazy_load { paths = { B.get_opt_dir 'snippets', }, }

require 'luasnip'.config.setup {
  history = true,
  delete_check_events = 'TextChanged',
}

return M
