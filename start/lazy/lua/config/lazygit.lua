require 'telescope'.load_extension 'lazygit'

require 'which-key'.register { ['<leader>gl'] = { name = 'LazyGit', }, }
