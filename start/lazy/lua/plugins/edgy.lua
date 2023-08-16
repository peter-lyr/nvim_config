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
          vim.api.nvim_input("<esc><space>1")
        end,
        size = { height = 0.8 },
      },
      {
        title = "Fugitive",
        ft = "fugitive",
        pinned = true,
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
          vim.api.nvim_input("<esc>dm")
        end,
        size = { height = 10 },
      },
    },
    keys = {
      ["<a-l>"] = function(win)
        if win and win.width + 2 <= vim.o.columns then
          win:resize("width", 2)
        end
      end,
      ["<a-h>"] = function(win)
        if win and win.width - 2 >= require("edgy.config").layout.left.size then
          win:resize("width", -2)
        end
      end,
      ["<a-k>"] = function(win)
        if win and win.height + 5 <= vim.o.lines then
          win:resize("height", 5)
        end
      end,
      ["<a-j>"] = function(win)
        if win and win.height - 5 >= require("edgy.config").layout.bottom.size then
          win:resize("height", -5)
        end
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
