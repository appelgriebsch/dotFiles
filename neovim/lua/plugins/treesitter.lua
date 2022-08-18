-- set up local treesitter plugins
local local_install = {
    "bash",
    "c",
    "cmake",
    "comment",
    "cpp",
    "css",
    "dockerfile",
    "dot",
    "gitignore",
    "go",
    "gomod",
    "graphql",
    "hcl",
    "help",
    "hjson",
    "html",
    "http",
    "java",
    "javascript",
    "jsdoc",
    "json",
    "json5",
    "jsonc",
    "julia",
    "kotlin",
    "latex",
    "llvm",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "norg",
    "pascal",
    "proto",
    "python",
    "regex",
    "rust",
    "scss",
    "sparql",
    "sql",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml"
};

if vim.fn.has "mac" == 1 then
  table.insert(local_install, "swift")
end

require('nvim-treesitter.configs').setup({
  ensure_installed = local_install,
  ignore_install = { "haskell" },
  rainbow = {
    enable = true,
    extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
  },
  highlight = { enable = true, use_languagetree = true },
  indent = { enable = true },
  context_commentstring = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-n>",
      node_incremental = "<C-n>",
      scope_incremental = "<C-s>",
      node_decremental = "<C-r>",
    },
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
      goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
      goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
      goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
    },
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["gD"] = "@function.outer",
      },
    },
    tree_docs = {
      enable = true
    }
  },
})

-- folding via treesitter
vim.api.nvim_exec([[
  set foldmethod=expr
  set foldlevel=99
  set foldexpr=nvim_treesitter#foldexpr()
]], false)
