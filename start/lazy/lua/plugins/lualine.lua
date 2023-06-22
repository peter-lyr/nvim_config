return {
  -- 'nvim-lualine/lualine.nvim',
  -- 'peter-lyr/lualine.nvim',
  'phi-mah/lualine.nvim',
  branch = 'filterbuffers',
  event = "VeryLazy",
  dependencies = {
    require('wait.web-devicons'),
    require('wait.projectroot'),
    require('wait.noice'),
  },
  config = function()
    require('config.lualine')
  end
}
