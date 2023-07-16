return {
  'echasnovski/mini.indentscope',
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "help",
        "NvimTree",
        "fugitive",
        "lazy",
        "mason",
        "notify",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
    vim.api.nvim_create_autocmd("BufReadPre", {
      callback = function(ev)
        local max_filesize = 1000 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
        if ok and stats and stats.size > max_filesize then
          vim.b.miniindentscope_disable = true
        end
      end,
    })
  end,
  config = function()
    require('mini.indentscope').setup({
      symbol = "│",
      options = { try_as_border = true },
    })
  end,
}
