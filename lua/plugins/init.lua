return {

  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },


  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  {
  	"nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile"},
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  	opts = function()
      return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
      require "nvim-treesitter.configs".setup(opts)
    end
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
      require("plugins.configs.gopher").setup()
    end,
    --@type gopher.Config
    opts = {},
  },
  "leoluz/nvim-dap-go",

  -- AI
  {
    "github/copilot.vim",
    cmd = "Copilot",
    config = function()
      require("configs.copilot").config_vim()
    end,
    event = "BufEnter",
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
    event = "User FileOpened",
    enabled = true,
  },
}
