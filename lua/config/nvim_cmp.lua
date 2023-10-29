local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.load_require 'nvim-lua/plenary.nvim'

local snippets_path = require 'plenary.path':new(M.source .. '.snippets')

if not snippets_path:is_dir() then
  vim.fn.mkdir(snippets_path.filename)
end

require 'luasnip.loaders.from_vscode'.lazy_load()
require 'luasnip.loaders.from_snipmate'.lazy_load { paths = { snippets_path.filename, }, }

require 'luasnip'.config.setup {
  history = true,
  delete_check_events = 'TextChanged',
}

------------

vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true, })

local cmp = require 'cmp'
-- local types = require 'cmp.types'
local luasnip = require 'luasnip'

cmp.setup {
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's', }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's', }),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<c-m>'] = cmp.mapping.confirm { select = false, },
  },
  sources = cmp.config.sources {
    { name = 'nvim_lsp', },
    { name = 'luasnip', },
    { name = 'buffer', },
    { name = 'path', },
  },
  formatting = {
    format = function(_, item)
      local icons = require 'lazyvim.config'.icons.kinds
      if icons[item.kind] then
        item.kind = icons[item.kind] .. item.kind
      end
      return item
    end,
  },
  experimental = {
    ghost_text = {
      hl_group = 'CmpGhostText',
    },
  },
}

cmp.setup.cmdline({ '/', '?', }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer', },
  },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path', },
  }, {
    { name = 'cmdline', },
  }),
})

return M
