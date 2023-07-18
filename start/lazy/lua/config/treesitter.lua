local data_path = require("plenary.path"):new(vim.fn.expand("$VIMRUNTIME")):joinpath("pack", "data")

if not data_path:exists() then
  vim.fn.mkdir(data_path.filename)
end

local parser_path = data_path:joinpath("treesitter-parser")

if not parser_path:exists() then
  vim.fn.mkdir(parser_path.filename)
end

vim.opt.runtimepath:append(parser_path.filename)

-- local disable = function(lang, buf)
local disable = function(_, buf)
  local max_filesize = 1000 * 1024
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
end

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
    disable = disable,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = disable,
  },
  incremental_selection = {
    enable = true,
    disable = disable,
    keymaps = {
      init_selection = "qi",
      node_incremental = "qi",
      scope_incremental = "qu",
      node_decremental = "qo",
    },
  },
  rainbow = {
    enable = true,
    disable = disable,
    extended_mode = true,
    max_file_lines = nil,
  },
  matchup = {
    enable = true,
    disable = disable,
  },
})

require "rainbow.internal".defhl()

require("treesitter-context").setup({
  on_attach = function()
    local max_filesize = 1000 * 1024
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > max_filesize then
      return false
    end
    return true
  end
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
