return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Theme
  use {
    "Shatur/neovim-ayu",
    config = function()
      require("config.theme")
    end
  }

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
    "williamboman/nvim-lsp-installer",
    config = function()
      require("config.lsp-installer")
    end,
    requires = {
      { "neovim/nvim-lspconfig" },
      { "ray-x/lsp_signature.nvim" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "L3MON4D3/LuaSnip" }
    }
  }
  use {
    "onsails/lspkind-nvim",
    config = function ()
      require("lspkind").init({
         mode = 'symbol'
      })
    end
  }
  use {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu"
  }
  use {
    "b0o/schemastore.nvim"
  }
  use {
    "Saecki/crates.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
        require("crates").setup()
    end,
  }
  use {
    "vuki656/package-info.nvim",
    requires = { "MunifTanjim/nui.nvim" },
    config = function()
      require("package-info").setup()
    end
  }
  use {
    "mfussenegger/nvim-jdtls",
    config = function()
      vim.cmd [[
        augroup jdtls_lsp
          autocmd!
          autocmd FileType java lua require("config.jdtls").setup()
        augroup end
      ]]
    end
  }

  -- UI
  use {
    "goolord/alpha-nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function ()
      require("config.dashboard")
    end
  }
  use {
    "hoob3rt/lualine.nvim",
    requires = {
      { "kyazdani42/nvim-web-devicons" },
      { "yamatsum/nvim-nonicons" },
      { "Shatur/neovim-ayu" }
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
  use {
    "ygm2/rooter.nvim"
  }
  use {
    "stevearc/dressing.nvim"
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

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "kyazdani42/nvim-web-devicons" }
    },
    config = function()
      require("config.telescope")
    end
  }
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
  use { "nvim-telescope/telescope-file-browser.nvim" }

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

  -- registers
  use "tversteeg/registers.nvim"

end)
