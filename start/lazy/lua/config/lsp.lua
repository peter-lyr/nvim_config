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
        library = {
          'opt.maps.lua.',
          'opt.tabline.lua.',
          'opt.terminal.lua.terminal',
          'opt.test.lua.test',
        },
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
vim.keymap.set({ 'n', 'v', }, '<leader>fW', function() vim.lsp.stop_client(vim.lsp.get_active_clients()) end, { desc = 'stop all lsp clients', })
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
