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

local function rep(content)
  content = string.gsub(content, '\\', '/')
  return content
end

local function system_run(way, str_format, ...)
  local cmd = string.format(str_format, ...)
  if way == 'start' then
    cmd = string.format([[silent !start cmd /c "%s & pause"]], cmd)
  elseif way == 'asyncrun' then
    cmd = string.format('AsyncRun %s', cmd)
  elseif way == 'term' then
    cmd = string.format('wincmd s|term %s', cmd)
  end
  vim.cmd(cmd)
end

local M = {}

M.update_mason_cmd_path = function()
  local config = require 'plenary.path':new(vim.g.pack_path):joinpath('nvim_config', 'start', 'lazy', 'lua', 'config')
  local lsp_mason_path_py = config:joinpath 'lsp_mason_cmd_path.py'.filename
  local install_root_dir = require 'mason.settings'.current.install_root_dir
  system_run('start', 'python "%s" "%s"', lsp_mason_path_py, install_root_dir)
end

M.lua_libraries_dir_p = require 'plenary.path':new(vim.fn.stdpath 'data'):joinpath 'lua_libraries'
M.lua_libraries_txt_p = M.lua_libraries_dir_p:joinpath 'lua_libraries.txt'

if not M.lua_libraries_dir_p:exists() then
  vim.fn.mkdir(M.lua_libraries_dir_p.filename)
end

local nvim_config = rep(vim.fn.expand '$VIMRUNTIME') .. '/pack/nvim_config/'

local my_libraries = {
  'opt/tabline/lua',
  'opt/terminal/lua',
  'opt/test/lua',
}

local lua_libraries = {}

