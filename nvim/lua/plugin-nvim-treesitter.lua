require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "dockerfile",
    "go",
    "html",
    "json",
    "kdl",
    "kotlin",
    "lua",
    "make",
    "markdown",
    "proto",
    "rust",
    "scala",
    "scss",
    "sql",
    "toml",
    "typescript",
    "yaml",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}
