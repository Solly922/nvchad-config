require("nvchad.configs.lspconfig").defaults()
require "configs.typescript-tools"
-- require("configs.deno").setup()

local function find_eslint_root(bufnr)
  local config_files = {
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json",
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.cjs",
    "eslint.config.ts",
    "eslint.config.mts",
    "eslint.config.cts",
  }

  local function read_file(path)
    local ok, content = pcall(vim.fn.readfile, path)
    if ok then
      return table.concat(content, "\n")
    end
  end

  local function package_json_has_key(dir, key)
    local package_json = dir .. "/package.json"
    if vim.fn.filereadable(package_json) ~= 1 then
      return false
    end

    local content = read_file(package_json)
    if not content then
      return false
    end

    local ok, decoded = pcall(vim.json.decode, content)
    return ok and type(decoded) == "table" and decoded[key] ~= nil
  end

  local function has_eslint_library(dir)
    if vim.fn.filereadable(dir .. "/node_modules/eslint/package.json") == 1 then
      return true
    end

    if vim.fn.executable "node" ~= 1 then
      return false
    end

    local result = vim.system({
      "node",
      "-e",
      "require.resolve('eslint/package.json')",
    }, { cwd = dir, text = true }):wait()

    return result.code == 0
  end

  local function config_dirs(path)
    local dirs = { path }
    for dir in vim.fs.parents(path) do
      dirs[#dirs + 1] = dir
    end
    return dirs
  end

  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local start_dir = vim.fs.dirname(bufname)
  if not start_dir then
    return nil
  end

  local eslint_config_dir
  for _, dir in ipairs(config_dirs(start_dir)) do
    if vim.fs.find(config_files, { path = dir, upward = false, limit = 1 })[1] then
      eslint_config_dir = dir
      break
    end

    if package_json_has_key(dir, "eslintConfig") then
      eslint_config_dir = dir
      break
    end
  end

  if not eslint_config_dir then
    return nil
  end

  if has_eslint_library(eslint_config_dir) then
    return eslint_config_dir
  end

  return nil
end

local servers = {
  html = {},
  cssls = {},
  tailwindcss = {},
  -- tsserver = {
  --   cmd = { "typescript-language-server", "--stdio" },
  --   settings = {
  --     typescript = {
  --       format = {
  --         insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
  --         insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = true,
  --       },
  --     },
  --     javascript = {
  --       format = {
  --         insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
  --         insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = true,
  --       },
  --     },
  --   },
  --   filetypes = {
  --     "javascript",
  --     "javascriptreact",
  --     "typescript",
  --     "typescriptreact",
  --   },
  -- },
  eslint = {
    root_dir = function(bufnr, on_dir)
      local root_dir = find_eslint_root(bufnr)
      if root_dir then
        on_dir(root_dir)
      end
    end,
  },
  eslint_d = {},
  prettier = {},
  prettier_d = {},
  typescript_tools = {},

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

  gh_actions_ls = {
    workspace_required = true,
  },
}

for name, opts in pairs(servers) do
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end

-- read :h vim.lsp.config for changing options of lsp servers
