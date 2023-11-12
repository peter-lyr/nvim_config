local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

vim.cmd [[
  hi CursorLine   guifg=NONE guibg=#4a4a4a
  hi CursorColumn guifg=NONE guibg=#4a4a4a
  hi Comment           gui=NONE
  hi @comment          gui=NONE
  hi @lsp.type.comment gui=NONE
  hi TabLine     guifg=#a4a4a4
  hi TabLineSel  guifg=#a4a4a4
  hi TabLineFill guifg=#a4a4a4
]]

-- go to last loc when opening a buffer
B.aucmd(M.source, 'BufReadPost', 'BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

--------------------------

M.tab_4_fts = {
  'c', 'cpp',
  'python',
  'ld',
}

B.aucmd(M.source, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    if vim.fn.filereadable(ev.file) == 1 and vim.o.modifiable == true then
      vim.opt.cursorcolumn = true
    end
    if vim.tbl_contains(M.tab_4_fts, vim.opt.filetype:get()) == true then
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
    else
      vim.opt.tabstop = 2
      vim.opt.softtabstop = 2
      vim.opt.shiftwidth = 2
    end
  end,
})

----------------

ScrollMap = function(char)
  local key = string.format('<c-%s>', char)
  vim.keymap.set({ 'n', 'v', }, key, function()
    vim.keymap.del({ 'n', 'v', }, key)
    local cnt = 0
    local flag = 1
    local tick = 0
    local finished = 0
    local t1 = vim.loop.new_timer()
    local function finish(ch)
      finished = 1
      t1:stop()
      ScrollMap(char)
      if ch then
        vim.fn.feedkeys(ch)
      end
    end
    t1:start(0, 50, function()
      vim.schedule(function()
        cnt = cnt + 1
        if (cnt <= 11 or os.clock() - tick <= 0.50) and finished == 0 then
          vim.cmd(string.format([[exe "norm 5\%s"]], key))
          vim.cmd [[redraw]]
        else
          vim.cmd [[call feedkeys("\<esc>")]]
          finish()
        end
        if flag == 1 then
          flag = 0
          tick = os.clock()
          local ch = vim.fn.getcharstr()
          flag = 1
          local c1 = string.byte(ch, 1)
          local c2 = string.byte(ch, 2)
          local c3 = string.byte(ch, 3)
          local c4 = string.byte(ch, 4)
          if not (c1 == (vim.fn.char2nr(char) - vim.fn.char2nr 'a' + 1) and not c2 and not c3 and not c4) then
            -- print(string.format("%d[%f](%s %s %s %s)==", cnt, os.clock() - start, tostring(c1), tostring(c2),
            --   tostring(c3), tostring(c4)))
            finish(ch)
          end
        end
      end)
    end)
  end, { desc = 'instance ScrollMap', })
end

ScrollMap 'e'
ScrollMap 'y'

LineJumpMap = function(char, dir)
  local key = string.format('<c-%s>', char)
  vim.keymap.set({ 'n', 'v', }, key, function()
    vim.keymap.del({ 'n', 'v', }, key)
    local cnt = 0
    local flag = 1
    local tick = 0
    local finished = 0
    local t1 = vim.loop.new_timer()
    local function finish(ch)
      finished = 1
      t1:stop()
      LineJumpMap(char, dir)
      if ch then
        vim.fn.feedkeys(ch)
      end
    end
    t1:start(0, 50, function()
      vim.schedule(function()
        cnt = cnt + 1
        if (cnt <= 11 or os.clock() - tick <= 0.50) and finished == 0 then
          vim.cmd(string.format([[exe "norm 4%s"]], dir))
          vim.cmd [[redraw]]
        else
          vim.cmd [[call feedkeys("\<esc>")]]
          finish()
        end
        if flag == 1 then
          flag = 0
          tick = os.clock()
          local ch = vim.fn.getcharstr()
          flag = 1
          local c1 = string.byte(ch, 1)
          local c2 = string.byte(ch, 2)
          local c3 = string.byte(ch, 3)
          local c4 = string.byte(ch, 4)
          if not (c1 == (vim.fn.char2nr(char) - vim.fn.char2nr 'a' + 1) and not c2 and not c3 and not c4) then
            finish(ch)
          end
        end
      end)
    end)
  end, { desc = 'instance LineJumpMap', })
end

LineJumpMap('g', 'j')
LineJumpMap('p', 'k')

return M
