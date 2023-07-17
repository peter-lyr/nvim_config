return {
  "nvim-neorg/neorg",
  lazy = true,
  build = ":Neorg sync-parsers",
  dependencies = {
    require('wait.plenary'),
    require('plugins.treesitter'),
  },
  config = function()
    require("neorg").setup {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
            },
          },
        },
      },
    }
  end,
}
