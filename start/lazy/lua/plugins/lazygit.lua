return {
  "kdheepak/lazygit.nvim",
  lazy = true,
  keys = {
    '<leader>gl',
    '<leader>gc',
    '<leader>gf',
    '<leader>gC',

    '<leader>gL',
    '<leader>gt',
  },
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim"
  },
  config = function()
    require("config.lazygit")
  end,
}
