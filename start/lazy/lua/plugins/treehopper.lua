-- https://github.com/atusy/dotfiles/blob/7e4647b50641fe489b3ebbf699de304ba995c234/dot_config/nvim/lua/plugins.lua#L829

return {
  'mfussenegger/nvim-treehopper',
  lazy = true,
  keys = {
    { 'zf', mode = { 'n', },     desc = 'tree hopper fold manual' },
    { 'im', mode = { 'o', 'x' }, desc = 'tree hopper sel' },
    {
      'gs',
      function()
        require('tsht').move({ ignore_injections = false })
      end,
      mode = { 'n', 'v' },
      desc = 'tree hopper go start'
    },
    {
      'gf',
      function()
        require('tsht').move({ side = 'end', ignore_injections = false })
      end,
      mode = { 'n', 'v' },
      desc = 'tree hopper go end'
    },
  },
  config = function()
    local function hi()
      vim.cmd('set foldmethod=manual')
      vim.api.nvim_set_hl(0, "TSNodeUnmatched", { link = "Comment" })
      vim.api.nvim_set_hl(0, "TSNodeKey", { link = "IncSearch" })
    end
    local function tsht()
      hi()
      return ":<C-U>lua require('tsht').nodes({ignore_injections = false})<CR>"
    end
    vim.keymap.set({ "o", "x" }, "im", tsht, { expr = true, silent = true })
    vim.keymap.set("n", "zf", function()
      hi()
      require("tsht").nodes({ ignore_injections = false })
      vim.cmd("normal! Vzf")
    end, { silent = true })
    require("tsht").config.hint_keys = {
      'a', 's', 'd', 'f', 'q', 'w', 'e', 'r', 'j', 'k', 'l', 'h',
      'n', 'm', 'y', 'u', 'i', 'o', 'p', 'z', 'x', 'c', 'v', 'g',
      't', 'b',
    }
  end,
}
