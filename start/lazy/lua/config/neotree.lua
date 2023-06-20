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
      ["do"] = "open",
      ["o"] = "open",
      ["zm"] = "close_node",
      ["zM"] = "close_all_nodes",
      ["<F5>"] = "refresh",
      ["<c-r>"] = "refresh",
      ["q"] = function()
        vim.api.nvim_win_set_width(0, 0)
        vim.cmd('wincmd l')
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
            vim.cmd('Bdelete! ' .. vim.api.nvim_buf_get_name(node.extra.bufnr))
          end
          refresh()
        end,
        ["q"] = function()
          vim.api.nvim_win_set_width(0, 0)
          vim.cmd('wincmd h')
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
        ["q"] = function()
          vim.api.nvim_win_set_width(0, 0)
          vim.cmd('wincmd h')
        end,
      }
    }
  },
})

local M = {}

local function find_neotree_winid(source_ft)
  for _, bufnr in ipairs(vim.fn.tabpagebuflist()) do
    if vim.fn.getbufvar(bufnr, '&filetype') == 'neo-tree' then
      if string.match(vim.api.nvim_buf_get_name(bufnr), 'neo%-tree ' .. source_ft .. ' %[%d+%]') then
        return vim.fn.bufwinid(bufnr)
      end
    end
  end
  return nil
end


-- filesystem

M.filesystem_open = function()
  local winid = find_neotree_winid('filesystem')
  if winid then
    vim.fn.win_gotoid(winid)
    vim.cmd('wincmd H')
    vim.api.nvim_win_set_width(0, require('neo-tree').config.window.width)
  else
    vim.cmd('Neotree filesystem focus reveal_force_cwd')
  end
end

-- buffers git_status

M.git_status_buffers_open = function()
  local buffers_winid = find_neotree_winid('buffers')
  local git_status_winid = find_neotree_winid('git_status')
  if not git_status_winid and not buffers_winid then
    vim.cmd('Neotree git_status focus reveal_force_cwd right')
  end
  local fname = vim.api.nvim_buf_get_name(0)
  if vim.bo.ft == 'neo-tree' then
    if git_status_winid then
      vim.cmd('Neotree buffers focus reveal_force_cwd right')
    else
      vim.cmd('Neotree git_status focus reveal_force_cwd right')
    end
  else
    if git_status_winid then
      vim.fn.win_gotoid(git_status_winid)
      vim.cmd('wincmd L')
      vim.api.nvim_win_set_width(0, require('neo-tree').config.window.width)
    else
      vim.fn.win_gotoid(buffers_winid)
      vim.cmd('wincmd L')
      vim.api.nvim_win_set_width(0, require('neo-tree').config.window.width)
    end
  end
end

-- open close

M.open = function()
  M.filesystem_open()
  M.git_status_buffers_open()
end

M.close = function()
  vim.cmd([[call feedkeys("\<space>qq\<space>\<tab>q")]])
end

return M
