require("nvchad.configs.lspconfig").defaults()
local defaults = require "nvchad.configs.lspconfig"

local servers = {
  html = {},
  cssls = {},
  tailwindcss = {},
  tsserver = {
    cmd = { "typescript-language-server", "--stdio" },
    settings = {
      typescript = {
        format = {
          insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
          insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = true,
        },
      },
      javascript = {
        format = {
          insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
          insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = true,
        },
      },
    },
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
  },
  eslint = {},
  eslint_d = {},
  prettier = {},
  prettier_d = {},

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
        },
      },
    },
  },
}

for name, opts in pairs(servers) do
  vim.lsp.enable(name)
  vim.lsp.config(name, opts)
end

-- read :h vim.lsp.config for changing options of lsp servers
