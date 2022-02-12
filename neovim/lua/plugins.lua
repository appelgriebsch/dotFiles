return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- core editing extensions
  use { "editorconfig/editorconfig-vim" }
  use { "tversteeg/registers.nvim" }
  use {
    "kazhala/close-buffers.nvim",
    config = function()
      require("close_buffers").setup()
    end
  }
  use {
    "lewis6991/spellsitter.nvim",
    config = function()
      require("spellsitter").setup()
    end
  }
  use {
    "blackCauldron7/surround.nvim",
    config = function()
      require("surround").setup({ mappings_style = "surround" })
    end
  }
  use {
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup()
    end
  }
  use { 
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim"
  }

  -- Treesitter extensions
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use {
    "p00f/nvim-ts-rainbow",
    event = "BufRead",
    module = "nvim-treesitter.fold",
    config = function()
      require("config.treesitter")
    end
  }

  -- LSP extensions
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
      { "L3MON4D3/LuaSnip" },
      { "ygm2/rooter.nvim" },
      { "b0o/schemastore.nvim" },
      {
        "onsails/lspkind-nvim",
        config = function ()
          require("lspkind").init({
             mode = "symbol"
          })
        end
      },
      {
        "Saecki/crates.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup()
        end,
      },
      {
        "vuki656/package-info.nvim",
        requires = { "MunifTanjim/nui.nvim" },
        config = function()
          require("package-info").setup()
        end
      },
      {
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
    }
  }

  -- UI extensions
  use {
    "Shatur/neovim-ayu",
    requires = {
      { "kyazdani42/nvim-web-devicons" },
      { "goolord/alpha-nvim",
        config = function ()
          require("config.dashboard")
        end
      },
      {
        "hoob3rt/lualine.nvim",
        requires = {
          { "kyazdani42/nvim-web-devicons" },
          { "yamatsum/nvim-nonicons" },
        },
        event = "VimEnter",
        config = function()
          require("config.lualine")
        end
      },
      {
        "akinsho/nvim-bufferline.lua",
        requires = { "kyazdani42/nvim-web-devicons" },
        event = "BufReadPre",
        config = function()
          require("config.bufferline")
        end,
      },
      {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        config = function()
          require("config.blankline")
        end,
      },
      {
        "dstein64/nvim-scrollview",
        config = function()
          require("config.scrollbar")
        end
      },
      {
        "rcarriga/nvim-notify",
        config = function()
          require("config.notify")
        end
      },
      {
        "norcalli/nvim-colorizer.lua",
        event = "BufReadPre",
        config = function()
          require("config.colorizer")
        end,
      },
      {
        "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup{}
        end,
      }
    },
    config = function()
      require("config.theme")
    end,
  }

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "kyazdani42/nvim-web-devicons" },
      { "nvim-telescope/telescope-github.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "nvim-telescope/telescope-project.nvim" },
      { "nvim-telescope/telescope-symbols.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "LinArcX/telescope-command-palette.nvim" },
      { "stevearc/dressing.nvim" },
    },
    config = function()
      require("config.telescope")
    end
  }

  -- Terminal
  use {
    "numtostr/FTerm.nvim",
    requires = {
      {
        "pianocomposer321/yabs.nvim",
        requires = { "nvim-lua/plenary.nvim" }
      }
    },
    config = function()
      require("config.fterm")
    end
  }

  -- GIT integrations
  use {
    "lewis6991/gitsigns.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "f-person/git-blame.nvim" },
    },
    event = "BufReadPre",
    config = function()
      require("config.gitsigns")
    end,
  }

  if jit.os == 'OSX' then
    use { "mrjones2014/dash.nvim", run = "make install" }
  end

end)
