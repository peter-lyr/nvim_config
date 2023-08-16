local filename = function(hl_group)
  local fname = string.gsub(vim.fn.expand('%:~:.'), '\\', '/')
  local ext = vim.fn.fnamemodify(fname, ":e")
  local head = vim.fn.fnamemodify(fname, ":h")
  head = string.gsub(head, '%%', '%%%%')
  local tail = vim.fn.fnamemodify(fname, ":t")
  tail = string.gsub(tail, '%%', '%%%%')
  local icons = require('nvim-web-devicons').get_icons()[ext]
  local opt = { fg = icons and icons['color'] or '#ffffff', bold = true }
  vim.api.nvim_set_hl(0, hl_group, opt)
  if head == '.' then
    return string.format('%%#%s#%s', hl_group, tail)
  else
    return string.format('%s/%%#%s#%s', head, hl_group, tail)
  end
end

local function rep(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '/', '\\')
  return content
end

local curprojectroot = rep(vim.loop.cwd())

local function get_projectroot(projectroot)
  local temp = vim.fn.tolower(vim.fn.fnamemodify(projectroot, ':t'))
  if #temp >= 15 then
    local s1 = ''
    local s2 = ''
    for i = 15, 3, -1 do
      s2 = string.sub(temp, #temp - i, #temp)
      if vim.fn.strdisplaywidth(s2) <= 7 then
        break
      end
    end
    for i = 15, 3, -1 do
      s1 = string.sub(temp, 1, i)
      if vim.fn.strdisplaywidth(s1) <= 7 then
        break
      end
    end
    return s1 .. '…' .. s2
  end
  return temp
end

function Tabname()
  curprojectroot = rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  if #curprojectroot > 0 then
    vim.fn['LualineRenameTab'](get_projectroot(curprojectroot))
  else
    vim.fn['LualineRenameTab'](get_projectroot(vim.api.nvim_buf_get_name(0)))
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", }, {
  callback = function()
    Tabname()
  end,
})

local ignore_focus = {
  ['aerial'] = 'Aerial',
  ['minimap'] = 'Minimap',
  ['NvimTree'] = 'NvimTree',
  ['fugitive'] = 'Fugitive',
  ['lazy'] = 'Lazy',
  ['qf'] = 'QuickFix List',
}

local function check_ft(ft)
  return vim.tbl_contains(vim.tbl_keys(ignore_focus), ft) == false
end

