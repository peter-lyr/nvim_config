vim.g.neo_tree_remove_legacy_commands = 1

local utils = require("neo-tree.utils")
local manager = require("neo-tree.sources.manager")
local refresh = utils.wrap(manager.refresh, "buffers")

require('neo-tree').setup({
  window = {
    mappings = {
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

      ["<tab>"] = { "toggle_preview", config = { use_float = true } },
      ["dj"] = "open_split",
      ["dl"] = "open_vsplit",
      ["dk"] = "open_tabnew",
      ["D"] = "delete",
      ["<c-h>"] = "prev_source",
      ["<c-l>"] = "next_source",
      ["do"] = "open",
      ["o"] = "open",
      ["zm"] = "close_node",
      ["zM"] = "close_all_nodes",
      ["<F5>"] = "refresh",
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
            vim.cmd('Bdelete ' .. vim.api.nvim_buf_get_name(node.extra.bufnr))
          end
          refresh()
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

        ["u"] = "git_unstage_file",
        ["a"] = "git_add_file",
        ["r"] = "git_revert_file",
        ["c"] = "git_commit",
        ["p"] = "git_push",
        ["g"] = "git_commit_and_push",
      }
    }
  },
})

local M = {}

-- filesystem

M.filesystem_open = function()
  vim.cmd('Neotree filesystem focus reveal_force_cwd')
  if string.match(vim.api.nvim_buf_get_name(vim.fn.winbufnr(i)), 'neo%-tree filesystem %[%d+%]') then
    vim.cmd('wincmd H')
  end
  vim.api.nvim_win_set_width(0, require('neo-tree').config.window.width)
end

local get_filesystem_winid = function()
  for i=1, vim.fn.winnr('$') do
    if string.match(vim.api.nvim_buf_get_name(vim.fn.winbufnr(i)), 'neo%-tree filesystem %[%d+%]') then
      return vim.fn.win_getid(i)
    end
  end
  return 0
end

M.filesystem_min_width = function()
  local filesystem_winid = get_filesystem_winid()
  vim.api.nvim_win_set_width(filesystem_winid, 0)
  if filesystem_winid == vim.fn.win_getid() then
    vim.cmd('wincmd l')
  end
end

-- buffers git_status

M.going_to_buffers = nil

M.git_status_buffers_toggle = function()
  local fname = vim.api.nvim_buf_get_name(0)
  if string.match(fname, 'neo%-tree git_status %[%d+%]') or string.match(fname, 'neo%-tree buffers %[%d+%]') then
    if M.going_to_buffers then
      M.going_to_buffers = nil
      vim.cmd('Neotree git_status focus reveal_force_cwd right')
    else
      M.going_to_buffers = 1
      vim.cmd('Neotree buffers focus reveal_force_cwd right')
    end
  else
    if M.going_to_buffers then
      vim.cmd('Neotree buffers focus reveal_force_cwd right')
    else
      vim.cmd('Neotree git_status focus reveal_force_cwd right')
    end
  end
end

M.git_status_buffers_close = function()
  vim.cmd('Neotree git_status close')
  vim.cmd('Neotree buffers close')
end

-- open close

M.open = function()
  M.filesystem_open()
  vim.cmd('wincmd b')
  M.git_status_buffers_toggle()
end

M.close = function()
  M.git_status_buffers_close()
  M.filesystem_min_width()
end

return M
