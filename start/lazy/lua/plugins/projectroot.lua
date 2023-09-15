return {
  'dbakker/vim-projectroot',
  lazy = true,
  config = function()
    vim.g.rootmarkers = {
      '.git',
    }
  end,
}
