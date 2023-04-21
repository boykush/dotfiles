-- # 表示
-- 行番号
vim.opt.number = true
-- カーソル行にラインを表示
vim.opt.cursorline = true
-- 括弧の対応
vim.opt.showmatch = true
vim.opt.matchtime = 1

-- # 入力
-- 改行時のインデントを自動化
vim.opt.smartindent = true                      
-- タブ文字
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- # 検索
-- 大文字無視
vim.opt.ignorecase = true
-- 大文字検索時、大文字小文字を区別する
vim.opt.smartcase = true
-- 検索結果が最後までいったら最初に戻る
vim.opt.wrapscan = true

-- # ファイル
-- ファイルの読み込み更新頻度
vim.opt.updatetime = 100
-- ファイル書き込み時の文字コードをutf-8にする
vim.opt.fileencoding = "utf-8"
-- ファイルを自動更新
vim.opt.autoread = true

-- # クリップボード
vim.opt.clipboard:append{"unnamedplus"}

-- # マウス
vim.opt.mouse = 'a'
