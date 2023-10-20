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

vim.api.nvim_create_autocmd({ 'BufEnter', }, {
  callback = function(ev)
    pcall(vim.call, 'ProjectRootCD')
    local project = rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(ev.buf)))
    local ver = vim.version()
    vim.opt.titlestring = string.format('v%d%d-%s', ver['minor'], ver['patch'], get_only_name(project))
  end,
})
