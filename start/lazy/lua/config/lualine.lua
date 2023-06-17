require('lualine').setup({
  options = {
    ignore_focus = {
      'neo-tree',
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
      'filesize',
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
    },
    lualine_x = {
      {
        function() return require("noice").api.status.command.get() end,
        cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
      },
      {
        function() return '@' .. vim.fn.reg_recording() end,
        cond = function() return #vim.fn.reg_recording() > 0 end,
      },
    },
    lualine_y = {
      'encoding',
      'fileformat',
      { "progress", separator = " ", padding = { left = 1, right = 0 } },
      { "location", padding = { left = 0, right = 1 } },
    },
    lualine_z = {
      function()
        return " " .. os.date("%R")
      end,
    },
  },
  inactive_sections = {
    lualine_c = {
      { "filename", path = 1, },
    },
    lualine_x = {
      { "filetype", icons_enabled = false },
    },
  },
})
