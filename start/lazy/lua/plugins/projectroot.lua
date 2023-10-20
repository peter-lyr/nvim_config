return {
  'dbakker/vim-projectroot',
  lazy = true,
  config = function()
    vim.g.rootmarkers = {
      '.git',
    }
    vim.api.nvim_create_autocmd({ 'BufEnter', }, {
      callback = function()
        pcall(vim.call, 'ProjectRootCD')
      end,
    })
  end,
}
