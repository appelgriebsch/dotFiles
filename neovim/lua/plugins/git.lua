local status_git, gitsigns = pcall(require, "gitsigns")
if not status_git then
  return
end

gitsigns.setup({
  signs = {
    add = { hl = "GitSignsAdd", text = "▍", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = {
      hl = "GitSignsChange",
      text = "▍",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl = "GitSignsDelete",
      text = "▸",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = "▾",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl = "GitSignsChange",
      text = "▍",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map({ "n", "v" }, "<leader>gj", "<CMD>Gitsigns next_hunk<CR>", { silent = true, desc = "next hunk" })
    map({ "n", "v" }, "<leader>gk", "<CMD>Gitsigns prev_hunk<CR>", { silent = true, desc = "previous hunk" })
    -- Actions
    map({ "n", "v" }, "<leader>gs", "<CMD>Gitsigns stage_hunk<CR>", { silent = true, desc = "stage hunk" })
    map({ "n", "v" }, "<leader>gr", "<CMD>Gitsigns reset_hunk<CR>", { silent = true, desc = "reset hunk" })
    map("n", "<leader>gu", gs.undo_stage_hunk, { silent = true, desc = "undo stage hunk" })
    map("n", "<leader>gp", gs.preview_hunk, { silent = true, desc = "preview hunk" })
    map("n", "<leader>gS", gs.stage_buffer, { silent = true, desc = "stage buffer" })
    map("n", "<leader>gR", gs.reset_buffer, { silent = true, desc = "reset buffer" })
    map("n", "<leader>gb", function() gs.blame_line { full = true } end, { silent = true, desc = "show blame" })
    map("n", "<leader>gd", gs.diffthis, { silent = true, desc = "show line diff" })
    map("n", "<leader>gD", function() gs.diffthis("~") end, { silent = true, desc = "show buffer diff" })
    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end
})

local status_gconflict, gconflict = pcall(require, "git-conflict")
if status_gconflict then
  gconflict.setup()
end

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end
