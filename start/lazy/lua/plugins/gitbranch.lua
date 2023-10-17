return {
  'itchyny/vim-gitbranch',
  lazy = true,
  keys = {
    { '<c-3>', function() require 'config.gitbranch'.getbranchname() end, mode = { 'c', 'i', }, silent = true, desc = 'paste branch name', },
  },
}
