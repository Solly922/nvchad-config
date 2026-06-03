vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- typescript-tools.nvim still calls the deprecated codelens.refresh API.
-- Translate it to the current API until the plugin updates that call.
do
  local codelens = vim.lsp.codelens
  if codelens and codelens.enable then
    codelens.refresh = function(opts)
      vim.validate("opts", opts, "table", true)
      codelens.enable(true, { bufnr = opts and opts.bufnr })
    end
  end
end

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)

-- setup omarchy theme sync

local uv = vim.loop
local sync = require "omarchy_theme_sync"
if not sync then
  vim.notify("Failed to load omarchy_theme_sync module", vim.log.levels.ERROR)
  return
end

-- apply once on startup
sync.apply_theme()

local watcher = uv.new_fs_event()
if not watcher then
  vim.notify("Failed to create fs_event watcher for theme sync", vim.log.levels.ERROR)
  return
end
watcher:start(
  sync.theme_file,
  {},
  vim.schedule_wrap(function()
    sync.apply_theme()
  end)
)
