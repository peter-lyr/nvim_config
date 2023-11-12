local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

M.xxd_cmd = 'xxd'
M.drag_bin_fts_md_path = require 'plenary.path':new(M.source .. '.fts.md')
M.xxd_output_dir_p = require 'plenary.path':new [[C:\Windows\temp]]:joinpath 'xxd_output'

if not M.xxd_output_dir_p:exists() then
  vim.fn.mkdir(M.xxd_output_dir_p.filename)
end

M.xxd_do = function(bufnr)
  local bin_fname = B.rep_slash_lower(vim.api.nvim_buf_get_name(bufnr))
  local bin_fname_tail = vim.fn.fnamemodify(bin_fname, ':t')
  local bin_fname_full__ = string.gsub(vim.fn.fnamemodify(bin_fname, ':h'), '\\', '_')
  bin_fname_full__ = string.gsub(bin_fname_full__, ':', '_')
  local xxd_output_sub_dir_p = M.xxd_output_dir_p:joinpath(bin_fname_full__)
  if not xxd_output_sub_dir_p:exists() then
    vim.fn.mkdir(xxd_output_sub_dir_p.filename)
  end
  local xxd = xxd_output_sub_dir_p:joinpath(bin_fname_tail .. '.xxd').filename
  local c = xxd_output_sub_dir_p:joinpath(bin_fname_tail .. '.c').filename
  local bak = xxd_output_sub_dir_p:joinpath(bin_fname_tail .. '.bak').filename
  vim.fn.system(string.format('copy /y "%s" "%s"', bin_fname, bak))
  vim.fn.system(string.format('%s "%s" "%s"', M.xxd_cmd, bak, xxd))
  vim.fn.system(string.format('%s && %s -i "%s" "%s"', B.system_cd(bak), M.xxd_cmd, vim.fn.fnamemodify(bak, ':t'), c))
  vim.cmd('e ' .. xxd)
  vim.cmd 'setlocal ft=xxd'
end

M.xxd = function(buf)
  local callback = function(bufnr)
    vim.cmd 'Bdelete!'
    vim.fn.timer_start(50, function()
      M.xxd_do(bufnr)
    end)
  end
  return { callback, { buf, }, }
end

M.is_bin = function(buf)
  local info = vim.fn.system(string.format('file -b --mime-type --mime-encoding "%s"', vim.api.nvim_buf_get_name(buf)))
  info = string.gsub(info, '%s', '')
  local info_l = vim.fn.split(info, ';')
  if info_l[2] and string.match(info_l[2], 'binary') and info_l[1] and not string.match(info_l[1], 'empty') then
    return 1
  end
  return nil
end

M.edit_drag_bin_fts_md = function()
  vim.cmd 'wincmd s'
  vim.cmd('e ' .. M.drag_bin_fts_md_path.filename)
end

M.is_to_xxd = function(buf)
  local lines = M.drag_bin_fts_md_path:readlines()
  local ext = string.match(vim.api.nvim_buf_get_name(buf), '%.([^.]+)$')
  for _, line in ipairs(lines) do
    local ft = vim.fn.tolower(vim.fn.trim(line))
    if #ft > 0 then
      if ext == ft then
        return 1
      end
    end
  end
  return nil
end

M.check_xxd = function(buf)
  if M.is_bin(buf) and M.is_to_xxd(buf) then
    return M.xxd(buf)
  end
  return ''
end

M.check_others = function(buf)
  if M.is_bin(buf) then
    return 'Bdelete!'
  end
  return ''
end

return M
