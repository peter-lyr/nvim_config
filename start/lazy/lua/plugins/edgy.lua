return {
  "folke/edgy.nvim",
  lazy = true,
  event = { "BufReadPost", "BufNew", "BufNewFile", },
  opts = {
    animate = {
      enabled = false,
    },
    left = {
      {
        title = "Nvim-Tree",
        ft = "NvimTree",
        pinned = true,
        open = function()
          vim.api.nvim_input("<esc><space>q")
        end,
        size = { height = 0.8 },
      },
      {
        title = "Fugitive",
        ft = "fugitive",
        pinned = true,
        size = { height = 0.38 },
        open = "Git",
      },
    },
    right = {
      {
        title = "Minimap",
        ft = "minimap",
        pinned = true,
        open = function()
          vim.api.nvim_input("<esc><space>3")
        end,
        size = { height = 0.38 },
      },
      {
        title = "Aerial",
        ft = "aerial",
        pinned = true,
        open = "AerialOpen",
      },
    },
    bottom = {
      {
        title = "QuickFix",
        ft = "qf",
        pinned = true,
        open = function()
          vim.api.nvim_input("<esc><space>m")
        end,
        size = { height = 10 },
      },
    },
    keys = {
      ["<a-l>"] = function(win)
        win:resize("width", 10)
      end,
      ["<a-h>"] = function(win)
        win:resize("width", -10)
      end,
      ["<a-k>"] = function(win)
        win:resize("height", 15)
      end,
      ["<a-j>"] = function(win)
        win:resize("height", -15)
      end,
      ["<a-i>"] = function(win)
        win.view.edgebar:equalize()
      end,
      ["<leader>we"] = function(win)
        win.view.edgebar:equalize()
      end,
    },
  }
}
