local filename = function(hl_group)
  local fname = string.gsub(vim.fn.expand '%:~:.', '\\', '/')
  local ext = vim.fn.fnamemodify(fname, ':e')
  local head = vim.fn.fnamemodify(fname, ':h')
  head = string.gsub(head, '%%', '%%%%')
  local tail = vim.fn.fnamemodify(fname, ':t')
  tail = string.gsub(tail, '%%', '%%%%')
  local icons = require 'nvim-web-devicons'.get_icons()[ext]
  local opt = { fg = icons and icons['color'] or '#ffffff', bold = true, }
  hl_group = hl_group .. '_' .. ext
  vim.api.nvim_set_hl(0, hl_group, opt)
  if head == '.' then
    return string.format('%%#%s#%s', hl_group, tail)
  else
    return string.format('%s/%%#%s#%s', head, hl_group, tail)
  end
end

vim.g.WinFixHeighEnTimer = 0
local winfixheight = -1

function WinFixHeighEn()
  pcall(vim.fn.timer_stop, vim.g.WinFixHeighEnTimer)
  if winfixheight ~= -1 then
    vim.opt.winfixheight = winfixheight
  end
  winfixheight = vim.opt.winfixheight:get()
  vim.cmd 'set winfixheight'
  return winfixheight
end

function WinFixHeighDis()
  vim.g.WinFixHeighEnTimer = vim.fn.timer_start(2000, function()
    vim.opt.winfixheight = winfixheight
    vim.g.WinFixHeighEnTimer = 0
  end)
end

