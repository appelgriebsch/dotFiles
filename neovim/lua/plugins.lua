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
  use { "wbthomason/packer.nvim" }
  use { "lewis6991/impatient.nvim" }
  ----------------------
  -- Dependencies --
  ----------------------
  use { "stevearc/dressing.nvim" }
  use { "kyazdani42/nvim-web-devicons" }
  use {
    "olimorris/onedarkpro.nvim",
    config = function()
      require("plugins.theme")
    end
  }
  ----------------------
  -- UI extensions --
  ----------------------
  use {
    "goolord/alpha-nvim",
    requires = {
      {
        "nvim-lualine/lualine.nvim",
        config = function()
          require("plugins.lualine")
        end
      },
      {
        "akinsho/bufferline.nvim",
        tag = "*",
        config = function()
          require("plugins.bufferline")
        end,
      },
      {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufRead", "BufNewFile" },
        config = function()
          require("plugins.blankline")
        end,
      },
      {
        "dstein64/nvim-scrollview",
        event = { "BufRead", "BufNewFile" },
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
      },
      {
        "tiagovla/scope.nvim",
        config = function()
          require("scope").setup()
        end
      },
      {
        "lewis6991/hover.nvim",
        config = function()
          require("plugins.hover")
        end
      },
      {
        "folke/which-key.nvim",
        config = function()
          require("plugins.whichkey")
        end
      }
    },
    config = function()
      require("plugins.dashboard")
    end,
  }
  -----------------------------
  -- core editor extensions  --
  -----------------------------
  use { "editorconfig/editorconfig-vim" }
  use {
    "kylechui/nvim-surround",
    tag = "*",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("nvim-surround").setup()
    end
  }
  use {
    "mcauley-penney/tidy.nvim",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("tidy").setup()
    end
  }
  use { "famiu/bufdelete.nvim" }
  use {
    "numToStr/Comment.nvim",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("plugins.comment")
    end
  }
  use {
    "lewis6991/gitsigns.nvim",
    requires = {
      { "f-person/git-blame.nvim" },
      { "akinsho/git-conflict.nvim" }
    },
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("plugins.git")
    end,
  }
  use {
    "andythigpen/nvim-coverage",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("coverage").setup()
    end
  }
  use {
    "sindrets/diffview.nvim",
    requires = { "nvim-lua/plenary.nvim" }
  }
  use {
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("plugins.term")
    end
  }
  use {
    "samjwill/nvim-unception",
    config = function()
      vim.g.unception_open_buffer_in_new_tab = true
    end
  }
  use {
    "NTBBloodbath/rest.nvim",
    config = function()
      require("plugins.rest")
    end
  }
  use {
    "dimfred/resize-mode.nvim",
    config = function()
      require("plugins.resize-mode")
    end
  }
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
          require("plugins.autopairs")
        end
      }
    },
    config = function()
      require("plugins.treesitter")
    end
  }
  ----------------------------
  -- Completion extensions  --
  ----------------------------
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "dcampos/nvim-snippy" },
      { "dcampos/cmp-snippy" },
      { "onsails/lspkind.nvim" },
    },
    config = function()
      require("plugins.cmp")
    end,
  }
  ---------------------
  -- LSP extensions  --
  ---------------------
  use {
    "williamboman/mason.nvim",
    requires = {
      { "mfussenegger/nvim-lint" },
      { "williamboman/mason-lspconfig.nvim" },
      { "neovim/nvim-lspconfig" },
      { "ray-x/lsp_signature.nvim" },
      { "b0o/schemastore.nvim" },
      { "mfussenegger/nvim-jdtls" },
      { "simrat39/rust-tools.nvim" },
      { "nanotee/sqls.nvim" },
      { "David-Kunz/cmp-npm" },
      { "someone-stole-my-name/yaml-companion.nvim" },
      { "SmiteshP/nvim-navic" },
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
      require("plugins.mason")
    end,
  }
  --------------------------
  -- Telescop extensions  --
  --------------------------
  use {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-github.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "nvim-telescope/telescope-symbols.nvim" },
      { "nvim-telescope/telescope-project.nvim" },
      { "tknightz/telescope-termfinder.nvim" },
      { "debugloop/telescope-undo.nvim" },
      { "EthanJWright/vs-tasks.nvim" },
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
      { "theHamsta/nvim-dap-virtual-text" },
      { "mxsdev/nvim-dap-vscode-js" }
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
