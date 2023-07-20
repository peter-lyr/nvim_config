vim.g.events_log_en = 1
local events_log_dir = vim.fn.stdpath('data') .. '\\events_log\\'
vim.g.events_log = events_log_dir .. vim.fn.strftime("%Y%m%d-%H%M%S.log")
if vim.fn.isdirectory(events_log_dir) == 0 then
  vim.fn.system(string.format('md "%s"', events_log_dir))
end

function EventsLog(ev, en)
  if vim.g.events_log_en == 1 and en == 1 then
    if ev and ev.buf and ev.event and ev.file then
      vim.fn.writefile({
        string.format([[%3.3f %-2d %-10s "%s"]],
          os.clock(), ev.buf, ev.event, ev.file)
      }, vim.g.events_log, 'a')
    end
  end
end

vim.api.nvim_create_user_command('EventsLogOpen', function()
  if vim.g.events_log_en == 1 then
    vim.cmd('e ' .. vim.g.events_log)
  end
end, { bang = true, nargs = "*", })