function Buffer(bufnr)
  WinFixHeighEn()
  if type(bufnr) == 'string' then
    vim.cmd('e ' .. bufnr)
  else
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.cmd('b' .. tostring(bufnr))
    end
  end
  WinFixHeighDis()
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
  local updir = vim.fn.tolower(vim.fn.fnamemodify(projectroot, ':h:t'))
  if #updir >= 15 then
    local s1 = ''
    local s2 = ''
    for i = 15, 3, -1 do
      s2 = string.sub(updir, #updir - i, #updir)
      if vim.fn.strdisplaywidth(s2) <= 7 then
        break
      end
    end
    for i = 15, 3, -1 do
      s1 = string.sub(updir, 1, i)
      if vim.fn.strdisplaywidth(s1) <= 7 then
        break
      end
    end
    return s1 .. '…' .. s2
  end
  return updir .. '/' .. temp
end

function Tabname()
  curprojectroot = rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  if #curprojectroot > 0 then
    vim.fn['LualineRenameTab'](get_projectroot(curprojectroot))
  else
    vim.fn['LualineRenameTab'](get_projectroot(vim.api.nvim_buf_get_name(0)))
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', }, {
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

local Windows = require 'lualine.components.windows'
local Window = require 'lualine.components.windows.window'

--- Override to onl return ffers shown in the windows of the current tab
function Windows:buffers()
  local tabnr = vim.api.nvim_get_current_tabpage()
  local buffers = {}
  for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
    if not self:should_hide(winnr) and Window:is_current() then
      buffers[#buffers + 1] = self:new_buffer(winnr)
    end
  end
  return buffers
end

require 'lualine'.setup {
  options = {
    ignore_focus = vim.tbl_keys(ignore_focus),
    globalstatus = false,
    component_separators = { left = '', right = '', },
    section_separators = { left = '', right = '', },
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
          return filename 'lualine_'
        end,
        cond = function()
          return #vim.fn.expand '%:~:.' > 0
        end,
        on_click = function(mouseclicks, mousebutton, modifiers)
          if mousebutton == 'l' and mouseclicks == 1 then
            vim.cmd 'Minimap'
          elseif mousebutton == 'm' and mouseclicks == 1 then
            vim.cmd 'MinimapClose'
          end
        end,
      },
      {
        function() return require 'nvim-navic'.get_location() end,
        cond = function()
          return package.loaded['nvim-navic'] and require 'nvim-navic'.is_available() and check_ft(vim.bo.ft)
        end,
        on_click = function(mouseclicks, mousebutton, modifiers)
          if mousebutton == 'l' and mouseclicks == 1 then
            local winid = vim.fn.win_getid()
            vim.cmd 'AerialCloseAll'
            vim.cmd 'AerialOpen right'
            vim.fn.win_gotoid(winid)
            vim.fn.timer_start(10, function()
              vim.cmd 'wincmd ='
            end)
          elseif mousebutton == 'm' and mouseclicks == 1 then
            vim.cmd 'AerialCloseAll'
          end
        end,
      },
    },
    lualine_x = {
      {
        function()
          return require 'noice'.api.status.command.get()
        end,
        cond = function()
          return package.loaded['noice'] and require 'noice'.api.status.command.has()
        end,
      },
      {
        function()
          return vim.fn.strftime '%Y-%m-%d %A'
        end,
        color = { fg = '#833863', },
      },
      {
        function()
          return string.gsub(vim.loop.cwd(), '\\', '/')
        end,
        cond = function()
          return vim.o.columns > 200
        end,
        color = { fg = '#437863', },
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
        end,
      },
      'encoding',
      'fileformat',
      {
        'progress',
        separator = ' ',
        padding = {
          left = 1,
          right = 0,
        },
      },
      {
        'location',
        padding = {
          left = 0,
          right = 1,
        },
      },
    },
    lualine_z = {
      function()
        return ' ' .. os.date '%R'
      end,
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
              l = l + 30 + 4
            end
          end
          return vim.o.columns - l - 1
        end,
        filetype_names = ignore_focus,
        use_mode_colors = false,
        buffers_color = {
          active = function()
            local path = vim.fn.bufname()
            local ext = string.match(path, '%.([^.]+)$')
            local ic, color = require 'nvim-web-devicons'.get_icon_color(path.filename, ext)
            if ic then
              return { fg = color, bg = '#234567', gui = 'bold', }
            end
            return { fg = 'white', bg = '#234567', gui = 'bold', }
          end,
          inactive = { fg = '#888888', bg = '#333333', },
        },
        show_buffers = function()
          local buffers = {}
          for _, b in ipairs(vim.api.nvim_list_bufs()) do
            local fname = vim.api.nvim_buf_get_name(b)
            if require 'plenary.path'.new(fname):exists() then
              if vim.fn.buflisted(b) ~= 0 and vim.api.nvim_buf_get_option(b, 'buftype') ~= 'quickfix'
                  or vim.api.nvim_buf_get_option(b, 'buftype') == 'help' then
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
            local ext = string.match(path, '%.([^.]+)$')
            local ic, color = require 'nvim-web-devicons'.get_icon_color(path.filename, ext)
            if ic then
              return { fg = color, gui = 'bold', }
            end
            return { fg = 'white', gui = 'bold', }
          end,
          inactive = { fg = 'gray', },
        },
      },
    },
  },
  winbar = {
    lualine_c = {
      {
        function()
          return filename 'lualine_'
        end,
        cond = function()
          return #vim.fn.expand '%:~:.' > 0 and check_ft(vim.bo.ft)
        end,
      },
    },
    lualine_x = {
      {
        function()
          return get_projectroot(vim.call 'ProjectRootGet')
        end,
        color = { fg = '#7674f2', gui = 'bold', },
        cond = function()
          return #vim.fn.expand '%:~:.' > 0
        end,
        on_click = function(mouseclicks, mousebutton, modifiers)
          if mousebutton == 'l' and mouseclicks == 1 then
            local winid = vim.fn.win_getid()
            require 'config.fugitive'.open(1, vim.call 'ProjectRootGet')
            vim.fn.win_gotoid(winid)
          elseif mousebutton == 'm' and mouseclicks == 1 then
          end
        end,
      },
    },
    lualine_y = {
      {
        function()
          return vim.fn.bufwinnr(vim.fn.bufnr '%')
        end,
        cond = function()
          return #vim.fn.expand '%:~:.' > 0
        end,
        color = { fg = '#834567', gui = 'bold', },
      },
    },
    lualine_z = {
      {
        'windows',
        windows_color = {
          active = { fg = 'gray', bg = 'none', },
        },
      },
    },
  },
  inactive_winbar = {
    lualine_c = {
      {
        function()
          return filename 'lualine_'
        end,
        cond = function()
          return #vim.fn.expand '%:~:.' > 0 and check_ft(vim.bo.ft)
        end,
      },
    },
    lualine_x = {
      {
        function()
          return get_projectroot(vim.call 'ProjectRootGet')
        end,
        color = { fg = '#7674f2', gui = 'bold', },
        cond = function()
          return #vim.fn.expand '%:~:.' > 0
        end,
      },
    },
    lualine_y = {
      {
        function()
          return vim.fn.bufwinnr(vim.fn.bufnr '%')
        end,
        cond = function()
          return #vim.fn.expand '%:~:.' > 0
        end,
        color = { fg = '#834567', gui = 'bold', },
      },
    },
    lualine_z = {
      {
        'windows',
        windows_color = {
          active = { fg = 'gray', bg = 'none', },
        },
      },
    },
  },
}

