return {
  'phaazon/hop.nvim',
  lazy = true,
  keys = {
    { 's', ':HopChar1<cr>', mode = { 'n', }, silent = true, desc = 'HopChar1' },
  },
  config = function()
    require('hop').setup({
      keys = 'asdghklqwertyuiopzxcvbnmfj'
    })
  end,
}
