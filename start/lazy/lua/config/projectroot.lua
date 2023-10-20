vim.g.rootmarkers = {
  '.git',
}

local function get_only_name(bufname)
  local only_name = string.gsub(bufname, '/', '\\')
  if string.match(only_name, '\\') then
    only_name = string.match(only_name, '.+%\\(.+)$')
  end
  return only_name
end

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
    head = get_only_name(head)
    vim.opt.titlestring = string.format('%d %s %s', ver['patch'], get_only_name(project), head)
  end,
})
