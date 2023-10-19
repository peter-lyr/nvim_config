local M = {}

local gethiname = function(content)
  local sha256 = require 'sha2'
  local res = tostring(sha256.sha256(content))
  return 'H' .. string.sub(res, 1, 7)
end

local getescape = function(content)
  content = string.gsub(content, '%[', '\\[')
  content = string.gsub(content, '%*', '\\*')
  content = string.gsub(content, '%.', '\\.')
  content = string.gsub(content, '%~', '\\~')
  content = string.gsub(content, '%$', '\\$')
  content = string.gsub(content, '%^', '\\^')
  return content
end

local getcontent = function(line1, col1, line2, col2)
  local lines = {}
  for lnr = line1, line2 do
    local line = vim.fn.getline(lnr)
    if lnr == line1 and lnr == line2 then
      local linetemp1 = string.sub(line, col1, col2 + 1)
      local linetemp2 = string.sub(line, col1, col2 + 2)
      line = string.sub(line, col1, col2)
      if vim.fn.strdisplaywidth(linetemp1) == vim.fn.strdisplaywidth(line) + 4 and vim.fn.strdisplaywidth(linetemp1) == vim.fn.strdisplaywidth(linetemp2) + 6 then
        line = linetemp2
      end
    else
      if lnr == line1 then
        line = string.sub(line, col1)
      elseif lnr == line2 then
        local linetemp1 = string.sub(line, col1, col2 + 1)
        local linetemp2 = string.sub(line, col1, col2 + 2)
        line = string.sub(line, 0, col2)
        if vim.fn.strdisplaywidth(linetemp1) == vim.fn.strdisplaywidth(line) + 4 and vim.fn.strdisplaywidth(linetemp1) == vim.fn.strdisplaywidth(linetemp2) + 6 then
          line = linetemp2
        end
      end
    end
    local cells = {}
    for ch in string.gmatch(line, '.') do
      if ch == "'" then
        table.insert(cells, [["'"]])
      else
        if vim.tbl_contains({ '\\', '/', }, ch) then
          ch = '\\' .. ch
        end
        table.insert(cells, string.format("'%s'", ch))
      end
    end
    if #cells > 0 then
      table.insert(lines, table.concat(cells, ' . '))
    else
      table.insert(lines, "''")
    end
  end
  if #lines == 0 then
    return "''"
  end
  local content = table.concat(lines, " . '\\n' . ")
  return content
end

local getvisualcontent = function()
  local s = vim.fn.getpos "'<"
  local line1 = s[2]
  local col1 = s[3]
  local e = vim.fn.getpos "'>"
  local line2 = e[2]
  local col2 = e[3]
  return getcontent(line1, col1, line2, col2)
end

M.search = function()
  vim.cmd [[call feedkeys("\<esc>")]]
  local timer = vim.loop.new_timer()
  timer:start(10, 0, function()
    vim.schedule(function()
      vim.cmd(string.format('let @/ = "\\V" . %s', getvisualcontent()))
      vim.cmd [[call feedkeys("/\<c-r>/\<cr>")]]
    end)
  end)
end

local colorinit = function()
  local light = require 'nvim-web-devicons-light'
  local by_filename = light.icons_by_filename
  Colors = {}
  for _, v in pairs(by_filename) do
    table.insert(Colors, v['color'])
  end
end

colorinit()

HiLi = {}

local gethilipath = function()
  return require 'plenary.path':new(vim.loop.cwd()):joinpath '.hili'
end

local gethili = function()
  local hilipath = gethilipath()
  if not hilipath:exists() then
    return {}
  end
  local res = hilipath:read()
  local hili
  if #res > 0 then
    hili = loadstring('return ' .. res)()
  else
    hili = {}
  end
  return hili
end

local savehili = function(content, bg)
  local hili = gethili()
  if bg then
    hili = vim.tbl_deep_extend('force', hili, { [content] = bg, })
  else
    hili[content] = nil
  end
  if #vim.tbl_keys(hili) == 0 then
    gethilipath():rm()
  else
    gethilipath():write(vim.inspect(hili), 'w')
  end
end

