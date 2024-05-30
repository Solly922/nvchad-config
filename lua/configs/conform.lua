local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    css = { { "prettierd", "prettier" } },
    html = { { "prettierd", "prettier" } },
    javascript = { { "prettierd", "prettier" } },
    javascriptreact = { { "prettierd", "prettier" } },
    typescript = { { "prettierd", "prettier" } },
    typescriptreact = { { "prettierd", "prettier" } },

    go = { "goimports", "gofmt" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 100,
    lsp_fallback = true,
  },

  formatters = {
    prettierd = {
      arg = {
        "--single-attribute-per-line",
        "--trailing-comma=es5",
        "--print-width=80",
      },
    },
  },
}

require("conform").setup(options)
