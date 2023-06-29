local data_path = require("plenary.path"):new(vim.fn.expand("$VIMRUNTIME")):joinpath("pack", "data")

if not data_path:exists() then
  vim.fn.mkdir(data_path.filename)
end

local parser_path = data_path:joinpath("treesitter-parser")

if not parser_path:exists() then
  vim.fn.mkdir(parser_path.filename)
end

vim.opt.runtimepath:append(parser_path.filename)

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    'c',
    'python',
    'vim', 'lua',
    'markdown', 'markdown_inline',
  },
  sync_install = false,
  auto_install = false,
  parser_install_dir = parser_path.filename,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "qi",
      node_incremental = "qi",
      scope_incremental = "qu",
      node_decremental = "qo",
    },
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
  matchup = {
    enable = true,
  },
})

require"rainbow.internal".defhl()

require("treesitter-context").setup({
  max_lines = 0,
})

require("match-up").setup({})

-- solve diffview close err

if package.loaded['plugins.diffview'] then
  vim.api.nvim_create_autocmd({ "TabClosed", "TabEnter", }, {
    callback = function()
      vim.loop.new_timer():start(50, 0, function()
        vim.schedule(function()
          if string.match(vim.bo.ft, "Diffview") or vim.opt.diff:get() == true then
            vim.cmd('TSDisable rainbow')
          else
            vim.cmd('TSEnable rainbow')
          end
        end)
      end)
    end,
  })
end
