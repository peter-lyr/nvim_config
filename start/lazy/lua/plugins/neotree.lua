return {
  'nvim-neo-tree/neo-tree.nvim',
  lazy = true,
  branch = 'v2.x',
  tag = '2.66',
  pin = true,
  event = { "BufReadPost", "BufNew", "BufNewFile",  },
  cmd = {
    'Neotree',
  },
  keys = {
    { '<leader>q',     '<cmd>Neotree reveal_force_cwd filesystem<cr>', mode = { 'n', 'v' }, desc = 'NeoTree open filesystem' },
    { '<leader><tab>', '<cmd>Neotree reveal_force_cwd git_status<cr>', mode = { 'n', 'v' }, desc = 'NeoTree open git_status' },
    { '<leader>`',     '<cmd>Neotree reveal_force_cwd buffers<cr>',    mode = { 'n', 'v' }, desc = 'NeoTree open buffers' },
  },
  dependencies = {
    require('wait.plenary'),
    require('wait.web-devicons'),
    'MunifTanjim/nui.nvim',
    {
      's1n7ax/nvim-window-picker',
      config = function()
        require('window-picker').setup({
          filter_rules = {
            bo = {
              filetype = { 'aerial', 'neo-tree', 'notify' },
              buftype = { 'terminal' },
            },
            file_path_contains = {
              'edgy://',
            },
          }
        })
      end
    },
    require('wait.bbye'),
  },
  config = function()
    require('config.neotree')
  end
}
