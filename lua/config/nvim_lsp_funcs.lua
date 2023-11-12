local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.stop_all()
  vim.lsp.stop_client(vim.lsp.get_active_clients(), true)
end

function M.rename()
  vim.fn.feedkeys(':IncRename ' .. vim.fn.expand '<cword>')
end

function M.format()
  vim.lsp.buf.format {
    async = true,
    filter = function(client)
      return client.name ~= 'clangd'
    end,
  }
end

function M.format_paragraph()
  local save_cursor = vim.fn.getpos '.'
  vim.cmd 'norm =ap'
  pcall(vim.fn.setpos, '.', save_cursor)
end

function M.format_input()
  vim.cmd [[
    call feedkeys("\<esc>:silent !clang-format -i \<c-r>=nvim_buf_get_name(0)\<cr> --style=\"{BasedOnStyle: llvm, IndentWidth: 4, ColumnLimit: 200, SortIncludes: true}\"")
  ]]
end

function M.diagnostic_open_float()
  vim.diagnostic.open_float()
end

function M.diagnostic_setloclist()
  vim.diagnostic.setloclist()
end

function M.diagnostic_goto_prev()
  vim.diagnostic.goto_prev()
end

function M.diagnostic_goto_next()
  vim.diagnostic.goto_next()
end

function M.diagnostic_enable()
  vim.diagnostic.enable()
end

function M.diagnostic_disable()
  vim.diagnostic.disable()
end

function M.definition()
  vim.lsp.buf.definition()
end

function M.declaration()
  vim.lsp.buf.declaration()
end

function M.hover()
  vim.lsp.buf.hover()
end

function M.implementation()
  vim.lsp.buf.implementation()
end

function M.signature_help()
  vim.lsp.buf.signature_help()
end

function M.references()
  vim.lsp.buf.references()
end

function M.type_definition()
  vim.lsp.buf.type_definition()
end

function M.code_action()
  vim.lsp.buf.code_action()
end

function M.LspStart()
  vim.cmd 'LspStart'
end

function M.LspRestart()
  vim.cmd 'LspRestart'
end

function M.LspInfo()
  vim.cmd 'LspInfo'
end

function M.feedkeys_LspStop()
  vim.fn.feedkeys ':LspStop '
end

function M.ClangdSwitchSourceHeader()
  vim.cmd 'ClangdSwitchSourceHeader'
end

function M.retab_erase_bad_white_space()
  vim.cmd 'retab'
  vim.cmd [[%s/\s\+$//]]
end

return M
