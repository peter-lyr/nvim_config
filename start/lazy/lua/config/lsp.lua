local lspconfig = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local root_dir = function(root_files)
  return function(fname)
    local util = require('lspconfig.util')
    return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
  end
end

for name, icon in pairs(require("lazyvim.config").icons.diagnostics) do
  name = "DiagnosticSign" .. name
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end

local diagnostics = {
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 0,
    source = "if_many",
    prefix = "●",
  },
  severity_sort = true,
}

vim.diagnostic.config(diagnostics)

lspconfig.clangd.setup({
  capabilities = capabilities,
  root_dir = root_dir({
    'build',
    '.cache',
    'compile_commands.json',
    'CMakeLists.txt',
    '.git',
  }),
})

lspconfig.pyright.setup({
  capabilities = capabilities,
  root_dir = root_dir({
    '.git',
  }),
})

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  root_dir = root_dir({
    '.git',
  }),
  single_file_support = true,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
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
    },
  }
})

lspconfig.vimls.setup({
  capabilities = capabilities,
  root_dir = root_dir({
    '.git',
  }),
})

lspconfig.marksman.setup({
  capabilities = capabilities,
  root_dir = root_dir({
    '.git',
  }),
})

vim.keymap.set('n', '[f', vim.diagnostic.open_float, { desc = 'vim.diagnostic.open_float' })
vim.keymap.set('n', ']f', vim.diagnostic.setloclist, { desc = 'vim.diagnostic.setloclist' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'vim.diagnostic.goto_prev' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'vim.diagnostic.goto_next' })


vim.keymap.set('n', '<leader>fvs', ':LspStart<cr>', { desc = 'LspStart' })
vim.keymap.set('n', '<leader>fvr', ':LspRestart<cr>', { desc = 'LspRestart' })
vim.keymap.set('n', '<leader>fq',  vim.diagnostic.enable, { desc = 'vim.diagnostic.enable' })
vim.keymap.set('n', '<leader>fvq', vim.diagnostic.disable, { desc = 'vim.diagnostic.disable' })
vim.keymap.set('n', '<leader>fvw', function() vim.lsp.stop_client(vim.lsp.get_active_clients()) end, { desc = 'stop all lsp clients' })
vim.keymap.set('n', '<leader>fvd', [[:call feedkeys(':LspStop ')<cr>]], { desc = 'stop one lsp client of' })
vim.keymap.set('n', '<leader>fvf', ':LspInfo<cr>', { desc = 'LspInfo' })

vim.keymap.set('n', '<leader>fw', ':ClangdSwitchSourceHeader<cr>', { desc = 'ClangdSwitchSourceHeader' })


vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = function(desc)
      return { buffer = ev.buf, desc = desc }
    end
    vim.keymap.set({ 'n', 'v' }, 'K', vim.lsp.buf.definition, opts('vim.lsp.buf.definition'))
    vim.keymap.set({ 'n', 'v' }, '<leader>fo', vim.lsp.buf.definition, opts('vim.lsp.buf.definition'))
    vim.keymap.set({ 'n', 'v' }, '<leader>fd', vim.lsp.buf.declaration, opts('vim.lsp.buf.declaration'))
    vim.keymap.set({ 'n', 'v' }, '<leader>fh', vim.lsp.buf.hover, opts('vim.lsp.buf.hover'))
    vim.keymap.set({ 'n', 'v' }, '<leader>fi', vim.lsp.buf.implementation, opts('vim.lsp.buf.implementation'))
    vim.keymap.set({ 'n', 'v' }, '<leader>fs', vim.lsp.buf.signature_help, opts('vim.lsp.buf.signature_help'))
    vim.keymap.set({ 'n', 'v' }, '<leader>fe', vim.lsp.buf.references, opts('vim.lsp.buf.references'))
    vim.keymap.set({ 'n', 'v' }, '<leader><leader>fd', vim.lsp.buf.type_definition, opts('vim.lsp.buf.type_definition'))
    vim.keymap.set({ 'n', 'v' }, '<leader>fn', function() vim.fn.feedkeys(":IncRename " .. vim.fn.expand("<cword>")) end, opts('lsp rename IncRename'))
    vim.keymap.set({ 'n', 'v' }, '<leader>ff', function() vim.lsp.buf.format { async = true } end, opts('vim.lsp.buf.format'))
    vim.keymap.set({ 'n', 'v' }, '<leader>fc', vim.lsp.buf.code_action, opts('vim.lsp.buf.code_action'))
  end,
})
