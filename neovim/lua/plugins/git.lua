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
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map({"n", "v"}, "<leader>bgj", "<CMD>Gitsigns next_hunk<CR>", { silent = true, desc = "Goto next hunk" })
    map({"n", "v"}, "<leader>bgk", "<CMD>Gitsigns prev_hunk<CR>", { silent = true, desc = "Goto previous hunk" })
    -- Actions
    map({"n", "v"}, "<leader>bgs", "<CMD>Gitsigns stage_hunk<CR>", { silent = true, desc = "Stage current hunk" })
    map({"n", "v"}, "<leader>bgr", "<CMD>Gitsigns reset_hunk<CR>", { silent = true, desc = "Reset current hunk" })
    map("n", "<leader>bgu", gs.undo_stage_hunk, { silent = true, desc = "Undo stage hunk" })
    map("n", "<leader>bgp", gs.preview_hunk, { silent = true, desc = "Preview hunk" })
    map("n", "<leader>bgS", gs.stage_buffer, { silent = true, desc = "Stage current buffer" })
    map("n", "<leader>bgR", gs.reset_buffer, { silent = true, desc = "Reset current buffer" })
    map("n", "<leader>bgb", function() gs.blame_line { full = true } end, { silent = true, desc = "Show Blame" })
    map("n", "<leader>bgd", gs.diffthis, { silent = true, desc = "Show Line Diff" })
    map("n", "<leader>bgD", function() gs.diffthis("~") end, { silent = true, desc = "Show Buffer Diff" })
    -- Text object
    map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end
})

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

menu.set("n", "<leader>bg", { desc = "Git" })
