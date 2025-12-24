return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    options = {
      ensure_installed = {
        -- lua
        "lua-language-server",
        "stylua",

        -- web dev
        "html-lsp",
        "cssls",
        "eslint-lsp",
        "eslint_d",
        "prettier",
        "prettierd",
        "typescript-language-server",
        "tailwindcss-language-server",
        "rustywind",
        "deno",

        -- golang
        "gofumpt",
        "goimports",
        "gopls",
        "golangci-lint-langserver",
      },
    },
  },

  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    opts = function()
      return require "configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Go
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "mfussenegger/nvim-dap",
    },
    build = function()
      vim.cmd.GoInstallDeps()
    end,
    config = function()
      require("configs.gopher").setup()
    end,
    --@type gopher.Config
    opts = {},
  },
  "leoluz/nvim-dap-go",

  -- AI
  -- {
  --   "github/copilot.vim",
  --   cmd = "Copilot",
  --   config = function()
  --     require("configs.ghcopilot").config_vim()
  --   end,
  --   event = "BufEnter",
  -- },
  {
    "zbirenbaum/copilot.lua",
    requires = {
      "copilotlsp-nvim/copilot-lsp",
      init = function()
        vim.g.copilot_nes_debounce = 300
      end,
    },
    cmd = "Copilot",
    event = "BufEnter",
    config = function()
      require("configs.zbirenbaum-copilot").setup()
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    -- config = function()
    --   require("CopilotChat").setup {
    --     highlight_headers = false,
    --     error_header = "> [!ERROR] Error",
    --
    --     model = "gpt-5",
    --   }
    -- end,
    config = function()
      require("configs.copilotchat").setup()
    end,
    event = "BufEnter",
    cmd = "CopilotChat",
  },

  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   cmd = {
  --     "SupermavenStart",
  --   },
  --   config = function()
  --     require("supermaven-nvim").setup {}
  --   end,
  --   event = "BufEnter",
  --
  -- },

  -- Wakatime
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },

  -- Autotag
  {
    "windwp/nvim-ts-autotag",
    event = "BufRead",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    enabled = true,
    config = function()
      require("illuminate").configure {
        providers = { "lsp", "treesitter", "regex" },
        under_cursor = true,
        should_enable = function(_)
          return true
        end,
      }
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown", "copilot-chat" },
    --@module 'render-markdown'
    --@type render.md.UserConfig
    opts = {
      render_modes = { "n", "c", "t" },
    },
    config = function()
      require("render-markdown").setup()
    end,
  },
}
