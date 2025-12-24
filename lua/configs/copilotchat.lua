local CopilotChat = {}

CopilotChat.setup = function()
  print "Setting up Copilot Chat"
  -- local result_ok, copilot_chat = pcall(require, "CopilotChat")
  -- if not result_ok then
  --   return
  -- end

  require("CopilotChat").setup {
    highlight_headers = false,
    error_header = "> [!ERROR] Error",

    model = "claude-opus-4.5",
  }
  print "Copilot Chat setup complete"
end

return CopilotChat
