local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

require 'neodev'.setup()

local lspconfig = require 'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require 'cmp_nvim_lsp'.default_capabilities(capabilities)

function M.root_dir(root_files)
  return function(fname)
    local util = require 'lspconfig.util'
    return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
  end
end

--------------------------

-- M.lua_libraries_dir_path = B.get_std_data_dir_path 'lua_libraries'
-- M.lua_libraries_txt_path = M.lua_libraries_dir_path:joinpath 'lua_libraries.txt'
-- M.lua_libraries = {}
--
-- if not M.lua_libraries_dir_path:exists() then
--   vim.fn.mkdir(M.lua_libraries_dir_path.filename)
-- end
--
-- function M.update_lua_libraries()
--   B.system_run('start', 'python "%s" "%s" "%s"',
--     M.source .. '.py',
--     M.lua_libraries_txt_path.filename,
--     vim.fn.stdpath 'config')
-- end
--
-- if not M.lua_libraries_txt_path:exists() then
--   M.update_lua_libraries()
-- end
--
-- for _, lua_library in ipairs(M.lua_libraries_txt_path:readlines()) do
--   local file = vim.fn.trim(lua_library)
--   if #file > 0 and B.file_exists(file) then
--     M.lua_libraries[#M.lua_libraries + 1] = file
--   end
-- end

--------------------------

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  root_dir = M.root_dir {
    '.git',
  },
  single_file_support = true,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', },
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
        library = {}, --vim.api.nvim_get_runtime_file('', true),
        -- library = M.lua_libraries,
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
