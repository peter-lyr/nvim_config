local M = {}

-- drag image files to markdown file which is in a project root.

package.loaded['drag_images'] = nil

M.markdowns_fts = {
  'md',
}

M.images_fts = {
  'jpg', 'png',
}

local function rep(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '/', '\\')
  return content
end

M.check = function(buf)
  local last_file = require 'drag'.last_file
  local project = rep(vim.call 'ProjectRootGet')
  if #project == 0 then
    print('not in a project:', last_file)
    return ''
  end
  local ext = string.match(last_file, '%.([^.]+)$')
  if vim.tbl_contains(M.markdowns_fts, ext) == true then
    local drag_file = vim.api.nvim_buf_get_name(buf)
    ext = string.match(drag_file, '%.([^.]+)$')
    if vim.tbl_contains(M.images_fts, ext) == true then
      return 'Bdelete!'
    end
  end
  return ''
end

return M