require('lualine').setup({
  options = {
    ignore_focus = vim.tbl_keys(ignore_focus),
    globalstatus = false,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_c = {
      {
        function()
          return string.format("%dM", vim.loop.resident_set_memory() / 1024 / 1024)
        end
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
          return vim.fn.strftime('%Y-%m-%d %A')
        end,
      },
      {
        function()
          return string.gsub(vim.loop.cwd(), '\\', '/')
        end,
        cond = function()
          return vim.o.columns > 200
        end
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
    lualine_c = {
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
              l = l + vim.fn.strdisplaywidth(tmp) + 4
            else
              l = l + 15 + 4
            end
          end
          return vim.o.columns - l - 1
        end,
        filetype_names = ignore_focus,
        use_mode_colors = false,
        buffers_color = {
          active = function()
            local path = vim.fn.bufname()
            local ext = string.match(path, "%.([^.]+)$")
            local ic, color = require("nvim-web-devicons").get_icon_color(path.filename, ext)
            if ic then
              return { fg = color, bg = '#234567', gui = 'bold' }
            end
            return { fg = 'white', bg = '#234567', gui = 'bold' }
          end,
          inactive = { fg = '#888888', bg = '#333333' },
        },
        show_buffers = function()
          local buffers = {}
          for _, b in ipairs(vim.api.nvim_list_bufs()) do
            local fname = vim.api.nvim_buf_get_name(b)
            if require('plenary.path').new(fname):exists() then
              if vim.fn.buflisted(b) ~= 0 and vim.api.nvim_buf_get_option(b, 'buftype') ~= 'quickfix' or vim.api.nvim_buf_get_option(b, 'buftype') == 'help' then
                if #curprojectroot == 0 or #fname > 0 and rep(vim.fn['ProjectRootGet'](fname)) == curprojectroot then
                  buffers[#buffers + 1] = b
                end
              end
            end
          end
          return buffers
        end,
      },
    },
    lualine_y = {
      {
        'tabs',
        max_length = function()
          return vim.o.columns
        end,
        fmt = get_projectroot,
        use_mode_colors = true,
        mode = 2,
        tabs_color = {
          active = function()
            local path = vim.fn.bufname()
            local ext = string.match(path, "%.([^.]+)$")
            local ic, color = require("nvim-web-devicons").get_icon_color(path.filename, ext)
            if ic then
              return { fg = color, gui = 'bold' }
            end
            return { fg = 'white', gui = 'bold' }
          end,
          inactive = { fg = 'gray' },
        },
      },
    },
  },
  winbar = {
    lualine_c = {
      {
        function()
          return filename('lualine_fname_tail_active')
        end,
        cond = function()
          return #vim.fn.expand('%:~:.') > 0 and check_ft(vim.bo.ft)
        end,
        color = { fg = '#834567', }
      },
      {
        function() return require("nvim-navic").get_location() end,
        cond = function()
          return package.loaded["nvim-navic"] and require("nvim-navic").is_available() and check_ft(vim.bo.ft)
        end,
      },
    },
    lualine_y = {
      {
        function()
          return get_projectroot(vim.call('ProjectRootGet'))
        end,
        cond = function()
          return #vim.fn.expand('%:~:.') > 0
        end,
      },
    },
    lualine_x = {
      {
        function()
          return vim.fn.bufnr('%')
        end,
        cond = function()
          return #vim.fn.expand('%:~:.') > 0
        end,
      },
    },
  },
  inactive_winbar = {
    lualine_c = {
      {
        function()
          return filename('lualine_fname_tail_active')
        end,
        cond = function()
          return #vim.fn.expand('%:~:.') > 0 and check_ft(vim.bo.ft)
        end,
        color = { fg = '#533547', }
      },
    },
    lualine_y = {
      {
        function()
          return get_projectroot(vim.call('ProjectRootGet'))
        end,
        cond = function()
          return #vim.fn.expand('%:~:.') > 0
        end,
      },
    },
    lualine_x = {
      {
        function()
          return vim.fn.bufnr('%')
        end,
        cond = function()
          return #vim.fn.expand('%:~:.') > 0
        end,
      },
    },
  },
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
    if lasttabnr <= vim.fn.tabpagenr('$') then
      vim.cmd("tabn " .. lasttabnr)
    end
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
  if vim.fn.buflisted(vim.fn.bufnr()) == 0 then
    pcall(vim.fn.win_gotoid, vim.g.lastbufwinid)
  end
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
vim.keymap.set({ 'n', 'v', }, '<leader>tt', go_tab, { desc = 'go tab' })

vim.keymap.set({ 'n', 'v', }, '<f7>', go_buffer, { desc = 'go buffer' })
vim.keymap.set({ 'n', 'v', }, '<f1>', go_buffer, { desc = 'go buffer' })
vim.keymap.set({ 'n', 'v', }, '<leader>bb', go_buffer, { desc = 'go buffer' })

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
    if prevbufnr_idx < curbufnr_idx then
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
    if nextbufnr_idx > curbufnr_idx then
      local nextbufnr = buffers[nextbufnr_idx]
      vim.cmd('Bdelete! ' .. vim.api.nvim_buf_get_name(nextbufnr))
      require('lualine').refresh()
    end
  end
end, { desc = 'Bdelele next buffer' })

-- Bdelete next or prev tab

vim.keymap.set({ 'n', 'v', }, '<c-f7>', function()
  local curtab_idx = vim.fn.tabpagenr()
  if curtab_idx == 1 then
    return
  end
  local tabs = vim.fn.tabpagenr('$')
  if tabs == 1 then
    return
  end
  local prevtab_idx = curtab_idx - 1 >= 1 and curtab_idx - 1 or tabs
  vim.cmd(prevtab_idx .. 'tabclose!')
  require('lualine').refresh()
end, { desc = 'tabclose prev tab' })

vim.keymap.set({ 'n', 'v', }, '<c-f8>', function()
  local curtab_idx = vim.fn.tabpagenr()
  local tabs = vim.fn.tabpagenr('$')
  if tabs == 1 or curtab_idx == tabs then
    return
  end
  local nexttab_idx = curtab_idx + 1 <= tabs and curtab_idx + 1 or 1
  vim.cmd(nexttab_idx .. 'tabclose!')
  require('lualine').refresh()
end, { desc = 'tabclose next tab' })

-- auto change dir root

vim.api.nvim_create_autocmd({ "TabEnter", }, {
  callback = function()
    pcall(vim.call, 'ProjectRootCD')
  end,
})

-- restore hidden tabs

vim.keymap.set({ 'n', 'v', }, '<a-f7>', function()
  local sta, tmp
  local tabs = {}
  local curtabnr = vim.fn.tabpagenr()
  for _, v in ipairs(vim.api.nvim_list_tabpages()) do
    sta, tmp = pcall(vim.api.nvim_tabpage_get_var, v, 'tabname')
    if sta == true then
      tabs[#tabs + 1] = tmp
    end
  end
  for b = 1, vim.fn.bufnr('$') do
    if vim.fn.buflisted(b) ~= 0 and vim.api.nvim_buf_get_option(b, 'buftype') ~= 'quickfix' then
      local fname = vim.fn.tolower(rep(vim.api.nvim_buf_get_name(b)))
      if #fname > 0 and vim.fn.filereadable(fname) == 1 then
        local tabname = get_projectroot(vim.fn['ProjectRootGet'](fname))
        if vim.tbl_contains(tabs, tabname) ~= true then
          vim.cmd('tabnew')
          vim.cmd('e ' .. fname)
          tabs[#tabs + 1] = tabname
          vim.fn['LualineRenameTab'](tabname)
        end
      end
    end
  end
  vim.cmd(curtabnr .. 'tabnext')
  tabs = {}
  local tabidxs = {}
  for k, v in ipairs(vim.api.nvim_list_tabpages()) do
    sta, tmp = pcall(vim.api.nvim_tabpage_get_var, v, 'tabname')
    if sta == true then
      if vim.tbl_contains(tabs, tmp) ~= true then
        tabs[#tabs + 1] = tmp
      else
        tabidxs[#tabidxs + 1] = k
      end
    end
  end
  for _, v in ipairs(vim.fn.reverse(tabidxs)) do
    vim.cmd(v .. 'tabclose')
  end
end, { desc = 'restore hidden tabs' })

vim.opt.laststatus = 3

vim.cmd([[
  function! LualineSwitchBuffer(bufnr, mouseclicks, mousebutton, modifiers)
    " echomsg '|' .. a:bufnr .. '|' .. a:mouseclicks .. '|' .. a:mousebutton .. '|' .. a:modifiers .. '|'
    if a:mousebutton == 'm' && a:mouseclicks == 1
      execute ":Bdelete! " . a:bufnr
    elseif a:mousebutton == 'l' && a:mouseclicks == 1
      if buflisted(bufnr()) == 0
        try
          call win_gotoid(g:lastbufwinid)
        catch
          echomsg 'error! see config/lualine.lua, g:lastbufwinid: ' .. g:lastbufwinid
          return
        endtry
      endif
      execute ":buffer " . a:bufnr
    endif
  endfunction
  function! LualineSwitchTab(tabnr, mouseclicks, mousebutton, modifiers)
    if a:mousebutton == 'm' && a:mouseclicks == 1
      execute a:tabnr . "tabclose"
    elseif a:mousebutton == 'l' && a:mouseclicks == 1
      execute a:tabnr . "tabnext"
    endif
  endfunction
]])



function Bdft(ftstring)
  local ftslist = {}
  for ft in string.gmatch(ftstring, "%a+") do
    table.insert(ftslist, ft)
  end
  local cwd = string.gsub(vim.loop.cwd(), '\\', '/')
  cwd = vim.fn.tolower(cwd)
  local curbufnr = vim.fn.bufnr()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local name = string.gsub(vim.api.nvim_buf_get_name(bufnr), '\\', '/')
    if name == '' or vim.fn.match(vim.fn.tolower(name), cwd) == -1 or bufnr == curbufnr then
      goto continue
    end
    local ft = string.match(name, "%.([^.]+)")
    if vim.tbl_contains(ftslist, ft) == true then
      vim.cmd('Bdelete! ' .. bufnr)
    end
    ::continue::
  end
end

vim.cmd([[
function Bdft(A, L, P)
  return g:bdfts
endfu
command! -complete=customlist,Bdft -nargs=* Bdft call v:lua.Bdft('<args>')
]])

vim.keymap.set({ 'n', 'v', }, '<leader>xf', function()
  local bdfts = {}
  local cwd = string.gsub(vim.fn.tolower(vim.loop.cwd()), '\\', '/')
  local curbufnr = vim.fn.bufnr()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local name = string.gsub(vim.api.nvim_buf_get_name(bufnr), '\\', '/')
    if name == '' or vim.fn.match(vim.fn.tolower(name), cwd) == -1 or bufnr == curbufnr then
      goto continue
    end
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.fn.filereadable(name) then
      local ft = string.match(name, "%.([^%.]+)")
      if ft and #ft > 0 and vim.tbl_contains(bdfts, ft) == false then
        table.insert(bdfts, ft)
      end
    end
    ::continue::
  end
  vim.g.bdfts = bdfts
  if #vim.g.bdfts == 0 then
    print('no other filetypes to bw')
    return
  end
  vim.cmd([[call feedkeys(":\<c-u>Bdft ")]])
end, { desc = 'Bdelete ft' })