-- number go tab or buffer

local lasttabnr = vim.fn['tabpagenr']()

vim.api.nvim_create_autocmd({ 'TabLeave', }, {
  callback = function()
    lasttabnr = vim.fn.tabpagenr()
  end,
})

local function go_tab()
  if vim.v.count == 0 then
    if lasttabnr <= vim.fn.tabpagenr '$' then
      vim.cmd('tabn ' .. lasttabnr)
    end
    return
  end
  local tabs = vim.fn.tabpagenr '$'
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
    vim.cmd [[call feedkeys("\<c-6>")]]
    return
  end
  local buffers = require 'lualine.components.buffers'.bufpos2nr
  if vim.v.count > #buffers then
    vim.cmd('LualineBuffersJump! ' .. #buffers)
  else
    vim.cmd('LualineBuffersJump! ' .. vim.v.count)
  end
end

vim.keymap.set({ 'n', 'v', }, '<f8>', go_tab, { desc = 'go tab', })
vim.keymap.set({ 'n', 'v', }, '<f2>', go_tab, { desc = 'go tab', })
vim.keymap.set({ 'n', 'v', }, '<leader>tt', go_tab, { desc = 'go tab', })

vim.keymap.set({ 'n', 'v', }, '<f7>', go_buffer, { desc = 'go buffer', })
vim.keymap.set({ 'n', 'v', }, '<f1>', go_buffer, { desc = 'go buffer', })
vim.keymap.set({ 'n', 'v', }, '<leader>bb', go_buffer, { desc = 'go buffer', })

-- go next or prev tab or buffer

vim.keymap.set({ 'n', 'v', }, '<bs>', function()
  local tabs = vim.fn.tabpagenr '$'
  local curtab = vim.fn.tabpagenr()
  local nexttab = curtab + 1 <= tabs and curtab + 1 or 1
  vim.cmd('tabn ' .. nexttab)
end, { desc = 'next tab', })

vim.keymap.set({ 'n', 'v', }, '<c-bs>', function()
  local curtab = vim.fn.tabpagenr()
  local prevtab = curtab - 1 >= 1 and curtab - 1 or vim.fn.tabpagenr '$'
  vim.cmd('tabn ' .. prevtab)
end, { desc = 'prev tab', })

vim.keymap.set({ 'n', 'v', }, '<c-h>', function()
  local buffers = require 'lualine.components.buffers'.bufpos2nr
  local curbufnr = vim.fn.bufnr()
  local curbufnr_idx = vim.fn.indexof(buffers, string.format('v:val == %d', curbufnr)) + 1
  if curbufnr_idx >= 1 then
    local prevbufnr = buffers[curbufnr_idx - 1 >= 1 and curbufnr_idx - 1 or #buffers]
    Buffer(prevbufnr)
  end
end, { desc = 'prev buffer', })

vim.keymap.set({ 'n', 'v', }, '<c-l>', function()
  local buffers = require 'lualine.components.buffers'.bufpos2nr
  local curbufnr = vim.fn.bufnr()
  local curbufnr_idx = vim.fn.indexof(buffers, string.format('v:val == %d', curbufnr)) + 1
  if curbufnr_idx >= 1 then
    local nextbufnr = buffers[curbufnr_idx + 1 <= #buffers and curbufnr_idx + 1 or 1]
    Buffer(nextbufnr)
  end
end, { desc = 'next buffer', })

-- Bdelete next or prev buffer

vim.keymap.set({ 'n', 'v', }, '<c-s-h>', function()
  local buffers = require 'lualine.components.buffers'.bufpos2nr
  local curbufnr = vim.fn.bufnr()
  local curbufnr_idx = vim.fn.indexof(buffers, string.format('v:val == %d', curbufnr)) + 1
  if curbufnr_idx >= 1 then
    local prevbufnr_idx = curbufnr_idx - 1 >= 1 and curbufnr_idx - 1 or #buffers
    if prevbufnr_idx < curbufnr_idx then
      local prevbufnr = buffers[prevbufnr_idx]
      vim.cmd('Bdelete! ' .. vim.api.nvim_buf_get_name(prevbufnr))
      require 'lualine'.refresh()
    end
  end
end, { desc = 'Bdelele prev buffer', })

vim.keymap.set({ 'n', 'v', }, '<c-s-l>', function()
  local buffers = require 'lualine.components.buffers'.bufpos2nr
  local curbufnr = vim.fn.bufnr()
  local curbufnr_idx = vim.fn.indexof(buffers, string.format('v:val == %d', curbufnr)) + 1
  if curbufnr_idx >= 1 then
    local nextbufnr_idx = curbufnr_idx + 1 <= #buffers and curbufnr_idx + 1 or 1
    if nextbufnr_idx > curbufnr_idx then
      local nextbufnr = buffers[nextbufnr_idx]
      vim.cmd('Bdelete! ' .. vim.api.nvim_buf_get_name(nextbufnr))
      require 'lualine'.refresh()
    end
  end
end, { desc = 'Bdelele next buffer', })

-- Bdelete next or prev tab

vim.keymap.set({ 'n', 'v', }, '<c-f7>', function()
  local curtab_idx = vim.fn.tabpagenr()
  if curtab_idx == 1 then
    return
  end
  local tabs = vim.fn.tabpagenr '$'
  if tabs == 1 then
    return
  end
  local prevtab_idx = curtab_idx - 1 >= 1 and curtab_idx - 1 or tabs
  vim.cmd(prevtab_idx .. 'tabclose!')
  require 'lualine'.refresh()
end, { desc = 'tabclose prev tab', })

vim.keymap.set({ 'n', 'v', }, '<c-f8>', function()
  local curtab_idx = vim.fn.tabpagenr()
  local tabs = vim.fn.tabpagenr '$'
  if tabs == 1 or curtab_idx == tabs then
    return
  end
  local nexttab_idx = curtab_idx + 1 <= tabs and curtab_idx + 1 or 1
  vim.cmd(nexttab_idx .. 'tabclose!')
  require 'lualine'.refresh()
end, { desc = 'tabclose next tab', })

-- auto change dir root

vim.api.nvim_create_autocmd({ 'TabEnter', }, {
  callback = function()
    pcall(vim.call, 'ProjectRootCD')
  end,
})

-- restore hidden tabs

local function tabsworkflow()
  pcall(vim.cmd, 'MinimapClose')
  vim.cmd 'tabo'
  vim.cmd 'wincmd o'
  local sta, tmp
  local tabs = {}
  local curtabnr = vim.fn.tabpagenr()
  for _, v in ipairs(vim.api.nvim_list_tabpages()) do
    sta, tmp = pcall(vim.api.nvim_tabpage_get_var, v, 'tabname')
    if sta == true then
      tabs[#tabs + 1] = tmp
    end
  end
  for b = 1, vim.fn.bufnr '$' do
    if vim.fn.buflisted(b) ~= 0 and vim.api.nvim_buf_get_option(b, 'buftype') ~= 'quickfix' then
      local fname = vim.fn.tolower(rep(vim.api.nvim_buf_get_name(b)))
      if #fname > 0 and vim.fn.filereadable(fname) == 1 then
        local tabname = get_projectroot(vim.fn['ProjectRootGet'](fname))
        if vim.tbl_contains(tabs, tabname) ~= true then
          vim.cmd 'tabnew'
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
end

vim.keymap.set({ 'n', 'v', }, '<c-q><c-t>', tabsworkflow, { desc = 'tabsworkflow', })
vim.keymap.set({ 'n', 'v', }, '<c-q>t', tabsworkflow, { desc = 'tabsworkflow', })

local fts = {
  'fugitive',
  'NvimTree',
  'minimap',
  'aerial',
  'edgy',
}

local function onetabworkflow()
  vim.cmd 'tabonly'
  if vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) ~= 1 then
    for winnr = 1, vim.fn.winnr '$' do
      local bufnr = vim.fn.winbufnr(winnr)
      local ft = vim.bo[bufnr].ft
      if vim.tbl_contains(fts, ft) ~= true then
        vim.fn.win_gotoid(vim.fn.win_getid(winnr))
      end
    end
  end
  local cur_winnr = vim.fn.winnr()
  local cur_bufnr = vim.fn.bufnr()
  local cur_winid = vim.fn.win_getid()
  local cur_fname = vim.api.nvim_buf_get_name(cur_bufnr)
  local winids = {}
  for winnr = 1, vim.fn.winnr '$' do
    local bufnr = vim.fn.winbufnr(winnr)
    local ft = vim.bo[bufnr].ft
    if vim.tbl_contains(fts, ft) ~= true and winnr ~= cur_winnr then
      winids[#winids + 1] = vim.fn.win_getid(winnr)
    end
  end
  for _, winid in ipairs(winids) do
    vim.fn.win_gotoid(winid)
    pcall(vim.cmd, 'close')
  end
  vim.fn.win_gotoid(cur_winid)
  local projs = { rep(vim.call('ProjectRootGet', cur_fname)), }
  local bufnrs = {}
  for bufnr = 1, vim.fn.bufnr '$' do
    if vim.fn.buflisted(bufnr) ~= 0 and vim.api.nvim_buf_get_option(bufnr, 'buftype') ~= 'quickfix' then
      local fname = vim.fn.tolower(rep(vim.api.nvim_buf_get_name(bufnr)))
      if #fname > 0 and vim.fn.filereadable(fname) == 1 then
        local proj = rep(vim.call('ProjectRootGet', fname))
        if vim.tbl_contains(projs, proj) ~= true then
          projs[#projs + 1] = proj
          bufnrs[#bufnrs + 1] = bufnr
        end
      end
    end
  end
  if #bufnrs > 0 then
    local first_proj = vim.fn.filereadable(cur_fname)
    for _, bufnr in ipairs(bufnrs) do
      if first_proj == true then
        first_proj = nil
      else
        vim.cmd 'split'
      end
      vim.cmd('b' .. tostring(bufnr))
    end
    vim.fn.win_gotoid(cur_winid)
    vim.cmd 'wincmd H'
  end
end

vim.keymap.set({ 'n', 'v', }, '<c-q>q', onetabworkflow, { desc = 'onetabworkflow', })
vim.keymap.set({ 'n', 'v', }, '<c-q><c-q>', onetabworkflow, { desc = 'onetabworkflow', })
vim.keymap.set({ 'n', 'v', }, '<c-w><c-q>', '<nop>', { desc = '', })
vim.keymap.set({ 'n', 'v', }, '<c-w>q', '<nop>', { desc = '', })

local function onetabonlycur()
  vim.cmd 'tabonly'
  if vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) ~= 1 then
    for winnr = 1, vim.fn.winnr '$' do
      local bufnr = vim.fn.winbufnr(winnr)
      local ft = vim.bo[bufnr].ft
      if vim.tbl_contains(fts, ft) ~= true then
        vim.fn.win_gotoid(vim.fn.win_getid(winnr))
      end
    end
  end
  local cur_winnr = vim.fn.winnr()
  local cur_bufnr = vim.fn.bufnr()
  local cur_winid = vim.fn.win_getid()
  local cur_fname = vim.api.nvim_buf_get_name(cur_bufnr)
  local winids = {}
  for winnr = 1, vim.fn.winnr '$' do
    local bufnr = vim.fn.winbufnr(winnr)
    local ft = vim.bo[bufnr].ft
    if vim.tbl_contains(fts, ft) ~= true and winnr ~= cur_winnr then
      winids[#winids + 1] = vim.fn.win_getid(winnr)
    end
  end
  for _, winid in ipairs(winids) do
    vim.fn.win_gotoid(winid)
    pcall(vim.cmd, 'close')
  end
  vim.fn.win_gotoid(cur_winid)
end

vim.keymap.set({ 'n', 'v', }, '<c-q>w', onetabonlycur, { desc = 'onetabonlycur', })
vim.keymap.set({ 'n', 'v', }, '<c-q><c-w>', onetabonlycur, { desc = 'onetabonlycur', })

local function onetabnodupl()
  local projs = {}
  local winid = vim.fn.win_getid()
  local winids = {}
  for winnr = 1, vim.fn.bufnr '$' do
    local bufnr = vim.fn.winbufnr(winnr)
    if vim.fn.buflisted(bufnr) ~= 0 and vim.api.nvim_buf_get_option(bufnr, 'buftype') ~= 'quickfix' then
      local fname = vim.fn.tolower(rep(vim.api.nvim_buf_get_name(bufnr)))
      if #fname > 0 and vim.fn.filereadable(fname) == 1 then
        local proj = rep(vim.fn['ProjectRootGet'](fname))
        if vim.tbl_contains(projs, proj) ~= true then
          projs[#projs + 1] = proj
        else
          winids[#winids + 1] = vim.fn.win_getid(winnr)
        end
      end
    end
  end
  for _, win in pairs(winids) do
    vim.fn.win_gotoid(win)
    vim.cmd 'close'
  end
  vim.fn.win_gotoid(winid)
end

vim.keymap.set({ 'n', 'v', }, '<c-q>e', onetabnodupl, { desc = 'onetabnodupl', })
vim.keymap.set({ 'n', 'v', }, '<c-q><c-e>', onetabnodupl, { desc = 'onetabnodupl', })

local function onetabothers()
  local winid = vim.fn.win_getid()
  local projs = { rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0))), }
  for winnr = 1, vim.fn.bufnr '$' do
    local bufnr = vim.fn.winbufnr(winnr)
    if vim.fn.buflisted(bufnr) ~= 0 and vim.api.nvim_buf_get_option(bufnr, 'buftype') ~= 'quickfix' then
      local fname = vim.fn.tolower(rep(vim.api.nvim_buf_get_name(bufnr)))
      if #fname > 0 and vim.fn.filereadable(fname) == 1 then
        local proj = rep(vim.fn['ProjectRootGet'](fname))
        if vim.tbl_contains(projs, proj) ~= true then
          projs[#projs + 1] = proj
        end
      end
    end
  end
  for b = 1, vim.fn.bufnr '$' do
    if vim.fn.buflisted(b) ~= 0 and vim.api.nvim_buf_get_option(b, 'buftype') ~= 'quickfix' then
      local fname = vim.fn.tolower(rep(vim.api.nvim_buf_get_name(b)))
      if #fname > 0 and vim.fn.filereadable(fname) == 1 then
        local proj = rep(vim.fn['ProjectRootGet'](fname))
        if vim.tbl_contains(projs, proj) ~= true then
          projs[#projs + 1] = proj
          vim.cmd 'split'
          vim.cmd('e ' .. fname)
        end
      end
    end
  end
  vim.fn.win_gotoid(winid)
end

vim.keymap.set({ 'n', 'v', }, '<c-q>r', onetabothers, { desc = 'onetabothers', })
vim.keymap.set({ 'n', 'v', }, '<c-q><c-r>', onetabothers, { desc = 'onetabothers', })

vim.opt.laststatus = 3

function LualineSwitchBuffer(bufnr, mouseclicks, mousebutton, modifiers)
  if mousebutton == 'm' and mouseclicks == 1 then
    vim.cmd(':Bdelete! ' .. tostring(bufnr))
  elseif mousebutton == 'l' and mouseclicks == 1 then
    if vim.fn.buflisted(vim.fn.bufnr()) == 0 then
      if not pcall(vim.fn.win_gotoid, vim.g.lastbufwinid) then
        print('error! see config/lualine.lua, g:lastbufwinid:', vim.g.lastbufwinid)
        return
      end
    end
    Buffer(bufnr)
  elseif mousebutton == 'r' and mouseclicks == 1 then
    if vim.fn.buflisted(vim.fn.bufnr()) == 0 then
      if not pcall(vim.fn.win_gotoid, vim.g.lastbufwinid) then
        print('error! see config/lualine.lua, g:lastbufwinid:', vim.g.lastbufwinid)
        return
      end
    end
    local curbufnr = vim.fn.bufnr()
    WinFixHeighEn()
    vim.cmd(':buffer ' .. tostring(bufnr))
    local winid = vim.fn.win_getid()
    vim.cmd 'NvimTreeFindFile'
    vim.fn.win_gotoid(winid)
    vim.cmd(':buffer ' .. tostring(curbufnr))
    WinFixHeighDis()
  end
end

function LualineSwitchTab(tabnr, mouseclicks, mousebutton, modifiers)
  if mousebutton == 'm' and mouseclicks == 1 then
    vim.cmd(tabnr .. 'tabclose')
  elseif mousebutton == 'l' and mouseclicks == 1 then
    vim.cmd(tabnr .. 'tabnext')
  elseif mousebutton == 'r' and mouseclicks == 1 then
    require 'bufferjump'.i()
  end
end

function LualineSwitchWindow(win_number, mouseclicks, mousebutton, modifiers)
  if mousebutton == 'm' and mouseclicks == 1 then
    local winid = vim.fn.win_getid()
    vim.cmd(win_number .. 'wincmd w')
    if vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) == 1 then
      vim.cmd 'close'
      vim.fn.win_gotoid(winid)
    else
      vim.fn.feedkeys 'q'
    end
  elseif mousebutton == 'l' and mouseclicks == 1 then
    vim.cmd(win_number .. 'wincmd w')
    require 'bufferjump'.o()
  elseif mousebutton == 'r' and mouseclicks == 1 then
    local winid = vim.fn.win_getid()
    vim.cmd(win_number .. 'wincmd w')
    vim.cmd 'NvimTreeFindFile'
    vim.fn.win_gotoid(winid)
  end
end

vim.cmd [[
  function! LualineSwitchBuffer(bufnr, mouseclicks, mousebutton, modifiers)
    call v:lua.LualineSwitchBuffer(a:bufnr, a:mouseclicks, a:mousebutton, a:modifiers)
  endfunction
  function! LualineSwitchTab(tabnr, mouseclicks, mousebutton, modifiers)
    call v:lua.LualineSwitchTab(a:tabnr, a:mouseclicks, a:mousebutton, a:modifiers)
  endfunction
  function! LualineSwitchWindow(win_number, mouseclicks, mousebutton, modifiers)
    call v:lua.LualineSwitchWindow(a:win_number, a:mouseclicks, a:mousebutton, a:modifiers)
  endfunction
]]

function Bdft(ftstring)
  local ftslist = {}
  for ft in string.gmatch(ftstring, '%a+') do
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
    local ft = string.match(name, '%.([^.]+)')
    if vim.tbl_contains(ftslist, ft) == true then
      vim.cmd('Bdelete! ' .. bufnr)
    end
    ::continue::
  end
end

vim.cmd [[
function Bdft(A, L, P)
  return g:bdfts
endfu
command! -complete=customlist,Bdft -nargs=* Bdft call v:lua.Bdft('<args>')
]]

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
      local ft = string.match(name, '%.([^%.]+)')
      if ft and #ft > 0 and vim.tbl_contains(bdfts, ft) == false then
        table.insert(bdfts, ft)
      end
    end
    ::continue::
  end
  vim.g.bdfts = bdfts
  if #vim.g.bdfts == 0 then
    print 'no other filetypes to bw'
    return
  end
  vim.cmd [[call feedkeys(":\<c-u>Bdft ")]]
end, { desc = 'Bdelete ft', })

vim.cmd [[
  hi WinSeparator guibg=black guifg=gray
]]
