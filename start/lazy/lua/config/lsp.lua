local M = {}
local B = require 'my_base'
M.source = debug.getinfo(1)['source']
package.loaded[B.get_loaded(M.source)] = nil
--------------------------------------------

local lspconfig = require 'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require 'cmp_nvim_lsp'.default_capabilities(capabilities)

local root_dir = function(root_files)
  return function(fname)
    local util = require 'lspconfig.util'
    return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
  end
end

for name, icon in pairs(require 'lazyvim.config'.icons.diagnostics) do
  name = 'DiagnosticSign' .. name
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '', })
end

local diagnostics = {
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 0,
    source = 'if_many',
    prefix = '●',
  },
  severity_sort = true,
}

vim.diagnostic.config(diagnostics)

lspconfig.clangd.setup {
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = 'utf-16',
  },
  root_dir = root_dir {
    'build',
    '.cache',
    'compile_commands.json',
    'CMakeLists.txt',
    '.git',
  },
}

lspconfig.pyright.setup {
  capabilities = capabilities,
  root_dir = root_dir {
    '.git',
  },
}

M.update_mason_cmd_path = function()
  local config = require 'plenary.path':new(vim.g.pack_path):joinpath('nvim_config', 'start', 'lazy', 'lua', 'config')
  local lsp_mason_path_py = config:joinpath 'lsp_mason_cmd_path.py'.filename
  local install_root_dir = require 'mason.settings'.current.install_root_dir
  B.system_run('asyncrun', 'python "%s" "%s"', lsp_mason_path_py, install_root_dir)
end

M.lua_libraries_txt_p = B.get_file_path({ vim.fn.stdpath 'data', 'lua_libraries', }, 'lua_libraries.txt')

M.lua_libraries = {}

M.update_lua_libraries = function()
  local config_dir_path = B.get_dir_path { vim.g.pack_path, 'nvim_config', 'start', 'lazy', 'lua', 'config', }
  local lsp_lua_libraries_py = config_dir_path:joinpath 'lsp_lua_libraries.py'.filename
  B.system_run('asyncrun', 'python "%s" "%s" "%s"',
    lsp_lua_libraries_py, M.lua_libraries_txt_p.filename,
    B.rep_baskslash(vim.fn.expand '$VIMRUNTIME') .. '/pack/nvim_config')
end

if not M.lua_libraries_txt_p:exists() then
  M.update_lua_libraries()
end

for _, lua_library in ipairs(M.lua_libraries_txt_p:readlines()) do
  local file = vim.fn.trim(lua_library)
  if #file > 0 and B.file_exists(file) then
    M.lua_libraries[#M.lua_libraries + 1] = file
  end
end

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  root_dir = root_dir {
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
        -- library = {}, --vim.api.nvim_get_runtime_file('', true),
        library = M.lua_libraries,
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

lspconfig.vimls.setup {
  capabilities = capabilities,
  root_dir = root_dir {
    '.git',
  },
}

lspconfig.marksman.setup {
  capabilities = capabilities,
  root_dir = root_dir {
    '.git',
  },
}

M.format = function()
  vim.lsp.buf.format {
    async = true,
    filter = function(client)
      return client.name ~= 'clangd'
    end,
  }
end

M.format_paragraph = function()
  local save_cursor = vim.fn.getpos '.'
  vim.cmd 'norm =ap'
  pcall(vim.fn.setpos, '.', save_cursor)
end

M.stop_all = function()
  vim.lsp.stop_client(vim.lsp.get_active_clients(), true)
end

M.rename = function()
  vim.fn.feedkeys(':IncRename ' .. vim.fn.expand '<cword>')
end

B.aucmd(M.source, 'LspAttach', { 'LspAttach', }, {
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = function(desc)
      return { buffer = ev.buf, desc = desc, }
    end
    vim.keymap.set({ 'n', 'v', }, 'K', vim.lsp.buf.definition, opts 'vim.lsp.buf.definition')
  end,
})

M.format_input = function()
  vim.cmd [[
    call feedkeys("\<esc>:silent !clang-format -i \<c-r>=nvim_buf_get_name(0)\<cr> --style=\"{BasedOnStyle: llvm, IndentWidth: 4, ColumnLimit: 200, SortIncludes: true}\"")
  ]]
end

M.focuslost_timer = 0
M.lsp_stopped = nil

B.aucmd(M.source, 'FocusGained', { 'FocusGained', }, {
  callback = function()
    B.clear_interval(M.focuslost_timer)
    if M.lsp_stopped then
      vim.cmd 'LspStart'
    end
    M.lsp_stopped = nil
  end,
})

B.aucmd(M.source, 'FocusLost', { 'FocusLost', }, {
  callback = function()
    B.clear_interval(M.focuslost_timer)
    M.focuslost_timer = B.set_timeout(1000 * 60 * 60 * 3, function()
      B.clear_interval(M.focuslost_timer)
      vim.lsp.stop_client(vim.lsp.get_active_clients(), true)
      M.lsp_stopped = 1
    end)
  end,
})

return M
