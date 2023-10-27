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

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  root_dir = M.root_dir {
    '.git',
  },
  single_file_support = true,
  settings = {
    Lua = {
      diagnostics = {
        -- globals = { 'vim', },
        disable = {
          'incomplete-signature-doc',
          'undefined-global',
        },
        groupSeverity = {
          strong = 'Warning',
          strict = 'Warning',
        },
      },
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        -- library = {}, --vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
      completion = {
        workspaceWord = true,
        callSnippet = 'Both',
      },
      misc = {
        parameters = {
          '--log-level=trace',
        },
      },
      -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/lua.template.editorconfig
      -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config.md
      format = {
        enable = true,
        defaultConfig = {
          max_line_length          = '275',
          indent_size              = '2',
          call_arg_parentheses     = 'remove',
          trailing_table_separator = 'always',
          quote_style              = 'single',
        },
      },
    },
  },
}

return M
