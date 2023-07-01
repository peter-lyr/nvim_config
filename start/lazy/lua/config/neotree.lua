vim.g.neo_tree_remove_legacy_commands = 1

local cc = require("neo-tree.sources.common.commands")
local utils = require("neo-tree.utils")
local fs = require("neo-tree.sources.filesystem")
local manager = require("neo-tree.sources.manager")
local refresh = utils.wrap(manager.refresh, "buffers")

require('neo-tree').setup({
  open_files_do_not_replace_types = { "qf", },
  window = {
    mappings = {
      ["<space>"] = "none",
      ["P"] = 'noop',
      ["s"] = "noop",
      ["S"] = "noop",
      ["t"] = "noop",
      ["<"] = "noop",
      [">"] = "noop",
      ["d"] = "noop",
      ["z"] = "noop",
      ["C"] = "noop",
      ["R"] = "noop",
      ["<bs>"] = "noop",
      ["e"] = "noop",

      ["h"] = { "toggle_preview", config = { use_float = true } },
      ["<tab>"] = function(state)
        local winid = vim.fn.win_getid()
        cc.open(state, utils.wrap(fs.toggle_directory, state))
        vim.fn.win_gotoid(winid)
      end,
      ["dj"] = "open_split",
      ["dl"] = "open_vsplit",
      ["dk"] = "open_tabnew",
      ["D"] = "delete",
      ["do"] = "open",
      ["o"] = "open",
      ["zm"] = "close_node",
      ["zM"] = "close_all_nodes",
      ["<F5>"] = "refresh",
      ["<c-r>"] = "refresh",
      ["u"] = "navigate_up",

      ["q"] = "noop",
      ["X"] = "cut_to_clipboard",
      ["x"] = function(state)
        local node = state.tree:get_node()
        if node.type ~= 'message' then
          vim.fn.system('start ' .. node.path)
        end
      end,
      ["<f1>"] = function(state)
        local node = state.tree:get_node()
        print(vim.inspect(node))
      end,
      ["<leader>y"] = function(state)
        local node = state.tree:get_node()
        if node.type ~= 'message' then
          vim.cmd(string.format([[let @+ = '%s']], node.name))
        end
      end,
      ["<leader>gy"] = function(state)
        local node = state.tree:get_node()
        if node.type ~= 'message' then
          vim.cmd(string.format([[let @+ = '%s']], node.path))
        end
      end,
      ["<leader><leader>gy"] = function(state)
        vim.cmd(string.format([[let @+ = '%s']], state.path))
      end,
    },
  },
  filesystem = {
    window = {
      mappings = {
        ["[g"] = "noop",
        ["]g"] = "noop",
        ["H"] = "noop",
        ["<c-x>"] = "noop",

        ["<leader>k"] = "prev_git_modified",
        ["<leader>j"] = "next_git_modified",
        ["."] = "toggle_hidden",
        ["O"] = "set_root",
        ["F"] = "clear_filter",
        ['dd'] = function(state)
          local node = state.tree:get_node()
          if node.type == 'file' and vim.fn.bufnr(node.path) ~= -1 then
            vim.cmd('Bdelete! ' .. node.path)
            refresh()
          end
        end,
      },
    },
  },
  buffers = {
    window = {
      mappings = {
        ["O"] = "set_root",
        ['dd'] = function(state)
          local node = state.tree:get_node()
          if node then
            if node.type == "message" then
              return
            end
            if node.extra and node.extra.bufnr then
              vim.cmd('Bdelete! ' .. node.extra.bufnr)
            end
          end
          refresh()
        end,
        ["q"] = "noop",
        ["<tab>"] = function(state)
          local node = state.tree:get_node()
          if node.type == 'file' then
            local winid = vim.fn.win_getid()
            cc.open(state, utils.wrap(fs.toggle_directory, state))
            vim.fn.win_gotoid(winid)
          end
        end,
      },
    },
  },
  git_status = {
    window = {
      mappings = {
        ["gu"] = "noop",
        ["ga"] = "noop",
        ["gr"] = "noop",
        ["gc"] = "noop",
        ["gp"] = "noop",
        ["gg"] = "noop",
        ["u"] = "noop",

        ["du"] = "git_unstage_file",
        ["da"] = "git_add_file",
        ["dr"] = "git_revert_file",
        ["dc"] = "git_commit",
        ["dp"] = "git_push",
        ["dg"] = "git_commit_and_push",
        ["q"] = "noop",
        ["<tab>"] = function(state)
          local node = state.tree:get_node()
          if node.type == 'file' then
            local winid = vim.fn.win_getid()
            cc.open(state, utils.wrap(fs.toggle_directory, state))
            vim.fn.win_gotoid(winid)
          end
        end,
      }
    }
  },
})
