require("diffview").setup()

local close_allow_timeout = 0
local close_allow_timer = nil
local close_allowed = nil
local close_force = nil
local close_print_en = 1

local M = {}

M.close_allow_timer_do = function()
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

M.diffviewfilehistory = function()
  vim.cmd('DiffviewFileHistory')
  M.close_allow_timer_do()
end

M.diffviewopen = function()
  vim.cmd('DiffviewOpen -u')
  M.close_allow_timer_do()
end

M.diffviewclose = function()
  if close_allowed then
    vim.cmd('DiffviewClose')
  else
    if close_print_en then
      print(close_allow_timeout .. 'ms后再尝试')
    end
  end
end

M.diffviewcloseforce = function()
  if close_allowed then
    vim.cmd('DiffviewClose')
  else
    close_force = 1
    if close_print_en then
      print(close_allow_timeout .. 'ms后执行DiffviewClose')
    end
  end
end

return M
