return {
  'chentoast/marks.nvim',
  lazy = true,
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require'marks'.setup {
      default_mappings = false,
      builtin_marks = { ".", "<", ">", "^" },
      cyclic = false,
      force_write_shada = true,
      refresh_interval = 250,
      sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
      excluded_filetypes = {},
      mappings = {
        toggle = "mm",
        set_next = "m,",
        delete_line = "md",
        delete_buf = "mx",
        next = "ms",
        prev = "mw",
        annotate = "ma",
      }
    }
    vim.keymap.set({ 'n', 'v', }, 'mq', '<cmd>MarksQFListBuf<cr>', { desc = 'MarksQFListBuf' })
    vim.keymap.set({ 'n', 'v', }, 'ma', '<cmd>MarksQFListAll<cr>', { desc = 'MarksQFListAll' })
  end,
}
