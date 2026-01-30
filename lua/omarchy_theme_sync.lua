local M = {}

-- map omarchy theme -> nvchad theme
M.theme_map = {
  ["tokyo-night"] = "tokyonight",
  ["catppuccin"] = "catppuccin",
  ["ethereal"] = "tokyodark", -- Ethereal doesn't have direct equivalent, using everforest as close match
  ["everforest"] = "everforest",
  ["gruvbox"] = "gruvbox",
  ["hackerman"] = "nightlamp",   -- Hackerman doesn't have direct equivalent, using onedark as dark theme
  ["osaka-jade"] = "tokyonight", -- Osaka Jade is Tokyo Night variant
  ["kanagawa"] = "kanagawa",
  ["nord"] = "nord",
  ["matte-black"] = "onedark",  -- Matte Black doesn't have direct equivalent, using onedark
  ["ristretto"] = "catppuccin", -- Ristretto is Catppuccin variant
  ["flexoki-light"] = "flexoki-light",
  ["rose-pine"] = "rosepine",
  ["catppuccin-latte"] = "catppuccin-latte",
  ["lowlight"] = "chocolate",
  ["bliss"] = "seoul256_light",
  ["hinterlands"] = "monochrome",
  ["waffle-cat"] = "melange",
  ["latchdark"] = "obsidian-ember",
  ["mechanoonna"] = "melange",
  ["rustleaf"] = "aylin",
  ["monolith"] = "aylin",
}

M.theme_file = vim.fn.expand "~/.config/omarchy/current/theme.name"

function M.apply_theme()
  local f = io.open(M.theme_file, "r")
  if not f then
    return
  end

  local omarchy_theme = f:read "*l"
  f:close()

  local nvchad_theme = M.theme_map[omarchy_theme]
  if not nvchad_theme then
    return
  end

  -- NvChad way to change themes
  require("nvconfig").base46.theme = nvchad_theme
  require("base46").load_all_highlights()

  require "transparency"
end

return M
