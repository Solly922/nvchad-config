local CopilotChat = {}

CopilotChat.setup = function()
  local result_ok, copilot_chat = pcall(require, "copilot-chat")
  if not result_ok then
    return
  end

  local map = vim.keymap.set
  map("n", "<leader>cc", "<cmd>CopilotChat<cr>", { desc = "Open Copilot Chat" })
  map("n", "<leader>cC", "<cmd>CopilotChatClose<cr>", { desc = "Close Copilot Chat" })

  copilot_chat.setup {
    highlight_headers = false,
    error_header = "> [!ERROR] Error",

    model = "gpt-5",
  }
end

return CopilotChat
