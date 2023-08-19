-- package.loaded['config.telescope_session'] = nil

local M = {}

require 'telescope'.load_extension 'xray23'

local sessionDir = require 'session-manage':new().sessionDir
sessionDir = string.gsub(sessionDir, '/', '\\')
if vim.fn.isdirectory(sessionDir) == 0 then
  vim.fn.mkdir(sessionDir, 'p')
end
local defaul_session = sessionDir .. '\\default.vim'

local function prepare()
  local eventignore = vim.opt.eventignore:get()
  vim.opt.eventignore = 'all'
  pcall(vim.cmd, 'MinimapClose')
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    local fname = vim.api.nvim_buf_get_name(b)
    if require 'plenary.path'.new(fname):exists() then
      if vim.fn.buflisted(b) == 0 or vim.tbl_contains({ 'nofile', 'terminal', 'help', 'quickfix', }, vim.api.nvim_buf_get_option(b, 'buftype')) == true then
        pcall(vim.cmd, 'bw! ' .. b)
      end
    else
      pcall(vim.cmd, 'bw! ' .. b)
    end
  end
  vim.opt.eventignore = eventignore
  for _, client in pairs(vim.lsp.get_active_clients()) do
    vim.lsp.stop_client(client)
  end
end

M.open = function()
  prepare()
  local current_spath = vim.v.this_session or ''
  if current_spath ~= '' then
    vim.api.nvim_command('mksession! ' .. vim.fn.fnameescape(current_spath))
  end
  pcall(vim.cmd, 'wall')
  pcall(vim.cmd, '%bwipeout')
  pcall(vim.cmd, 'source ' .. defaul_session)
  vim.keymap.set({ 'n', 'v', }, '<leader>svo', function()
    print 'Can not open default session again!'
  end, { silent = true, desc = 'Telescope session open (canceled!)', })
end

M.save = function()
  prepare()
  vim.loop.new_timer():start(10, 0, function()
    vim.schedule(function()
      vim.api.nvim_command('mksession! ' .. vim.fn.fnameescape(defaul_session))
      vim.notify('\nSession ' .. defaul_session .. ' is now persistent')
    end)
  end)
end

M.saveinput = function()
  prepare()
  vim.api.nvim_cmd(vim.api.nvim_parse_cmd('Telescope xray23 save', {}), {})
end

M.list = function()
  vim.api.nvim_cmd(vim.api.nvim_parse_cmd('Telescope xray23 list', {}), {})
end

vim.api.nvim_create_autocmd({ 'QuitPre', }, {
  callback = function()
    M.save()
  end,
})

vim.api.nvim_create_autocmd({ 'SessionLoadPost', }, {
  callback = function()
    vim.fn.timer_start(100, function()
      vim.cmd 'Minimap'
      vim.cmd 'NvimTreeOpen'
      vim.cmd 'G'
      vim.cmd 'wincmd l'
    end)
  end,
  once = true,
})

vim.fn.timer_start(100, function()
  M.open()
end)

return M
