return {
  'simrat39/symbols-outline.nvim',
  lazy = true,
  event = { 'LspAttach', },
  keys = {
    { '<leader>,', function() require('config.symbolsoutline').toggle() end , mode = { 'n', 'v' }, silent = true, desc = 'SymbolsOutline Toggle' },
  },
  config = function()
    require('config.symbolsoutline')
  end,
}
