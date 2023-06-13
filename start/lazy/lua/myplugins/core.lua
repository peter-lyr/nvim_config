local opt = vim.fn.expand('$VIMRUNTIME') .. '\\pack\\testnvim2\\opt\\'

return {
  {
    name = 'options',
    dir = opt .. 'options',
  },
  {
    name = 'maps',
    lazy = true,
    dir = opt .. 'maps',
    event = { 'CmdlineEnter', 'InsertEnter', 'ModeChanged', },
    keys = {

      -- maps

      'c.',
      'cu',
      'c-',

      '<a-y>',
      '<a-p>',
      '<a-s-p>',

      '<leader>y',
      '<leader>gy',
      '<leader><leader>gy',

      '<c-j>',
      '<c-k>',

      '<f5>',

      '<rightmouse>',
      '<rightrelease>',
      '<middlemouse>',

      'Q',

      '<leader>f.',

      'U',

      -- bufferjump

      '<leader>ww',

      '<leader>wk',
      '<leader>wj',
      '<leader>wh',
      '<leader>wl',

      '<leader>wo',
      '<leader>wi',
      '<leader>wu',

      '<leader><leader>wo',
      '<leader><leader>wi',

      '<leader><leader><leader>wi',

      '<leader><leader>wk',
      '<leader><leader>wj',
      '<leader><leader>wh',
      '<leader><leader>wl',

    },
  },
}
