require("nvchad.configs.lspconfig").defaults()

local function organize_imports()
  local params = {
    command = "typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name },
  }

  return params
end

local servers = {
  html = {},
  cssls = {},
  tailwindcss = {},
  tsserver = {
    command = {
      OrganizeImports = {
        organize_imports,
        description = "Organize imports in TypeScript files",
      }
    }
  },

  golangci_lint_ls = {},
  gopls = {
    settings = {
      gopls = {
        usePlaceholders = true,
        gofumpt = true,
        codelenses = {
          generate = true,
          gc_details = true,
          test = true,
          tidy = true,
        }
      }
    }
  }
}

for name, opts in pairs(servers) do
  vim.lsp.enable(name)
  vim.lsp.config(name, opts)
end

-- read :h vim.lsp.config for changing options of lsp servers
