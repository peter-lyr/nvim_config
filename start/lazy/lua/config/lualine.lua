local filename = function(hl_group)
  local fname = string.gsub(vim.fn.expand('%:~:.'), '\\', '/')
  local ext = vim.fn.fnamemodify(fname, ":e")
  local head = vim.fn.fnamemodify(fname, ":h")
  local tail = vim.fn.fnamemodify(fname, ":t")
  local icons = require('nvim-web-devicons').get_icons()[ext]
  local opt = { fg = icons and icons['color'] or '#ffffff', bold = true }
  vim.api.nvim_set_hl(0, hl_group, opt)
  if head == '.' then
    return string.format('%%#%s#%s', hl_group, tail)
  else
    return string.format('%s/%%#%s#%s', head, hl_group, tail)
  end
end

require('lualine').setup({
  options = {
    ignore_focus = {
      'neo-tree',
      'lazy',
    },
    component_separators = {
      left = "",
      right = ""
    },
    section_separators = {
      left = "",
      right = ""
    },
    globalstatus = false,
  },
  sections = {
    lualine_c = {
      {
        function()
          return string.format('%dM', vim.loop.resident_set_memory() / 1024 / 1024)
        end,
      },
      'filesize',
      {
        function()
          return filename('lualine_fname_tail_active')
        end,
        cond = function()
          return #vim.fn.expand('%:~:.') > 0
        end,
      },
      {
        "filetype",
        icon_only = true,
      },
    },
    lualine_x = {
      {
        function()
          return require("noice").api.status.command.get()
        end,
        cond = function()
          return package.loaded["noice"] and require("noice").api.status.command.has()
        end,
      },
      {
        function()
          return 'recording @' .. vim.fn.reg_recording()
        end,
        cond = function()
          return #vim.fn.reg_recording() > 0
        end,
      },
    },
    lualine_y = {
      'encoding',
      'fileformat',
      {
        "progress",
        separator = " ",
        padding = {
          left = 1,
          right = 0,
        },
      },
      {
        "location",
        padding = {
          left = 0,
          right = 1,
        },
      },
    },
    lualine_z = {
      function()
        return " " .. os.date("%R")
      end,
    },
  },
  inactive_sections = {
    lualine_c = {
      {
        function()
          return filename('lualine_fname_tail_inactive')
        end,
        cond = function()
          return #vim.fn.expand('%:~:.') > 0
        end,
      },
    },
    lualine_x = {
      {
        "filetype",
        icons_enabled = false,
      },
    },
  },
})
