local CopilotChat = {}

CopilotChat.setup = function()
  -- local result_ok, copilot_chat = pcall(require, "CopilotChat")
  -- if not result_ok then
  --   return
  -- end

  require("CopilotChat").setup {
    highlight_headers = false,
    error_header = "> [!ERROR] Error",

    model = "claude-opus-4.5",
  }
end

return CopilotChat
