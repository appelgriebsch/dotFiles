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
    "hrsh7th/nvim-cmp",
    config = function()
      require("config.lsp")
    end,
    requires = {
      { "neovim/nvim-lspconfig" },
      { "williamboman/nvim-lsp-installer" },
      { "onsails/lspkind-nvim" },
      { "ray-x/lsp_signature.nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
      { "Saecki/crates.nvim" }
    }
  }
  use {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu"
  }
  use {
    "ahmedkhalf/lsp-rooter.nvim",
    config = function()
      require("lsp-rooter").setup()
    end
  }

  -- UI
  use {
    "glepnir/dashboard-nvim",
    config = function()
      require("config.dashboard")
    end
  }
  use {
    "hoob3rt/lualine.nvim",
    requires = {
      { "kyazdani42/nvim-web-devicons" },
      { "yamatsum/nvim-nonicons" }
    },
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
    config = function()
      require("config.blankline")
    end,
  }
  use { 
    "dstein64/nvim-scrollview",
    config = function() 
      require("config.scrollbar") 
    end 
  }
  use {
    "kazhala/close-buffers.nvim",
    config = function()
      require('close_buffers').setup()
    end
  }
  use {
    "rcarriga/nvim-notify",
    config = function()
      require("config.notify")
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

  -- Theme
  use {
    "projekt0n/github-nvim-theme",
    config = function() 
      require("config.theme")
    end
  }

  -- FZF
  use {
    "ibhagwan/fzf-lua",
    requires = {
      { "vijaymarupudi/nvim-fzf" },
      { "kyazdani42/nvim-web-devicons" }
    },
    config = function()
      require("config.fzf")
    end
  }
  use {
    "junegunn/fzf",
    run = "./install --bin"
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

  -- surround mode
  use {
    "blackCauldron7/surround.nvim",
    config = function()
      require("surround").setup({ mappings_style = "surround" })
    end
  }

  -- ranger integration
  use {
    "kevinhwang91/rnvimr",
    config = function() 
      require("config.rancher")
    end
  }

  -- REST client
  use {
    "NTBBloodbath/rest.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup({
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
      })
    end
  }

  -- orgmode
  use {
    "kristijanhusak/orgmode.nvim",
    config = function()
      require('orgmode').setup{}
    end
  }

  -- javascript packages
  use {
    "vuki656/package-info.nvim",
    requires = "MunifTanjim/nui.nvim",
    config = function()
      require('package-info').setup()
    end
  }

end)
