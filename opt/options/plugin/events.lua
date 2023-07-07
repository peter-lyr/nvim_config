-- sometimes mouse not working

vim.api.nvim_create_autocmd({ "BufEnter", }, {
  callback = function()
    vim.opt.mouse = 'a'
  end,
})

-- tab space

local tab_4_lang = {
  'c', 'cpp',
  'python',
  'ld',
}

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    if vim.tbl_contains(tab_4_lang, vim.opt.filetype:get()) == true then
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
    else
      vim.opt.tabstop = 2
      vim.opt.softtabstop = 2
      vim.opt.shiftwidth = 2
    end
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter", }, {
  callback = function()
    if vim.fn.exists('g:GuiLoaded') and vim.g.GuiLoaded == 1 then
      vim.loop.new_timer():start(10, 0, function()
        vim.schedule(function()
          vim.fn['GuiWindowFrameless'](1)
        end)
      end)
    end
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave", }, {
  callback = function()
    if vim.fn.exists('g:GuiLoaded') and vim.g.GuiLoaded == 1 then
      vim.fn['GuiWindowMaximized'](0)
      vim.loop.new_timer():start(10, 0, function()
        vim.schedule(function()
          vim.fn['GuiWindowFrameless'](0)
        end)
      end)
    end
  end,
})

-- This file is automatically loaded by lazyvim.config.init

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- -- resize splits if window got resized
-- vim.api.nvim_create_autocmd({ "VimResized" }, {
--   group = augroup("resize_splits"),
--   callback = function()
--     vim.cmd("tabdo wincmd =")
--   end,
-- })

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- record last buflisted bufnr

vim.g.lastbufwinid = -1

vim.api.nvim_create_autocmd({ "BufLeave", }, {
  callback = function()
    local bufnr = vim.fn.bufnr()
    if vim.fn.buflisted(bufnr) ~= 0 then
      vim.g.lastbufwinid = vim.fn.win_getid()
    else
      vim.g.lastbufwinid = -1
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "lazy",
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "git",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.loop.new_timer():start(30, 0, function()
      vim.schedule(function()
        vim.keymap.set("n", "q", function()
          require('buffernew').close()
          vim.loop.new_timer():start(30, 0, function()
            vim.schedule(function()
              if vim.fn.buflisted(vim.fn.bufnr()) == 0 and vim.g.lastbufwinid ~= -1 then
                pcall(vim.fn.win_gotoid, vim.g.lastbufwinid)
              end
            end)
          end)
        end, { buffer = event.buf, silent = true })
      end)
    end)
  end,
})

-- -- wrap and check for spell in text filetypes
-- vim.api.nvim_create_autocmd("FileType", {
--   group = augroup("wrap_spell"),
--   pattern = { "gitcommit", "markdown" },
--   callback = function()
--     vim.opt_local.wrap = true
--     vim.opt_local.spell = true
--   end,
-- })

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
