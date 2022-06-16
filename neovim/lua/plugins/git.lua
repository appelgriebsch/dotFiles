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
    map({"n", "v"}, "<leader>ghj", ":Gitsigns next_hunk<CR>", { silent = true, desc = "Goto next hunk" })
    map({"n", "v"}, "<leader>ghk", ":Gitsigns prev_hunk<CR>", { silent = true, desc = "Goto previous hunk" })
    -- Actions
    map({"n", "v"}, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { silent = true, desc = "Stage current hunk" })
    map({"n", "v"}, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { silent = true, desc = "Reset current hunk" })
    map("n", "<leader>ghu", gs.undo_stage_hunk, { silent = true, desc = "Undo stage hunk" })
    map("n", "<leader>ghp", gs.preview_hunk, { silent = true, desc = "Preview hunk" })
    map("n", "<leader>ghS", gs.stage_buffer, { silent = true, desc = "Stage current buffer" })
    map("n", "<leader>ghR", gs.reset_buffer, { silent = true, desc = "Reset current buffer" })
    map("n", "<leader>ghb", function() gs.blame_line { full = true } end, { silent = true, desc = "Show Blame" })
    map("n", "<leader>ghd", gs.diffthis, { silent = true, desc = "Show Line Diff" })
    map("n", "<leader>ghD", function() gs.diffthis("~") end, { silent = true, desc = "Show Buffer Diff" })
    map("n", "<leader>gtb", gs.toggle_current_line_blame, { silent = true, desc = "Toggle Blame" })
    map("n", "<leader>gtd", gs.toggle_deleted, { silent = true, desc = "Toggle Deleted Lines" })
    -- Text object
    map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end
})

local status_menu, menu = pcall(require, "key-menu")
if not status_menu then
  return
end

menu.set("n", "<leader>g", { desc = "Git" })
menu.set("n", "<leader>gh", { desc = "Hunk" })
menu.set("n", "<leader>gt", { desc = "Toggle" })


