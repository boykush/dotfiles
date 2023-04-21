-- # Option

-- ## 表示
-- 行番号
vim.opt.number = true
-- カーソル行にラインを表示
vim.opt.cursorline = true
-- 括弧の対応
vim.opt.showmatch = true
vim.opt.matchtime = 1

-- ## 入力
-- 改行時のインデントを自動化
vim.opt.smartindent = true                      
-- タブ文字
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- ## 検索
-- 大文字無視
vim.opt.ignorecase = true
-- 大文字検索時、大文字小文字を区別する
vim.opt.smartcase = true
-- 検索結果が最後までいったら最初に戻る
vim.opt.wrapscan = true

-- ## ファイル
-- ファイルの読み込み更新頻度
vim.opt.updatetime = 100
-- ファイル書き込み時の文字コードをutf-8にする
vim.opt.fileencoding = "utf-8"
-- ファイルを自動更新
vim.opt.autoread = true

-- ## クリップボード
vim.opt.clipboard:append({ unnamedeplus = true })

-- ## マウス
vim.opt.mouse = 'a'

-- # Common Key Mapping
-- jjでnormalモードに移行
vim.keymap.set('i', "jj", "<ESC>") 

-- # Packer Install
require("packer").startup(function(use)
  -- Packer can manage itself
  use "wbthomason/packer.nvim"

  -- Tree
  use {
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons",
    },
  }
end)

-- # Nvim Tree 
-- ## Option
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ## Key Mapping
local tree_api = require("nvim-tree.api")

local function opts(desc)
  return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
end

vim.keymap.set('n', "<C-e>", tree_api.tree.open, opts("Open"))

-- ## Set Up
require("nvim-tree").setup({
  view = {
    mappings = {
      list = {
        { key = "<C-e>", action_cb = tree_api.tree.close }
      },
    },
    width = 30,
    height = 30,
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

