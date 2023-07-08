local M = {}

M.is_dragging = true
M.is_readpre = false
M.last_ev = nil
M.flag = 1

vim.api.nvim_create_autocmd({ 'FocusLost' }, {
  callback = function()
    vim.schedule(function()
      M.is_dragging = true
    end)
  end,
})

vim.api.nvim_create_autocmd({ 'BufReadPre' }, {
  callback = function(ev)
    vim.schedule(function()
      M.is_readpre = true
      if M.is_dragging == true then
        M.flag = require('drageimages').readpre(ev, M.last_ev)
      end
    end)
  end,
})

vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  callback = function(ev)
    vim.schedule(function()
      if M.flag then
        return
      end
      M.flag = 1
      require('xxd').check(ev)
    end)
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  callback = function(ev)
    vim.schedule(function()
      M.last_ev = ev
      if M.is_dragging == true and M.is_readpre == true then
        M.is_dragging = false
        M.is_readpre = false
        require('drageimages').bufenter(ev)
      end
    end)
  end,
})
