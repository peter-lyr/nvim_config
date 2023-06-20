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
  local temp = vim.fn.fnamemodify(projectroot, ':t')
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
        max_length = function()
          local l = 0
          local sta
          local tmp
          for _, v in ipairs(vim.api.nvim_list_tabpages()) do
            sta, tmp = pcall(vim.api.nvim_tabpage_get_var, v, 'tabname')
            if sta == true then
              l = l + #tmp + 4
            else
              l = l + 15 + 4
            end
          end
          return vim.o.columns - l - 2
        end,
        filetype_names = {
          ['neo-tree'] = 'Neo Tree',
          ['lazy'] = 'Lazy',
        },
        use_mode_colors = true,
        buffer_filter = function(b)
          if #projectroot == 0 then
            return true
          end
          return #vim.api.nvim_buf_get_name(b) > 0 and vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(b)) == projectroot
        end,
      },
    },
    lualine_z = {
       {
        'tabs',
        max_length = function()
          return vim.o.columns
        end,
        use_mode_colors = true,
        mode = 2,
      },
    },
  }
})

-- number go tab or buffer

local lasttabnr = vim.fn['tabpagenr']()

vim.api.nvim_create_autocmd({ "TabLeave", }, {
  callback = function()
    lasttabnr = vim.fn.tabpagenr()
  end,
})

local function go_tab()
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
end

local function go_buffer()
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
end

vim.keymap.set({ 'n', 'v', }, '<f8>', go_tab, { desc = 'go tab' })
vim.keymap.set({ 'n', 'v', }, '<f2>', go_tab, { desc = 'go tab' })

vim.keymap.set({ 'n', 'v', }, '<f7>', go_buffer, { desc = 'go buffer' })
vim.keymap.set({ 'n', 'v', }, '<f1>', go_buffer, { desc = 'go buffer' })

-- go next or prev tab or buffer

vim.keymap.set({ 'n', 'v', }, '<bs>', function()
  local tabs = vim.fn.tabpagenr('$')
  local curtab = vim.fn.tabpagenr()
  local nexttab = curtab + 1 <= tabs and curtab + 1 or 1
  vim.cmd("tabn " .. nexttab)
end, { desc = 'next tab' })

vim.keymap.set({ 'n', 'v', }, '<c-bs>', function()
  local curtab = vim.fn.tabpagenr()
  local prevtab = curtab - 1 >= 1 and curtab - 1 or vim.fn.tabpagenr('$')
  vim.cmd("tabn " .. prevtab)
end, { desc = 'prev tab' })

vim.keymap.set({ 'n', 'v', }, '<c-h>', function()
  local buffers = require('lualine.components.buffers').bufpos2nr
  local curbufnr = vim.fn.bufnr()
  local curbufnr_idx = vim.fn.indexof(buffers, string.format('v:val == %d', curbufnr)) + 1
  if curbufnr_idx >= 1 then
   local prevbufnr = buffers[curbufnr_idx - 1 >= 1 and curbufnr_idx - 1 or #buffers]
   vim.cmd('b' .. prevbufnr)
  end
end, { desc = 'prev buffer' })

vim.keymap.set({ 'n', 'v', }, '<c-l>', function()
  local buffers = require('lualine.components.buffers').bufpos2nr
  local curbufnr = vim.fn.bufnr()
  local curbufnr_idx = vim.fn.indexof(buffers, string.format('v:val == %d', curbufnr)) + 1
  if curbufnr_idx >= 1 then
    local nextbufnr = buffers[curbufnr_idx + 1 <= #buffers and curbufnr_idx + 1 or 1]
    vim.cmd('b' .. nextbufnr)
  end
end, { desc = 'next buffer' })

-- Bdelete next or prev buffer

vim.keymap.set({ 'n', 'v', }, '<c-s-h>', function()
  local buffers = require('lualine.components.buffers').bufpos2nr
  local curbufnr = vim.fn.bufnr()
  local curbufnr_idx = vim.fn.indexof(buffers, string.format('v:val == %d', curbufnr)) + 1
  if curbufnr_idx >= 1 then
    local prevbufnr_idx = curbufnr_idx - 1 >= 1 and curbufnr_idx - 1 or #buffers
    if prevbufnr_idx ~= curbufnr_idx then
      local prevbufnr = buffers[prevbufnr_idx]
      vim.cmd('Bdelete! ' .. vim.api.nvim_buf_get_name(prevbufnr))
      require('lualine').refresh()
    end
  end
end, { desc = 'Bdelele prev buffer' })

vim.keymap.set({ 'n', 'v', }, '<c-s-l>', function()
  local buffers = require('lualine.components.buffers').bufpos2nr
  local curbufnr = vim.fn.bufnr()
  local curbufnr_idx = vim.fn.indexof(buffers, string.format('v:val == %d', curbufnr)) + 1
  if curbufnr_idx >= 1 then
    local nextbufnr_idx = curbufnr_idx + 1 <= #buffers and curbufnr_idx + 1 or 1
    if nextbufnr_idx ~= curbufnr_idx then
      local nextbufnr = buffers[nextbufnr_idx]
      vim.cmd('Bdelete! ' .. vim.api.nvim_buf_get_name(nextbufnr))
      require('lualine').refresh()
    end
  end
end, { desc = 'Bdelele next buffer' })

-- Bdelete next or prev tab

vim.keymap.set({ 'n', 'v', }, '<c-f7>', function()
  local tabs = vim.fn.tabpagenr('$')
  if tabs == 1 then
    return
  end
  local curtab_idx = vim.fn.tabpagenr()
  local prevtab_idx = curtab_idx - 1 >= 1 and curtab_idx - 1 or tabs
  vim.cmd(prevtab_idx .. 'tabclose!')
  require('lualine').refresh()
end, { desc = 'tabclose prev tab' })

vim.keymap.set({ 'n', 'v', }, '<c-f8>', function()
  local tabs = vim.fn.tabpagenr('$')
  if tabs == 1 then
    return
  end
  local curtab_idx = vim.fn.tabpagenr()
  local nexttab_idx = curtab_idx + 1 <= tabs and curtab_idx + 1 or 1
  vim.cmd(nexttab_idx .. 'tabclose!')
  require('lualine').refresh()
end, { desc = 'tabclose next tab' })

-- auto change dir root

vim.api.nvim_create_autocmd({ "TabEnter", }, {
  callback = function()
    vim.cmd('ProjectRootCD')
  end,
})
