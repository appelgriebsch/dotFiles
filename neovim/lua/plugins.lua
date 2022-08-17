local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  ---------------------
  -- Package Manager --
  ---------------------
  use "wbthomason/packer.nvim" -- Packer manage itself
  ----------------------
  -- Dependencies --
  ----------------------
  use { "nathom/filetype.nvim" }
  use { "nvim-lua/popup.nvim" }
  use { "nvim-lua/plenary.nvim" }
  use { "MunifTanjim/nui.nvim" }
  use { "stevearc/dressing.nvim" }
  use { "kyazdani42/nvim-web-devicons" }
  use { "linty-org/key-menu.nvim" }
  ----------------------
  -- UI extensions --
  ----------------------
  use {
    "olimorris/onedarkpro.nvim",
    requires = {
      {
        "goolord/alpha-nvim",
        config = function()
          require("plugins.dashboard")
        end
      },
      {
        "nvim-lualine/lualine.nvim",
        config = function()
          require("plugins.lualine")
        end
      },
      {
        "akinsho/bufferline.nvim",
        tag = "v2.*",
        config = function()
          require("plugins.bufferline")
        end,
      },
      {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
          require("plugins.blankline")
        end,
      },
      {
        "dstein64/nvim-scrollview",
        config = function()
          require("plugins.scrollbar")
        end
      },
      {
        "rcarriga/nvim-notify",
        config = function()
          require("plugins.notify")
        end
      },
      {
        "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup()
        end
      }
    },
    config = function()
      require("plugins.theme")
    end,
  }
  use({
    "aserowy/tmux.nvim",
    config = function()
      require("plugins.tmux")
    end
  })
  -----------------------------
  -- core editor extensions  --
  -----------------------------
  use { "editorconfig/editorconfig-vim" }
  use { "tversteeg/registers.nvim" }
  use {
    "notjedi/nvim-rooter.lua",
    event = "BufReadPre",
    config = function()
      require("nvim-rooter").setup()
    end
  }
  use {
    "kylechui/nvim-surround",
    tag = "*",
    event = "BufReadPre",
    config = function()
      require("nvim-surround").setup()
    end
  }
  use {
    "beauwilliams/focus.nvim",
    event = "BufReadPre",
    config = function()
      require("focus").setup({
        number = false,
        relativenumber = false
      })
    end
  }
  use {
    "mcauley-penney/tidy.nvim",
    event = "BufReadPre",
    config = function()
      require("tidy").setup()
    end
  }
  use {
    "ojroques/nvim-bufdel",
    event = "BufReadPre",
    config = function()
      require("bufdel").setup {
        next = "cycle", -- or "alternate"
        quit = true,
      }
    end
  }
  use {
    "numToStr/Comment.nvim",
    event = "BufReadPre",
    config = function()
      require("Comment").setup()
    end
  }
  use {
    "lewis6991/gitsigns.nvim",
    requires = {
      { "f-person/git-blame.nvim" },
      { "akinsho/git-conflict.nvim" }
    },
    event = "BufReadPre",
    config = function()
      require("plugins.git")
    end,
  }
  use {
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim"
  }
  use {
    "andythigpen/nvim-coverage",
    config = function()
      require("coverage").setup()
    end
  }
  use {
    "akinsho/toggleterm.nvim",
    tag = "v2.*",
    config = function()
      require("plugins.term")
    end
  }
  use {
    "NTBBloodbath/rest.nvim",
    config = function()
      require("plugins.rest")
    end
  }
  use {
    "Djancyp/cheat-sheet",
    config = function()
      require("plugins.cheatsheet")
    end
  }
  -- Dash integration on macOS only
  if vim.fn.has "mac" == 1 then
    use {
      "mrjones2014/dash.nvim",
      run = "make install",
    }
  end
  ----------------------------
  -- Treesitter extensions  --
  ----------------------------
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "nvim-treesitter/nvim-tree-docs" },
      { "p00f/nvim-ts-rainbow" },
      {
        "windwp/nvim-autopairs",
        config = function()
          require("nvim-autopairs").setup()
        end
      }
    },
    config = function()
      require("plugins.treesitter")
    end
  }
  ---------------------
  -- LSP extensions  --
  ---------------------
  use {
    "williamboman/mason.nvim",
    requires = {
      { "williamboman/mason-lspconfig.nvim" },
      { "neovim/nvim-lspconfig" },
      { "ray-x/lsp_signature.nvim" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "andersevenrud/cmp-tmux" },
      { "dcampos/nvim-snippy" },
      { "dcampos/cmp-snippy" },
      { "onsails/lspkind.nvim" },
      { "b0o/schemastore.nvim" },
      { "mfussenegger/nvim-jdtls" },
      { "simrat39/rust-tools.nvim" },
      { "nanotee/sqls.nvim" },
      {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        event = "BufReadPre",
        config = function()
          require("lsp_lines").setup()
        end,
      },
      {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        config = function()
          require("crates").setup()
        end,
      },
      {
        "vuki656/package-info.nvim",
        event = { "BufRead package.json" },
        config = function()
          require("package-info").setup()
        end
      },
    },
    config = function()
      require("plugins.lsp-setup")
    end,
  }
  --------------------------
  -- Telescop extensions  --
  --------------------------
  use {
    "nvim-telescope/telescope.nvim",
    branch = '0.1.x',
    requires = {
      { "nvim-telescope/telescope-github.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "nvim-telescope/telescope-project.nvim" },
      { "nvim-telescope/telescope-symbols.nvim" },
      { "tknightz/telescope-termfinder.nvim" },
      { "EthanJWright/vs-tasks.nvim" }
    },
    config = function()
      require("plugins.telescope")
    end
  }
  ---------------------
  -- DAP extensions  --
  ---------------------
  use {
    "mfussenegger/nvim-dap",
    requires = {
      { "nvim-telescope/telescope-dap.nvim" },
      { "theHamsta/nvim-dap-virtual-text" }
    },
    config = function()
      require("plugins.dap")
    end
  }
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
