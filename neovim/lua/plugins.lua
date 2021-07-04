local packer = require("packer")

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use {
    "p00f/nvim-ts-rainbow",
    event = "BufRead",
    module = "nvim-treesitter.fold",
    config = function()
      require("config.treesitter")
    end
  }

  -- LSP
  use {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    config = function()
      require("config.lsp")
    end,
    requires = { { "kabouzeid/nvim-lspinstall" }, { "onsails/lspkind-nvim" }, { "nvim-lua/completion-nvim" } }
  }
  use {
    "norcalli/snippets.nvim",
    config = function() 
      require("config.snippets")
    end
  }

  -- DAP
  use {
    "mfussenegger/nvim-dap",
    requires = { "theHamsta/nvim-dap-virtual-text" },
    config = function()
      require("config.dap")
    end
  }

  -- UI
  use {
    "glepnir/dashboard-nvim",
    requires = { "junegunn/fzf.vim" },
    config = function()
      require("config.dashboard")
    end
  }
  use {
    "hoob3rt/lualine.nvim",
    requires = { { "kyazdani42/nvim-web-devicons" }, { "yamatsum/nvim-nonicons" } },
    event = "VimEnter",
    config = function() 
      require("config.lualine")
    end
  }
  use {
    "akinsho/nvim-bufferline.lua", 
    requires = { "kyazdani42/nvim-web-devicons" },
    event = "BufReadPre",
    config = function()
      require("config.bufferline")
    end,
  }
  use {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    branch = "lua",
    config = function()
      require("config.blankline")
    end,
  }
  use { 
    "Xuyuanp/scrollbar.nvim",
    config = function() 
      require("config.scrollbar") 
    end 
  }

  -- GIT
  use {
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    event = "BufReadPre",
    config = function()
      require("config.gitsigns")
    end,
  }
  use "f-person/git-blame.nvim"
  use { 
    "pwntester/octo.nvim", 
    requires = { { "nvim-lua/plenary.nvim" }, { "nvim-lua/popup.nvim" } } 
  }

  -- Theme
  use {
    "Shatur/neovim-ayu",
    config = function() 
      require("config.theme")
    end
  }

  -- FZF
  use {
    "gfanto/fzf-lsp.nvim",
    requires = { "junegunn/fzf.vim" },
    config = function()
      require("config.fzf")
    end
  }

  -- split diff view
  use {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("config.diffview")
    end,
  }

  -- terminal
  use {
    "numtostr/FTerm.nvim",
    config = function()
      require("config.fterm")
    end
  }

  -- lsp rooter
  use {
    "ahmedkhalf/lsp-rooter.nvim",
    config = function()
      require("lsp-rooter").setup() 
    end
  }

  -- sql
  use {
    "nanotee/sqls.nvim",
    config = function()
      require("config.sqls")
    end
  }

  -- spellchecker
  use {
    "lewis6991/spellsitter.nvim",
    config = function()
      require("spellsitter").setup()
    end
  }

  use "editorconfig/editorconfig-vim"

  -- colors in vim
  use {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("config.colorizer")
    end,
  }

  -- ranger integration
  use {
    "kevinhwang91/rnvimr",
    config = function() 
      require("config.rancher")
    end
  }

end)
