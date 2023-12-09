local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

B.load_require 'nvim-lua/plenary.nvim'
B.load_require 'nvim-tree/nvim-web-devicons'
B.load_require 'peter-lyr/sha2'

function M.gethiname(content)
  local sha256 = require 'sha2'
  local res = tostring(sha256.sha256(content))
  return 'H' .. string.sub(res, 1, 7)
end

function M.getescape(content)
  content = string.gsub(content, '%[', '\\[')
  content = string.gsub(content, '%*', '\\*')
  content = string.gsub(content, '%.', '\\.')
  content = string.gsub(content, '%~', '\\~')
  content = string.gsub(content, '%$', '\\$')
  content = string.gsub(content, '%^', '\\^')
  return content
end

function M.getcontent(line1, col1, line2, col2)
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

function M.getvisualcontent()
  local s = vim.fn.getpos "'<"
  local line1 = s[2]
  local col1 = s[3]
  local e = vim.fn.getpos "'>"
  local line2 = e[2]
  local col2 = e[3]
  return M.getcontent(line1, col1, line2, col2)
end

function M.search()
  vim.cmd [[call feedkeys("\<esc>")]]
  local timer = vim.loop.new_timer()
  timer:start(10, 0, function()
    vim.schedule(function()
      B.cmd('let @/ = "\\V" . %s', M.getvisualcontent())
      vim.cmd [[call feedkeys("/\\\<c-r>/\<cr>")]]
    end)
  end)
end

function M.colorinit()
  local light = require 'nvim-web-devicons.icons-light'
  local by_filename = light.icons_by_filename
  Colors = {}
  for _, v in pairs(by_filename) do
    table.insert(Colors, v['color'])
  end
end

M.colorinit()

HiLi = {}

function M.gethilipath()
  return require 'plenary.path':new(vim.loop.cwd()):joinpath '.hili'
end

function M.gethili()
  local hilipath = M.gethilipath()
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

function M.savehili(content, bg)
  local hili = M.gethili()
  if bg then
    hili = vim.tbl_deep_extend('force', hili, { [content] = bg, })
  else
    hili[content] = nil
  end
  if #vim.tbl_keys(hili) == 0 then
    M.gethilipath():rm()
  else
    M.gethilipath():write(vim.inspect(hili), 'w')
  end
end

