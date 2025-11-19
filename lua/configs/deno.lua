local defaults = require "nvchad.configs.lspconfig"

-- Helper function to check if we're in a Deno project
local function is_deno_project(fname)
  local root_dir = vim.fs.dirname(vim.fs.find({ "deno.json", "deno.jsonc" }, { upward = true, path = fname })[1])
  return root_dir ~= nil
end

-- Configure Deno LSP
local M = {}

M.setup = function()
  local lspconfig = require "lspconfig"

  lspconfig.denols.setup {
    on_attach = defaults.on_attach,
    capabilities = defaults.capabilities,
    root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
    init_options = {
      lint = true,
      unstable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
            ["https://cdn.nest.land"] = true,
            ["https://crux.land"] = true,
          },
        },
      },
    },
  }
end

return M
