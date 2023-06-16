vim.g.neo_tree_remove_legacy_commands = 1

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

      ["<tab>"] = { "toggle_preview", config = { use_float = true } },
      ["dj"] = "open_split",
      ["dl"] = "open_vsplit",
      ["dk"] = "open_tabnew",
      ["D"] = "delete",
      ["<c-h>"] = "prev_source",
      ["<c-l>"] = "next_source",
      ["do"] = "open",
      ["o"] = "open",
    },
  },
  filesystem = {
    window = {
      mappings = {
        ["q"] = "noop",
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
        ["dd"] = "buffer_delete",
        ["O"] = "set_root",
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
  -- source_selector = {
  --   winbar = true,
  --   statusline = false,
  -- }
})

-- vim.api.nvim_create_autocmd({ 'BufEnter', }, {
--   callback = function()
--     local cwd = require('neo-tree.git').get_repository_root(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h'))
--     if #cwd > 0 and vim.loop.cwd() ~= cwd then
--       vim.cmd('cd ' .. cwd)
--     end
--   end,
-- })
