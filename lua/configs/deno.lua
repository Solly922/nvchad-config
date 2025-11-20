local defaults = require "nvchad.configs.lspconfig"

-- Helper function to check if we're in a Deno project
local function is_deno_project(fname)
  -- Check for deno.json or deno.jsonc
  local root_dir = vim.fs.dirname(vim.fs.find({ "deno.json", "deno.jsonc" }, { upward = true, path = fname })[1])
  if root_dir then
    return true
  end

  -- Check if we're in a Supabase edge functions directory
  if fname:match "supabase/functions/" then
    return true
  end

  return false
end

-- Helper function to find root directory for Deno projects
local function find_deno_root(fname)
  -- First try to find deno.json/deno.jsonc
  local root_dir = vim.fs.dirname(vim.fs.find({ "deno.json", "deno.jsonc" }, { upward = true, path = fname })[1])
  if root_dir then
    return root_dir
  end

  -- For Supabase edge functions, find the supabase directory
  if fname:match "supabase/functions/" then
    local parts = vim.split(fname, "/")
    for i = #parts, 1, -1 do
      if parts[i] == "supabase" then
        return table.concat(vim.list_slice(parts, 1, i), "/")
      end
    end
  end

  return nil
end

-- Configure Deno LSP
local M = {}

M.setup = function()
  local lspconfig = require "lspconfig"

  lspconfig.denols.setup {
    on_attach = defaults.on_attach,
    capabilities = defaults.capabilities,
    root_dir = function(fname)
      return find_deno_root(fname)
    end,
    init_options = {
      lint = true,
      unstable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
            ["https://cdn.nest.land"] = true,
            ["https://crux.land"] = true,
            ["https://esm.sh"] = true,
          },
        },
      },
    },
  }
end

return M
