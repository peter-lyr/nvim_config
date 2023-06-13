require("diffview").setup()

local close_allow_timeout = 0
local close_allow_timer = nil
local close_allowed = nil
local close_force = nil
local close_print_en = 1

local function close_allow_timer_do()
  close_allowed = nil
  close_allow_timeout = 2000
  if close_allow_timer then
    close_allow_timer:stop()
  end
  close_allow_timer = vim.loop.new_timer()
  if close_allow_timer then
    close_allow_timer:start(200, 200, function()
      vim.schedule(function()
        close_allow_timeout = close_allow_timeout - 200
        if close_allow_timeout <= 0 then
          if close_allow_timer then
            close_allow_timer:stop()
            close_allow_timer = nil
          end
          close_allowed = 1
          if close_force then
            vim.cmd('DiffviewClose')
            close_force = nil
          end
        end
      end)
    end)
  end
end

local function diffviewfilehistory()
  vim.cmd('DiffviewFileHistory')
  close_allow_timer_do()
end

local function diffviewopen()
  vim.cmd('DiffviewOpen -u')
  close_allow_timer_do()
end

local function diffviewclose()
  if close_allowed then
    vim.cmd('DiffviewClose')
  else
    if close_print_en then
      print(close_allow_timeout .. 'ms后再尝试')
    end
  end
end

local function diffviewcloseforce()
  if close_allowed then
    vim.cmd('DiffviewClose')
  else
    close_force = 1
    if close_print_en then
      print(close_allow_timeout .. 'ms后执行DiffviewClose')
    end
  end
end

vim.keymap.set({ 'n', 'v' }, '<leader>gi', diffviewfilehistory, { silent = true, desc = 'diffview filehistory' })
vim.keymap.set({ 'n', 'v' }, '<leader>go', diffviewopen, { silent = true, desc = 'diffview open' })
vim.keymap.set({ 'n', 'v' }, '<leader>gq', diffviewclose, { silent = true, desc = 'diffview close' })
vim.keymap.set({ 'n', 'v' }, '<leader>gQ', diffviewcloseforce, { silent = true, desc = 'diffview close force' })

vim.keymap.set({ 'n', 'v' }, '<leader>ge', ':<c-u>DiffviewRefresh<cr>', { silent = true, desc = 'DiffviewRefresh' })
vim.keymap.set({ 'n', 'v' }, '<leader>gl', ':<c-u>DiffviewToggleFiles<cr>', { silent = true, desc = 'DiffviewToggleFiles' })

vim.keymap.set({ 'n', 'v' }, '<leader>xt', ':<c-u>tabclose<cr>', { silent = true, desc = 'tabclose' })
