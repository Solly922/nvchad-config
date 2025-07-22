local Supermaven = {}

Supermaven.config = function()
  local result_ok, supermaven = pcall(require, "supermaven")
  if not result_ok then
    return
  end

  supermaven.setup {
    keymaps = {
      accept_suggestion = "<C-a>",
      clear_suggestion = "<C-]>",
      accept_word = "<C-j>",
    },
    ignore_filetypes = { cpp = true },
    color = {
      suggestion_color = "#ffffff",
      cterm = 244,
    },
    -- disables inline completion for use with cmp
    disable_inline_completion = false,
    -- disables built in keymaps for more manual control
    disable_keymaps = false,
  }
end

return Supermaven
