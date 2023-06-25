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

      ["h"] = { "toggle_preview", config = { use_float = true } },
      ["<tab>"] = function(state)
        cc.open(state, utils.wrap(fs.toggle_directory, state))
        vim.cmd('wincmd h')
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
      ["q"] = function()
        vim.api.nvim_win_set_width(0, 0)
        vim.cmd('wincmd l')
      end,
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
        ["q"] = function()
          vim.api.nvim_win_set_width(0, 0)
          vim.cmd('wincmd h')
        end,
        ["<tab>"] = function(state)
          cc.open(state, utils.wrap(fs.toggle_directory, state))
          vim.cmd('wincmd l')
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
        ["<tab>"] = function(state, toggle_directory)
          local sta, _ = pcall(cc.open, state, utils.wrap(fs.toggle_directory, state))
          if not sta then
            cc.toggle_directory(state, toggle_directory)
            return
          end
          vim.cmd('wincmd l')
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
    local fname = vim.api.nvim_buf_get_name(0)
    if #fname > 0 and require('plenary.path'):new(fname):exists() then
      vim.cmd('Neotree filesystem focus reveal_force_cwd reveal_file=' .. fname)
    else
      vim.cmd('Neotree filesystem focus reveal_force_cwd')
    end
  end
end

M.filesystem_open_reveal = function()
  local fname = vim.api.nvim_buf_get_name(0)
  if #fname > 0 and require('plenary.path'):new(fname):exists() then
    vim.cmd('Neotree filesystem focus reveal_force_cwd reveal_file=' .. fname)
  else
    vim.cmd('Neotree filesystem focus reveal_force_cwd')
  end
  vim.api.nvim_win_set_width(0, require('neo-tree').config.window.width)
end

-- buffers git_status

M.git_status_buffers_open = function()
  local buffers_winid = find_neotree_winid('buffers')
  local git_status_winid = find_neotree_winid('git_status')
  if not git_status_winid and not buffers_winid then
    vim.cmd('Neotree git_status focus reveal_force_cwd right')
  end
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
  vim.cmd('wincmd h')
end

M.close = function()
  local filesystem_winid = find_neotree_winid('filesystem')
  if filesystem_winid and vim.api.nvim_win_get_width(filesystem_winid) > 1 then
    vim.cmd([[call feedkeys("\<space>qq")]])
  end
  local buffers_winid = find_neotree_winid('buffers')
  local git_status_winid = find_neotree_winid('git_status')
  if buffers_winid and vim.api.nvim_win_get_width(buffers_winid) > 1 or git_status_winid and vim.api.nvim_win_get_width(git_status_winid) > 1 then
    vim.cmd([[call feedkeys("\<space>\<tab>q")]])
  end
end

return M
