local M = {}

M.push = function()
  local result = vim.fn.systemlist({ "git", "status", "-s" })
  if #result > 0 then
    vim.notify(vim.loop.cwd() .. '\n' .. table.concat(result, '\n'))
    local input = vim.fn.input('commit info (Add all and push): ')
    if #input > 0 then
      vim.loop.new_timer():start(10, 0, function()
        vim.schedule(function()
          vim.cmd([[au User AsyncRunStop lua local l = vim.fn.getqflist(); vim.notify(l[#l]['text']); vim.cmd('au! User AsyncRunStop')]])
          vim.cmd(string.format('AsyncRun git add -A && git status && git commit -m "%s" && git push', input))
        end)
      end)
    end
  end
end

M.init = function()
end

return M
