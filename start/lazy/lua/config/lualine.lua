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

local projectroot = vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0))

local function get_projectroot()
  temp = vim.fn.fnamemodify(projectroot, ':t')
  if #temp >= 15 then
    return string.sub(temp, 1, 7) .. '…' .. string.sub(temp, #temp-6, #temp)
  end
  return temp
end

vim.api.nvim_create_autocmd({ "BufEnter", }, {
  callback = function()
    projectroot = vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0))
    if #projectroot > 0 then
      vim.fn['LualineRenameTab'](get_projectroot())
    end
  end,
})

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
        cond = function ()
          return vim.g.GuiWindowFullScreen == 1
        end
      },
      'filesize',
      {
        function()
          return vim.fn.strftime('%Y-%m-%d %A')
        end,
        cond = function ()
          return vim.g.GuiWindowFullScreen == 1
        end
      },
      {
        function()
          return string.gsub(vim.loop.cwd(), '\\', '/')
        end,
        cond = function ()
          return vim.g.GuiWindowFullScreen == 1
        end
      },
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
      {
        '%m%r',
        cond = function()
          return vim.bo.modifiable == false or vim.bo.readonly == true
        end
      },
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
  tabline = {
    lualine_a = {
      {
        'buffers',
        mode = 2,
        filetype_names = {
          ['neo-tree'] = 'Neo Tree',
          ['lazy'] = 'Lazy',
        },
        use_mode_colors = true,
        buffer_filter = function(b)
          if #projectroot == 0 then
            return true
          end
          return vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(b)) == projectroot
        end,
      },
    },
    lualine_z = {
       {
        'tabs',
        use_mode_colors = true,
        mode = 2,
      },
    },
  }
})

local lasttabnr = vim.fn['tabpagenr']()

vim.api.nvim_create_autocmd({ "TabLeave", }, {
  callback = function()
    lasttabnr = vim.fn.tabpagenr()
  end,
})

vim.keymap.set({ 'n', 'v', }, '<f8>', function()
  if vim.v.count == 0 then
    vim.cmd("tabn " .. lasttabnr)
    return
  end
  local tabs = vim.fn.tabpagenr('$')
  if vim.v.count > tabs then
    vim.cmd('tabn ' .. tabs)
  else
    vim.cmd('tabn ' .. vim.v.count)
  end
end, { desc = 'go tab' })

vim.keymap.set({ 'n', 'v', }, '<f7>', function()
  if vim.v.count == 0 then
    vim.cmd([[call feedkeys("\<c-6>")]])
    return
  end
  local buffers = require('lualine.components.buffers').bufpos2nr
  if vim.v.count > #buffers then
    vim.cmd('LualineBuffersJump! ' .. #buffers)
  else
    vim.cmd('LualineBuffersJump! ' .. vim.v.count)
  end
end, { desc = 'go buffer' })
