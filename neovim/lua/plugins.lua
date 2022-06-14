return require("packer").startup({
  function()
    -- Packer can manage itself
    use "wbthomason/packer.nvim"
    -- UI extensions
    use {
      "olimorris/onedarkpro.nvim",
      requires = {
        { "kyazdani42/nvim-web-devicons" },
        {
          "goolord/alpha-nvim",
          config = function()
            require("config.dashboard")
          end
        },
        {
          "nvim-lualine/lualine.nvim",
          requires = {
            { "kyazdani42/nvim-web-devicons" },
            { "yamatsum/nvim-nonicons" }
          },
          event = "VimEnter",
          config = function()
            require("config.lualine")
          end
        },
        {
          "akinsho/bufferline.nvim",
          tag = "v2.*",
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
          event = "BufReadPre",
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
      },
      config = function()
        require("config.theme")
      end,
    }
    -- core editing extensions
    use { "editorconfig/editorconfig-vim" }
    use { "tversteeg/registers.nvim" }
    use {
      "kazhala/close-buffers.nvim",
      config = function()
        require("close_buffers").setup({})
      end
    }
    use {
      "lewis6991/spellsitter.nvim",
      config = function()
        require("spellsitter").setup({})
      end
    }
    use {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup({})
      end
    }
    use {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup({})
      end
    }
    -- Treesitter extensions
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
    use { "nvim-treesitter/nvim-treesitter-textobjects" }
    use { "nvim-treesitter/nvim-tree-docs" }
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
      requires = {
        { "neovim/nvim-lspconfig" },
        { "ray-x/lsp_signature.nvim" },
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lsp-document-symbol" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
        { "ygm2/rooter.nvim" },
        { "b0o/schemastore.nvim" },
        { "onsails/lspkind.nvim" },
        { "dcampos/nvim-snippy" },
        { "dcampos/cmp-snippy" },
        { "jose-elias-alvarez/typescript.nvim" },
        { "someone-stole-my-name/yaml-companion.nvim" },
        {
          "Saecki/crates.nvim",
          event = { 'BufRead Cargo.toml' },
          requires = { "nvim-lua/plenary.nvim" },
          config = function()
            require("crates").setup()
          end,
        },
        {
          "vuki656/package-info.nvim",
          event = { 'BufRead package.json' },
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
        },
        {
          "simrat39/rust-tools.nvim",
          requires = { "nvim-lua/plenary.nvim" }
        },
        {
          "Maan2003/lsp_lines.nvim",
          config = function()
            require("lsp_lines").register_lsp_virtual_lines()
          end,
        }
      },
      config = function()
        require("config.lsp-installer")
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
        { "tknightz/telescope-termfinder.nvim" },
        { "gfeiyou/command-center.nvim" },
        { "stevearc/dressing.nvim" },
      },
      config = function()
        require("config.telescope")
      end
    }
    -- DAP
    use {
      "mfussenegger/nvim-dap",
      requires = {
        { "nvim-telescope/telescope-dap.nvim" },
        { "theHamsta/nvim-dap-virtual-text" }
      },
      config = function()
        require("config.dap")
      end
    }
    -- Terminal
    use {
      "akinsho/toggleterm.nvim",
      config = function()
        require("config.term")
      end
    }
    -- GIT integrations
    use {
      "lewis6991/gitsigns.nvim",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "f-person/git-blame.nvim" }
      },
      event = "BufReadPre",
      config = function()
        require("config.gitsigns")
      end,
    }
    use {
      "sindrets/diffview.nvim",
      requires = { "nvim-lua/plenary.nvim" }
    }
    -- REST
    use {
      "NTBBloodbath/rest.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("config.rest")
      end
    }
    -- Dash integration on macOS only
    if jit.os == 'OSX' then
      use { "mrjones2014/dash.nvim", run = "make install" }
    end
  end,
  config = {
    display = {
      open_fn = require("packer.util").float,
    },
  }
})
