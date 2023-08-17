local opt = vim.fn.expand('$VIMRUNTIME') .. '\\pack\\nvim_config\\opt\\'

return {
  {
    name = 'work',
    dir = opt .. 'work',
    lazy = true,
    keys = {

      -- c2cmake

      { '<c-F10>', function() require('c2cmake').c2cmake() end, mode = { 'n', 'v', }, silent = true, desc = 'cbp2cmake build' },

      -- cbp2make

      { '<c-F11>', function() require('cbp2make').build() end, mode = { 'n', 'v', }, silent = true, desc = 'cbp2make build' },

      -- sdkcbp

      { '<c-F9>', function() require('sdkcbp').build() end, mode = { 'n', 'v', }, silent = true, desc = 'sdkcbp build' },

      -- tortoise svn

      { '<leader>vo', '<cmd>TortoisesvN settings cur yes<cr>',     mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN settings cur yes<cr>', },

      { '<leader>vd', '<cmd>TortoisesvN diff cur yes<cr>',         mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN diff cur yes<cr>', },
      { '<leader>vD', '<cmd>TortoisesvN diff root yes<cr>',        mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN diff root yes<cr>', },

      { '<leader>vb', '<cmd>TortoisesvN blame cur yes<cr>',        mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN blame cur yes<cr>', },

      { '<leader>vw', '<cmd>TortoisesvN repobrowser cur yes<cr>',  mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN repobrowser cur yes<cr>', },
      { '<leader>vW', '<cmd>TortoisesvN repobrowser root yes<cr>', mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN repobrowser root yes<cr>', },

      { '<leader>vs', '<cmd>TortoisesvN repostatus cur yes<cr>',   mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN repostatus cur yes<cr>', },
      { '<leader>vS', '<cmd>TortoisesvN repostatus root yes<cr>',  mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN repostatus root yes<cr>', },

      { '<leader>vr', '<cmd>TortoisesvN rename cur yes<cr>',       mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN rename cur yes<cr>', },

      { '<leader>vR', '<cmd>TortoisesvN remove cur yes<cr>',       mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN remove cur yes<cr>', },

      { '<leader>vv', '<cmd>TortoisesvN revert cur yes<cr>',       mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN revert cur yes<cr>', },
      { '<leader>vV', '<cmd>TortoisesvN revert root yes<cr>',      mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN revert root yes<cr>', },

      { '<leader>va', '<cmd>TortoisesvN add cur yes<cr>',          mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN add cur yes<cr>', },
      { '<leader>vA', '<cmd>TortoisesvN add root yes<cr>',         mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN add root yes<cr>', },

      { '<leader>vc', '<cmd>TortoisesvN commit cur yes<cr>',       mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN commit cur yes<cr>', },
      { '<leader>vC', '<cmd>TortoisesvN commit root yes<cr>',      mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN commit root yes<cr>', },

      { '<leader>vu', '<cmd>TortoisesvN update root no<cr>',       mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN update root no<cr>', },
      { '<leader>vU', '<cmd>TortoisesvN update /rev root yes<cr>', mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN update /rev root yes<cr>', },

      { '<leader>vl', '<cmd>TortoisesvN log cur yes<cr>',          mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN log cur yes<cr>', },
      { '<leader>vL', '<cmd>TortoisesvN log root yes<cr>',         mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN log root yes<cr>', },

      { '<leader>vk', '<cmd>TortoisesvN checkout root yes<cr>',    mode = { 'n', 'v', }, silent = true, desc = 'TortoisesvN checkout root yes<cr>', },

      -- fileserv.lua

      { '<c-F5>', function() require('fileserv').upclip() end,   mode = { 'n', 'v', }, silent = true, desc = 'upclip' },
      { '<c-F6>', function() require('fileserv').downclip() end, mode = { 'n', 'v', }, silent = true, desc = 'downclip' },

    }
 },
}
