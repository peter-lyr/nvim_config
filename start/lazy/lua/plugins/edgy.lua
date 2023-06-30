return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  opts = {
    left = {
      {
        title = "Neo-Tree",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "filesystem"
        end,
        pinned = true,
        open = function()
          vim.api.nvim_input("<esc><space>1")
        end,
        size = { height = 0.5 },
      },
      {
        title = "Neo-Tree Buffers",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "buffers"
        end,
        pinned = true,
        open = "Neotree position=top buffers",
      },
      {
        title = "Neo-Tree Git",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "git_status"
        end,
        pinned = true,
        open = "Neotree position=right git_status",
      },
    },
    right = {
      {
        title = "Aerial",
        ft = "aerial",
        filter = function(buf)
          return vim.b[buf].source_buffer
        end,
        pinned = true,
        open = function()
          vim.api.nvim_input("<esc><space>4")
        end,
      },
    },
    keys = {
      ["<leader>wu"] = function(win)
        win:resize("width", 30)
      end,
      ["<leader>wo"] = function(win)
        win:resize("width", -30)
      end,
      ["<leader>wi"] = function(win)
        win.view.edgebar:equalize()
      end,
    },
  }
}
