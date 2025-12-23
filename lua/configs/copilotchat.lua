local CopilotChat = {}

CopilotChat.setup = function()
  local result_ok, copilot_chat = pcall(require, "copilot-chat")
  if not result_ok then
    return
  end

  copilot_chat.setup {
    highlight_headers = false,
    error_header = "> [!ERROR] Error",

    model = "gpt-5",
  }
end

return CopilotChat
