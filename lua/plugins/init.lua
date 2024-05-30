return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  -- {
  --   "mhartington/formatter.nvim",
  --   event = "VeryLazy",
  --   opts = function()
  --     require "custom.configs.formatter"
  --   end,
  -- },
  --
  -- {
  --   "mfussenegger/nvim-lint",
  --   event = "VeryLazy",
  --   config = function()
  --     require "custom.configs.lint"
  --   end,
  -- },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- default
        "lua-language-server",
        "stylua",

        -- web dev
        "html-lsp",
        "css-lsp",
        "prettier",
        "prettierd",
        "typescript-language-server",
        "eslint_d",

        -- golang
        "go",
        "gopls",
        "gofumpt",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",

        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",

        "go",
      },
    },
  },
}
