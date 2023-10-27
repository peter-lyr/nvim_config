local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

local lspconfig = require 'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require 'cmp_nvim_lsp'.default_capabilities(capabilities)

M.root_dir = function(root_files)
  return function(fname)
    local util = require 'lspconfig.util'
    return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
  end
end

lspconfig.marksman.setup {
  capabilities = capabilities,
  root_dir = M.root_dir {
    '.git',
  },
}

return M
