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
    spacing = 4,
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
        disable = { 'incomplete-signature-doc' },
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

vim.keymap.set('n', '[f', vim.diagnostic.open_float)
vim.keymap.set('n', ']f', vim.diagnostic.setloclist)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)


vim.keymap.set('n', '<leader>fS', ':LspStart<cr>')
vim.keymap.set('n', '<leader>fR', ':LspRestart<cr>')
vim.keymap.set('n', '<leader>fW', function() vim.lsp.stop_client(vim.lsp.get_active_clients({ bufnr = vim.fn.bufnr() })) end)
vim.keymap.set('n', '<leader>fE', function() vim.lsp.stop_client(vim.lsp.get_active_clients()) end)
vim.keymap.set('n', '<leader>fD', [[:call feedkeys(':LspStop ')<cr>]])
vim.keymap.set('n', '<leader>fF', ':LspInfo<cr>')

vim.keymap.set('n', '<leader>fw', ':ClangdSwitchSourceHeader<cr>')


vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = { buffer = ev.buf }
    vim.keymap.set({ 'n', 'v' }, 'K', vim.lsp.buf.definition, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>fo', vim.lsp.buf.definition, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>fd', vim.lsp.buf.declaration, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>fh', vim.lsp.buf.hover, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>fi', vim.lsp.buf.implementation, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>fs', vim.lsp.buf.signature_help, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>fe', vim.lsp.buf.references, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader><leader>fd', vim.lsp.buf.type_definition, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>fn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ff', function() vim.lsp.buf.format { async = true } end, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>fc', vim.lsp.buf.code_action, opts)
  end,
})