for _, v in ipairs(my_libraries) do
  lua_libraries[#lua_libraries + 1] = nvim_config .. v
end

M.update_lua_libraries = function()
  local libraries_3rd = vim.api.nvim_get_runtime_file('', true)
  local temp = {}
  for _, v in ipairs(libraries_3rd) do
    local entries = require 'plenary.scandir'.scan_dir(v, { hidden = false, depth = 18, add_dirs = true, })
    for _, entry in ipairs(entries) do
      entry = rep(entry)
      if require 'plenary.path':new(entry):is_dir() == true and string.match(entry, '/([^/]+)$') == 'lua' then
        temp[#temp + 1] = entry
      end
    end
  end
  M.lua_libraries_txt_p:write(vim.fn.join(temp, '\n'), 'w')
end

if not M.lua_libraries_txt_p:exists() then
  M.update_lua_libraries()
end

for _, lua_library in ipairs(M.lua_libraries_txt_p:readlines()) do
  lua_libraries[#lua_libraries + 1] = lua_library
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
        library = lua_libraries,
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

vim.keymap.set({ 'n', 'v', }, '[f', vim.diagnostic.open_float, { desc = 'vim.diagnostic.open_float', })
vim.keymap.set({ 'n', 'v', }, ']f', vim.diagnostic.setloclist, { desc = 'vim.diagnostic.setloclist', })
vim.keymap.set({ 'n', 'v', }, '[d', vim.diagnostic.goto_prev, { desc = 'vim.diagnostic.goto_prev', })
vim.keymap.set({ 'n', 'v', }, ']d', vim.diagnostic.goto_next, { desc = 'vim.diagnostic.goto_next', })


vim.keymap.set({ 'n', 'v', }, '<leader>fS', ':<c-u>LspStart<cr>', { desc = 'LspStart', })
vim.keymap.set({ 'n', 'v', }, '<leader>fR', ':<c-u>LspRestart<cr>', { desc = 'LspRestart', })
vim.keymap.set({ 'n', 'v', }, '<leader>fq', vim.diagnostic.enable, { desc = 'vim.diagnostic.enable', })
vim.keymap.set({ 'n', 'v', }, '<leader>fvq', vim.diagnostic.disable, { desc = 'vim.diagnostic.disable', })
vim.keymap.set({ 'n', 'v', }, '<leader>fW', function() vim.lsp.stop_client(vim.lsp.get_active_clients(), true) end, { desc = 'stop all lsp clients', })
vim.keymap.set({ 'n', 'v', }, '<leader>fD', [[:call feedkeys(':LspStop ')<cr>]], { desc = 'stop one lsp client of', })
vim.keymap.set({ 'n', 'v', }, '<leader>fF', ':<c-u>LspInfo<cr>', { desc = 'LspInfo', })

vim.keymap.set({ 'n', 'v', }, '<leader>fw', ':<c-u>ClangdSwitchSourceHeader<cr>', { desc = 'ClangdSwitchSourceHeader', })
vim.keymap.set({ 'n', 'v', }, '<F11>', ':<c-u>ClangdSwitchSourceHeader<cr>', { desc = 'ClangdSwitchSourceHeader', })
vim.keymap.set({ 'n', 'v', }, '<leader>fp', function()
  local save_cursor = vim.fn.getpos '.'
  vim.cmd 'norm =ap'
  pcall(vim.fn.setpos, '.', save_cursor)
end, { desc = '=ap', })


pcall(vim.api.nvim_del_autocmd, vim.g.lsp_au_lspattach)

vim.g.lsp_au_lspattach = vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = function(desc)
      return { buffer = ev.buf, desc = desc, }
    end
    vim.keymap.set({ 'n', 'v', }, 'K', vim.lsp.buf.definition, opts 'vim.lsp.buf.definition')
    vim.keymap.set({ 'n', 'v', }, '<leader>fo', vim.lsp.buf.definition, opts 'vim.lsp.buf.definition')
    vim.keymap.set({ 'n', 'v', }, '<F12>', vim.lsp.buf.definition, opts 'vim.lsp.buf.definition')
    vim.keymap.set({ 'n', 'v', }, '<leader>fd', vim.lsp.buf.declaration, opts 'vim.lsp.buf.declaration')
    vim.keymap.set({ 'n', 'v', }, '<C-F12>', vim.lsp.buf.declaration, opts 'vim.lsp.buf.declaration')
    vim.keymap.set({ 'n', 'v', }, '<leader>fh', vim.lsp.buf.hover, opts 'vim.lsp.buf.hover')
    vim.keymap.set({ 'n', 'v', }, '<A-F12>', vim.lsp.buf.hover, opts 'vim.lsp.buf.hover')
    vim.keymap.set({ 'n', 'v', }, '<leader>fi', vim.lsp.buf.implementation, opts 'vim.lsp.buf.implementation')
    vim.keymap.set({ 'n', 'v', }, '<leader>fs', vim.lsp.buf.signature_help, opts 'vim.lsp.buf.signature_help')
    vim.keymap.set({ 'n', 'v', }, '<leader>fe', vim.lsp.buf.references, opts 'vim.lsp.buf.references')
    vim.keymap.set({ 'n', 'v', }, '<S-F12>', vim.lsp.buf.references, opts 'vim.lsp.buf.references')
    vim.keymap.set({ 'n', 'v', }, '<leader>fvd', vim.lsp.buf.type_definition, opts 'vim.lsp.buf.type_definition')
    vim.keymap.set({ 'n', 'v', }, '<leader>fn', function()
      vim.fn.feedkeys(':IncRename ' .. vim.fn.expand '<cword>')
    end, opts 'lsp rename IncRename')
    vim.keymap.set({ 'n', 'v', }, '<leader>ff', function()
      vim.lsp.buf.format {
        async = true,
        filter = function(client)
          return client.name ~= 'clangd'
        end,
      }
    end, opts 'vim.lsp.buf.format')
    vim.keymap.set({ 'n', 'v', }, '<leader>fc', vim.lsp.buf.code_action, opts 'vim.lsp.buf.code_action')
  end,
})

vim.keymap.set('n', '<leader>fve', [[<cmd>%s/\s\+$//<cr>]], { desc = 'erase bad white space', })

vim.keymap.set('n', '<leader>fC', function()
  vim.cmd [[
    call feedkeys("\<esc>:silent !clang-format -i \<c-r>=nvim_buf_get_name(0)\<cr> --style=\"{BasedOnStyle: llvm, IndentWidth: 4, ColumnLimit: 200, SortIncludes: true}\"")
  ]]
end, { desc = 'clang-format ...', silent = true, })

M.focuslost_timer = 0
M.lsp_stopped = nil

pcall(vim.api.nvim_del_autocmd, vim.g.lsp_au_focusgained)

vim.g.lsp_au_focusgained = vim.api.nvim_create_autocmd({ 'FocusGained', }, {
  callback = function()
    if M.focuslost_timer ~= 0 then
      M.focuslost_timer:stop()
    end
    M.focuslost_timer = 0
    if M.lsp_stopped then
      vim.cmd 'LspStart'
    end
    M.lsp_stopped = nil
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.lsp_au_focuslost)

vim.g.lsp_au_focuslost = vim.api.nvim_create_autocmd({ 'FocusLost', }, {
  callback = function()
    if M.focuslost_timer ~= 0 then
      M.focuslost_timer:stop()
    end
    M.focuslost_timer = vim.loop.new_timer()
    M.focuslost_timer:start(1000 * 20, 0, function()
      vim.schedule(function()
        vim.lsp.stop_client(vim.lsp.get_active_clients(), true)
        M.lsp_stopped = 1
      end)
    end)
  end,
})

vim.api.nvim_create_user_command('UpdateLuaLspLibrary', M.update_lua_libraries, {})
vim.api.nvim_create_user_command('UpdateMasonCmdPath', M.update_mason_cmd_path, {})
