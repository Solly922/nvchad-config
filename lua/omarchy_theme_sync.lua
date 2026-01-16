local M = {}

-- map omarchy theme -> nvchad theme
M.theme_map = {
  ["catppuccin"] = "catppuccin",
  ["gruvbox-dark"] = "gruvbox",
  ["catppuccin-mocha"] = "catppuccin",
  ["tokyo-night"] = "tokyonight",
  ["nord"] = "nord",
  ["osaka-jade"] = "nightlamp"
}

M.theme_file = vim.fn.expand("~/.config/omarchy/current/theme.name")

function M.apply_theme()
  local f = io.open(M.theme_file, "r")
  if not f then return end

  local omarchy_theme = f:read("*l")
  f:close()

  local nvchad_theme = M.theme_map[omarchy_theme]
  if not nvchad_theme then return end

  -- NvChad way to change themes
  require("nvconfig").base46.theme = nvchad_theme
  require("base46").load_all_highlights()
end

return M
