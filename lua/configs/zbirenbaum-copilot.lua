local ZCopilot = {}

ZCopilot.setup = function()
  local result_ok, copilot = pcall(require, "copilot")
  if not result_ok then
    return
  end
  copilot.setup {
    copilot_model = "gpt-5.1-codex",
    panel = {
      enabled = true,
      auto_refresh = true,
      keymap = {
        open = "<M-p>",
      },
    },

    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = "<C-a>",
        accept_word = "<M-l>",
        accept_line = "<M-L>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
  }
end

return ZCopilot
