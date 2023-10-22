local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
package.loaded[B.get_loaded(M.source)] = nil
--------------------------------------------

vim.g.rootmarkers = {
  '.git',
}

local function rep(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '/', '\\')
  return content
end

pcall(vim.api.nvim_del_autocmd, vim.g.projectroot_au_bufenter)

vim.g.projectroot_au_bufenter = vim.api.nvim_create_autocmd('BufEnter', {
  callback = function(ev)
    pcall(vim.call, 'ProjectRootCD')
    local project = rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(ev.buf)))
    local ver = vim.version()
    local head = vim.fn.fnamemodify(project, ':h')
    head = B.get_only_name(head)
    vim.opt.titlestring = string.format('%d %s %s', ver['patch'], B.get_only_name(project), head)
  end,
})

return M
