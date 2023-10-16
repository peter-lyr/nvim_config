local M = {}

-- drag documents files to markdown file which is in a project root.

-- save dragging document files to .docs/ in the project root.
-- rename them by the calculation result of hash.
-- save key/value in .docs/_.md:
-- hash: document file name.

package.loaded['drag_docs'] = nil

M.doc_root_dir = '.docs'
M.doc_root_md = '_.md'

M.markdowns_fts = {
  'md',
}

M.docs_fts = {
  'pdf',
}

local function rep(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '/', '\\')
  return content
end

local function rep_reverse(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '\\', '/')
  return content
end

M.get_hash = function(file)
  return require 'sha2'.sha256(require 'plenary.path':new(file):_read())
end

M.get_relative_head = function(base_file, target_file)
  local relative = string.sub(target_file, #base_file + 2, #target_file)
  relative = vim.fn.fnamemodify(relative, ':h')
  if relative == '.' then
    return '.'
  end
  relative = string.gsub(relative, '(\\)', '/')
  return string.gsub(relative, '([^/]+)', '..')
end

M.notify = function(info)
  vim.notify(info, 'info', {
    animate = false,
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
      vim.api.nvim_win_set_option(win, 'concealcursor', 'nvic')
    end,
    timeout = 1000 * 8,
  })
end

M.copy_doc = function(src, tgt)
  vim.fn.system(string.format('copy /y "%s" "%s"', src, tgt))
end

M.prepare = function(project, doc_fname, markdown_fname)
  M.project = project
  M.doc_fname = doc_fname
  M.markdown_fname = markdown_fname
  M.markdown_rel_head_dot = M.get_relative_head(M.project, M.markdown_fname)
  M.doc_root_dir_path = require 'plenary.path':new(M.project):joinpath(M.doc_root_dir)
  if not M.doc_root_dir_path:exists() then
    vim.fn.mkdir(M.doc_root_dir_path.filename)
  end
  M.doc_fname_tail = vim.fn.fnamemodify(M.doc_fname, ':t')
  M.doc_fname_tail_root = vim.fn.fnamemodify(M.doc_fname_tail, ':r')
  M.doc_fname_tail_ext = vim.fn.fnamemodify(M.doc_fname_tail, ':e')
  M.doc_hash_64 = M.get_hash(M.doc_fname)
  M.doc_hash_8 = string.sub(M.doc_hash_64, 1, 8)
  M.doc_hash_name = M.doc_hash_8 .. '.' .. M.doc_fname_tail_ext
  M.doc_target_file = rep(M.doc_root_dir_path:joinpath(M.doc_hash_name).filename)
  M.doc_root_md_path = M.doc_root_dir_path:joinpath(M.doc_root_md)
end

M.save_doc = function()
  M.copy_doc(M.doc_fname, M.doc_target_file)
end

M.append_info = function()
  local _url = rep_reverse(M.doc_hash_name)
  local _line = string.format('%s[%s](%s)\n', M.doc_hash_64, M.doc_fname_tail_root, _url)
  M.doc_root_md_path:write(_line, 'a')
end

M.append_line_pre = function()
  local url = rep_reverse(require 'plenary.path':new(M.markdown_rel_head_dot):joinpath(M.doc_root_dir, M.doc_hash_8 .. '.' .. M.doc_fname_tail_ext).filename)
  return string.format('[%s](%s)', M.doc_fname_tail_root, url)
end

M.append_line_do = function(line)
  vim.fn.append(vim.fn.line '.', line)
end

M.append_line = function()
  M.append_line_do(M.append_line_pre())
end

M.append_doc = function(project, doc_fname, markdown_fname)
  M.prepare(project, doc_fname, markdown_fname)
  M.save_doc()
  M.append_info()
  local callback = function(result)
    vim.cmd 'Bdelete!'
    vim.fn.timer_start(50, function()
      M.append_line_do(result)
    end)
  end
  return { callback, { M.append_line_pre(), }, }
end

M.is_dragged = function(project, buf)
  local doc_root_dir_path = require 'plenary.path':new(project):joinpath(M.doc_root_dir)
  local doc_root_md_path = doc_root_dir_path:joinpath(M.doc_root_md)
  local content = doc_root_md_path:read()
  local doc_fname = rep(vim.api.nvim_buf_get_name(buf))
  if not require 'plenary.path':new(doc_fname):exists() then
    return nil
  end
  local hash_64 = M.get_hash(doc_fname)
  if string.match(content, hash_64) then
    return 1
  end
  return nil
end

M.check = function(buf)
  local markdown_fname = rep(require 'drag'.last_file)
  local project = rep(vim.fn['ProjectRootGet'](markdown_fname))
  if #project == 0 then
    M.notify('not in a project: ' .. markdown_fname)
    return ''
  end
  if M.is_dragged(project, buf) then
    local doc_fname = rep(vim.api.nvim_buf_get_name(buf))
    M.notify('is dragged: ' .. doc_fname)
    local callback = function(result)
      vim.cmd 'Bdelete!'
      vim.fn.system('start ' .. result)
    end
    return { callback, { doc_fname, }, }
  end
  local ext = string.match(markdown_fname, '%.([^.]+)$')
  if vim.tbl_contains(M.markdowns_fts, ext) == true then
    local doc_fname = rep(vim.api.nvim_buf_get_name(buf))
    ext = string.match(doc_fname, '%.([^.]+)$')
    if vim.tbl_contains(M.docs_fts, ext) == true then
      return M.append_doc(project, doc_fname, markdown_fname)
    end
  end
  return ''
end

return M