function M.hili_v()
  HiLi = M.gethili()
  if vim.tbl_contains({ 'v', 'V', '', }, vim.fn.mode()) == true then
    vim.cmd [[call feedkeys("\<esc>")]]
    local timer = vim.loop.new_timer()
    timer:start(10, 0, function()
      vim.schedule(function()
        B.cmd('let @0 = %s', M.getvisualcontent())
        local content = M.getescape(vim.fn.getreg '0')
        local hiname = M.gethiname(content)
        local bg = Colors[math.random(#Colors)]
        HiLi = vim.tbl_deep_extend('force', HiLi, { [content] = bg, })
        M.savehili(content, bg)
        vim.api.nvim_set_hl(0, hiname, { bg = bg, })
        vim.fn.matchadd(hiname, content)
      end)
    end)
  end
end

function M.hili_n()
  vim.cmd 'norm viw'
  M.hili_v()
end

function M.rmhili_v()
  HiLi = M.gethili()
  if HiLi and #vim.tbl_keys(HiLi) > 0 then
    if vim.tbl_contains({ 'v', 'V', '', }, vim.fn.mode()) == true then
      vim.cmd [[call feedkeys("\<esc>")]]
      local timer = vim.loop.new_timer()
      timer:start(10, 0, function()
        vim.schedule(function()
          B.cmd('let @0 = %s', M.getvisualcontent())
          local content = M.getescape(vim.fn.getreg '0')
          if vim.tbl_contains(vim.tbl_keys(HiLi), content) then
            local hiname = M.gethiname(content)
            pcall(vim.fn.matchdelete, vim.api.nvim_get_hl_id_by_name(hiname))
            vim.api.nvim_set_hl(0, hiname, { bg = nil, })
            M.savehili(content, nil)
          end
        end)
      end)
    end
  end
end

function M.rmhili_n()
  vim.cmd 'norm viw'
  M.rmhili_v()
end

function M.rehili()
  HiLi = M.gethili()
  if HiLi and #vim.tbl_keys(HiLi) > 0 then
    for content, bg in pairs(HiLi) do
      local hiname = M.gethiname(content)
      vim.api.nvim_set_hl(0, hiname, { bg = bg, })
      vim.fn.matchadd(hiname, content)
    end
  end
end

M.curcontent = ''

function M.prevhili()
  HiLi = M.gethili()
  if HiLi and #vim.tbl_keys(HiLi) > 0 then
    vim.cmd [[call feedkeys("\<esc>")]]
    local content = table.concat(vim.tbl_keys(HiLi), '\\|')
    local ee = vim.fn.searchpos(content, 'be')
    local ss = vim.fn.searchpos(content, 'bn')
    B.cmd('let @0 = %s', M.getcontent(ss[1], ss[2], ee[1], ee[2]))
    M.curcontent = M.getescape(vim.fn.getreg '0')
  end
end

function M.nexthili()
  HiLi = M.gethili()
  if HiLi and #vim.tbl_keys(HiLi) > 0 then
    vim.cmd [[call feedkeys("\<esc>")]]
    local content = table.concat(vim.tbl_keys(HiLi), '\\|')
    local ss = vim.fn.searchpos(content)
    local ee = vim.fn.searchpos(content, 'ne')
    B.cmd('let @0 = %s', M.getcontent(ss[1], ss[2], ee[1], ee[2]))
    M.curcontent = M.getescape(vim.fn.getreg '0')
  end
end

function M.prevcurhili()
  HiLi = M.gethili()
  if #M.curcontent > 0 then
    vim.cmd [[call feedkeys("\<esc>")]]
    vim.fn.searchpos(M.curcontent, 'be')
  end
end

function M.nextcurhili()
  HiLi = M.gethili()
  if #M.curcontent > 0 then
    vim.cmd [[call feedkeys("\<esc>")]]
    vim.fn.searchpos(M.curcontent)
  end
end

function M.selnexthili()
  HiLi = M.gethili()
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
      B.cmd([[call feedkeys("v%dgg%d|")]], ne[1], ne[2])
    end
  end
end

function M.selprevhili()
  HiLi = M.gethili()
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
      B.cmd([[call feedkeys("v%dgg%d|")]], ne[1], ne[2])
    end
  end
end

M.hicurword = 1
M.windo = nil

M.ignore_fts = { 'minimap', }

M.iskeyword_pattern = '^[%w_一-龥]+$'

function M.on_cursorhold(ev)
  local filetype = vim.api.nvim_buf_get_option(ev.buf, 'filetype')
  if vim.tbl_contains(M.ignore_fts, filetype) == true then
    return
  end
  local just_hicword = nil
  local word
  if M.hicurword then
    word = vim.fn.expand '<cword>'
    if M.windo then
      if vim.fn.getbufvar(ev.buf, '&buftype') ~= 'nofile' then
        local winid = vim.fn.win_getid()
        if string.match(word, M.iskeyword_pattern) then
          B.cmd([[keepj windo match CursorWord /\V\<%s\>/]], word)
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
    if string.match(word, M.iskeyword_pattern) then
      B.cmd([[match CursorWord /\V\<%s\>/]], word)
    else
      vim.cmd [[match CursorWord //]]
    end
  end
end

function M.on_colorscheme()
  M.rehili()
  vim.api.nvim_set_hl(0, 'CursorWord', { reverse = true, bold = true, })
end

M.on_colorscheme()

function M.windocursorword()
  if M.windo then
    M.windo = nil
    B.notify_info 'do not windo match'
  else
    M.windo = 1
    B.notify_info 'windo match'
  end
end

function M.cursorword()
  if M.hicurword then
    M.hicurword = nil
    B.notify_info 'do not cursorword'
  else
    M.hicurword = 1
    B.notify_info 'cursorword'
  end
end

return M
