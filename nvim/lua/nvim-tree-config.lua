-- # Option
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- # Key Mapping
local api = require("nvim-tree.api")

local function opts(desc)
  return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
end

vim.keymap.set('n', "<C-e>", api.tree.open, opts("Open"))

-- # Set Up
require("nvim-tree").setup({
  view = {
    width = 30,
    -- floating window
    float = {
      enable = true,
      open_win_config = {
        relative = "editor",
        border = "rounded",
        width = 30,
        height = 30,
        row = 1,
        col = 1
      }
    }
  }
})

