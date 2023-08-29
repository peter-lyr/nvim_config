return {
  'hrsh7th/nvim-cmp',
  lazy = true,
  version = false, -- last release is way too old
  event = 'InsertEnter',
  dependencies = {
    'LazyVim/LazyVim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    {
      'saadparwaiz1/cmp_luasnip',
      dependencies = {
        -- snippets
        'L3MON4D3/LuaSnip',
        dependencies = {
          'rafamadriz/friendly-snippets',
          dependencies = {
            require 'wait.plenary',
          },
          config = function()
            require 'luasnip.loaders.from_vscode'.lazy_load()
            require 'luasnip.loaders.from_snipmate'.lazy_load {
              paths = {
                require 'plenary.path':new(vim.g.pack_path):joinpath('nvim_config', 'opt', 'snippets').filename, },
            }
            require 'luasnip'.config.setup {}
          end,
        },
        opts = {
          history = true,
          delete_check_events = 'TextChanged',
        },
      },
    },
  },
  config = function()
    vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true, })
    local cmp = require 'cmp'
    local types = require 'cmp.types'
    cmp.setup {
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      snippet = {
        expand = function(args)
          require 'luasnip'.lsp_expand(args.body)
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
        ['qo'] = cmp.mapping.confirm { select = false, },
        ['qi'] = {
          i = function()
            if cmp.visible() then
              cmp.select_next_item { behavior = types.cmp.SelectBehavior.Insert, }
              cmp.confirm { select = false, }
            else
              cmp.complete()
            end
          end,
        },
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
  end,
}
