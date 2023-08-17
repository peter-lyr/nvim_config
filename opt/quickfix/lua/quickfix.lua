package.loaded['quickfix'] = nil

local M = {}

vim.g.qf_before_winid = -1

M.toggle = function()
  if vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'buftype') == 'quickfix' then
    vim.cmd 'ccl'
    if vim.api.nvim_win_is_valid(vim.g.qf_before_winid) == true then
      vim.fn.win_gotoid(vim.g.qf_before_winid)
    end
  else
    vim.g.qf_before_winid = vim.fn.win_getid()
    vim.cmd 'copen'
    vim.cmd 'wincmd J'
    vim.fn.timer_start(100, function()
      vim.api.nvim_win_set_height(0, 15)
      vim.cmd 'set winfixheight'
      vim.keymap.set("n", "q", function()
        vim.schedule(function()
          vim.cmd 'ccl'
          if vim.api.nvim_win_is_valid(vim.g.qf_before_winid) == true then
            vim.fn.win_gotoid(vim.g.qf_before_winid)
          end
        end)
      end, { buffer = vim.fn.bufnr(), nowait = true, silent = true, })
    end)
  end
end

pcall(vim.api.nvim_del_autocmd, vim.g.events_au_bufenter2)

vim.g.events_au_bufenter2 = vim.api.nvim_create_autocmd({ "BufEnter", }, {
  callback = function(ev)
    if vim.api.nvim_buf_get_option(ev.buf, 'buftype') == 'quickfix' then
      local open = function()
        local cfile = vim.fn.expand '<cfile>'
        if vim.fn.filereadable(cfile) == 1 then
          if vim.api.nvim_win_is_valid(vim.g.qf_before_winid) == true then
            vim.fn.win_gotoid(vim.g.qf_before_winid)
            vim.cmd('e ' .. cfile)
          end
        else
        end
      end
      vim.keymap.set("n", "o", open, { buffer = ev.buf, nowait = true, silent = true, })
      vim.keymap.set("n", "a", open, { buffer = ev.buf, nowait = true, silent = true, })
    end
  end,
})

return M
