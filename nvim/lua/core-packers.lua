require("packer").startup(function(use)
  -- Packer can manage itself
  use {
    "wbthomason/packer.nvim",
  }

  -- Common
  use {
    "nvim-lua/plenary.nvim",
  }

  -- File Explorer
  use {
    "nvim-tree/nvim-tree.lua",
  }
  use {
    "nvim-tree/nvim-web-devicons",
  }

  -- Fuzzy Finder
  use {
    "nvim-telescope/telescope.nvim",
  }

  -- Themes
  use {
    "nordtheme/vim",
  }

  -- Status Line
  use {
    "nvim-lualine/lualine.nvim",
  }

  -- Tab Line
  use {
    "akinsho/bufferline.nvim",
  }
end)

