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
      -- {
      --   title = "Neo-Tree",
      --   ft = "neo-tree",
      --   filter = function(buf)
      --     return vim.b[buf].neo_tree_source == "filesystem"
      --   end,
      --   pinned = true,
      --   open = function()
      --     vim.api.nvim_input("<esc><space>1")
      --   end,
      --   size = { height = 0.8 },
      -- },
      -- {
      --   title = "Neo-Tree Git",
      --   ft = "neo-tree",
      --   filter = function(buf)
      --     return vim.b[buf].neo_tree_source == "git_status"
      --   end,
      --   pinned = true,
      --   open = "Neotree position=right git_status",
      -- },
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
        win:resize("width", 30)
      end,
      ["<a-h>"] = function(win)
        win:resize("width", -30)
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
