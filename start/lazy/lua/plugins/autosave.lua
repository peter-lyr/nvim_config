return {
  'Pocco81/auto-save.nvim',
  lazy = true,
  event = { 'InsertEnter', 'TextChanged', },
  config = function()
    require 'auto-save'.setup {
      execution_message = {
        message = function()
          -- return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
          return ''
        end,
      },
    }
  end,
}