M.hili_v = function()
  HiLi = gethili()
  if vim.tbl_contains({ 'v', 'V', '', }, vim.fn.mode()) == true then
    vim.cmd [[call feedkeys("\<esc>")]]
    local timer = vim.loop.new_timer()
    timer:start(10, 0, function()
      vim.schedule(function()
        vim.cmd(string.format('let @0 = %s', getvisualcontent()))
        local content = getescape(vim.fn.getreg '0')
        local hiname = gethiname(content)
        local bg = Colors[math.random(#Colors)]
        HiLi = vim.tbl_deep_extend('force', HiLi, { [content] = bg, })
        savehili(content, bg)
        vim.api.nvim_set_hl(0, hiname, { bg = bg, })
        vim.fn.matchadd(hiname, content)
      end)
    end)
  end
end

M.hili_n = function()
  vim.cmd 'norm viw'
  M.hili_v()
end

M.rmhili_v = function()
  HiLi = gethili()
  if HiLi and #vim.tbl_keys(HiLi) > 0 then
    if vim.tbl_contains({ 'v', 'V', '', }, vim.fn.mode()) == true then
      vim.cmd [[call feedkeys("\<esc>")]]
      local timer = vim.loop.new_timer()
      timer:start(10, 0, function()
        vim.schedule(function()
          vim.cmd(string.format('let @0 = %s', getvisualcontent()))
          local content = getescape(vim.fn.getreg '0')
          if vim.tbl_contains(vim.tbl_keys(HiLi), content) then
            local hiname = gethiname(content)
            pcall(vim.fn.matchdelete, vim.api.nvim_get_hl_id_by_name(hiname))
            vim.api.nvim_set_hl(0, hiname, { bg = nil, })
            savehili(content, nil)
          end
        end)
      end)
    end
  end
end

M.rmhili_n = function()
  vim.cmd 'norm viw'
  M.rmhili_v()
end

local rehili = function()
  HiLi = gethili()
  if HiLi and #vim.tbl_keys(HiLi) > 0 then
    for content, bg in pairs(HiLi) do
      local hiname = gethiname(content)
      vim.api.nvim_set_hl(0, hiname, { bg = bg, })
      vim.fn.matchadd(hiname, content)
    end
  end
end

local curcontent = ''

M.prevhili = function()
  HiLi = gethili()
  if HiLi and #vim.tbl_keys(HiLi) > 0 then
    vim.cmd [[call feedkeys("\<esc>")]]
    local content = table.concat(vim.tbl_keys(HiLi), '\\|')
    local ee = vim.fn.searchpos(content, 'be')
    local ss = vim.fn.searchpos(content, 'bn')
    vim.cmd(string.format('let @0 = %s', getcontent(ss[1], ss[2], ee[1], ee[2])))
    curcontent = getescape(vim.fn.getreg '0')
  end
end

M.nexthili = function()
  HiLi = gethili()
  if HiLi and #vim.tbl_keys(HiLi) > 0 then
    vim.cmd [[call feedkeys("\<esc>")]]
    local content = table.concat(vim.tbl_keys(HiLi), '\\|')
    local ss = vim.fn.searchpos(content)
    local ee = vim.fn.searchpos(content, 'ne')
    vim.cmd(string.format('let @0 = %s', getcontent(ss[1], ss[2], ee[1], ee[2])))
    curcontent = getescape(vim.fn.getreg '0')
  end
end

M.prevcurhili = function()
  HiLi = gethili()
  if #curcontent > 0 then
    vim.cmd [[call feedkeys("\<esc>")]]
    vim.fn.searchpos(curcontent, 'be')
  end
end

M.nextcurhili = function()
  HiLi = gethili()
  if #curcontent > 0 then
    vim.cmd [[call feedkeys("\<esc>")]]
    vim.fn.searchpos(curcontent)
  end
end

M.selnexthili = function()
  HiLi = gethili()
  if HiLi and #vim.tbl_keys(HiLi) > 0 then
    vim.cmd [[call feedkeys("\<esc>")]]
    local content = table.concat(vim.tbl_keys(HiLi), '\\|')
    local n = vim.fn.searchpos(content, 'n')
    local ne = vim.fn.searchpos(content, 'ne')
    if n[1] == ne[1] and n[2] == ne[2] then
      vim.fn.searchpos(content)
      vim.cmd [[call feedkeys("\<c-v>v")]]
    else
      vim.fn.searchpos(content)
      vim.cmd(string.format([[call feedkeys("v%dgg%d|")]], ne[1], ne[2]))
    end
  end
end

M.selprevhili = function()
  HiLi = gethili()
  if HiLi and #vim.tbl_keys(HiLi) > 0 then
    vim.cmd [[call feedkeys("\<esc>")]]
    local content = table.concat(vim.tbl_keys(HiLi), '\\|')
    local nb = vim.fn.searchpos(content, 'nb')
    local nbe = vim.fn.searchpos(content, 'nbe')
    if nbe[1] == nb[1] and nbe[2] == nb[2] then
      vim.fn.searchpos(content, 'be')
      vim.cmd [[call feedkeys("\<c-v>v")]]
    else
      vim.fn.searchpos(content, 'be')
      local ne = vim.fn.searchpos(content, 'nb')
      vim.cmd(string.format([[call feedkeys("v%dgg%d|")]], ne[1], ne[2]))
    end
  end
end

local hicurword = 1
local windo = 0

local ignore_fts = { 'minimap', }

vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', }, {
  callback = function()
    local filetype = vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'filetype')
    if vim.tbl_contains(ignore_fts, filetype) == true then
      return
    end
    local just_hicword = nil
    local word
    if hicurword == 1 then
      word = vim.fn.expand '<cword>'
      if windo == 1 then
        if vim.fn.getbufvar(vim.fn.bufnr(), '&buftype') ~= 'nofile' then
          local winid = vim.fn.win_getid()
          if string.match(word, '^[%w_一-龥]+$') then
            vim.cmd(string.format([[keepj windo match CursorWord /\V\<%s\>/]], word))
          else
            vim.cmd [[keepj windo match CursorWord //]]
          end
          vim.fn.win_gotoid(winid)
        else
          just_hicword = 1
        end
      else
        just_hicword = 1
      end
    else
      vim.cmd [[match CursorWord //]]
    end
    if just_hicword then
      if string.match(word, '^[%w_一-龥]+$') then
        vim.cmd(string.format([[match CursorWord /\V\<%s\>/]], word))
      else
        vim.cmd [[match CursorWord //]]
      end
    end
  end,
})

local function _()
  rehili()
  vim.api.nvim_set_hl(0, 'CursorWord', { reverse = true, bold = true, })
end

_()

vim.api.nvim_create_autocmd({ 'ColorScheme', }, {
  callback = function()
    _()
  end,
})

M.windocursorword = function()
  if windo == 1 then
    windo = 0
    print 'do not windo match'
  else
    windo = 1
    print 'windo match'
  end
end

M.cursorword = function()
  if hicurword == 1 then
    hicurword = 0
    print 'do not cursorword'
  else
    hicurword = 1
    print 'cursorword'
  end
end

return M
