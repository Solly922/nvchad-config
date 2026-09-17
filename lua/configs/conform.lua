-- Helper function to detect if ESLint is configured for the file being formatted.
-- Resolved from the buffer's own directory upward, so a monorepo with nested
-- projects (e.g. frontend/ without ESLint next to server/ with ESLint)
-- classifies each file correctly no matter what Neovim's cwd is.
local function has_eslint_config(bufnr)
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

  -- Start from the file being formatted; fall back to cwd for unnamed buffers.
  local start_dir = vim.fn.getcwd()
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name ~= "" then
      start_dir = vim.fs.dirname(name)
    end
  end

  -- Find root directory by looking for package.json or git root
  local found = vim.fs.find({ "package.json", ".git" }, { path = start_dir, upward = true })
  if not found or #found == 0 then
    return false
  end

  local root_dir = vim.fs.dirname(found[1])
  if not root_dir then
    return false
  end

  -- Check for ESLint config files
  for _, file in ipairs(config_files) do
    if vim.fn.filereadable(root_dir .. "/" .. file) == 1 then
      return true
    end
  end

  -- Check for eslint in package.json
  local package_json = root_dir .. "/package.json"
  if vim.fn.filereadable(package_json) == 1 then
    local ok, content = pcall(vim.fn.readfile, package_json)
    if ok then
      local json_str = table.concat(content, "\n")
      -- Check for eslint in dependencies or devDependencies
      -- Pattern matches "eslint": to avoid false positives
      if json_str:match '"eslint"%s*:' then
        return true
      end
    end
  end

  return false
end

-- Function to determine formatters for JS/TS files
local function get_js_formatters(bufnr)
  if has_eslint_config(bufnr) then
    -- Run ESLint fixes first, then Prettier for style. ESLint's recommended
    -- sets carry no style rules, so ESLint alone leaves files unformatted.
    return { "eslint_d", "prettierd" }
  else
    return { "prettierd", "prettier", stop_after_first = true }
  end
end

-- Function to determine formatters for React files
local function get_react_formatters(bufnr)
  if has_eslint_config(bufnr) then
    -- Use ESLint for formatting/fixing, then rustywind for Tailwind classes
    -- return { { "eslint_d", "eslint", "prettierd", "prettier", stop_after_first = true }, "rustywind" }
    return { "eslint_d", "prettierd", "rustywind" }
  else
    return { "prettierd", "rustywind" }
    -- return { "prettierd", "rustywind", "prettier" }
  end
end

local blackd_client = [=[
import asyncio
import sys

from blackd.client import BlackDClient


async def main():
    source = sys.stdin.read()
    formatted = await BlackDClient().format_code(source)
    sys.stdout.write(formatted)


asyncio.run(main())
]=]

local blackd_available = [=[
import asyncio

from blackd.client import BlackDClient


async def main():
    await BlackDClient().format_code("")


asyncio.run(main())
]=]

local blackd_check_time = 0
local blackd_check_available = false

local function is_blackd_available(ctx)
  local filename = ctx and ctx.filename
  if filename and #vim.fs.find("pyproject.toml", { path = vim.fs.dirname(filename), upward = true }) > 0 then
    return false
  end

  local now = vim.loop.now()
  if now - blackd_check_time < 5000 then
    return blackd_check_available
  end

  vim.fn.system({ "python3", "-c", blackd_available })
  blackd_check_available = vim.v.shell_error == 0
  blackd_check_time = now

  return blackd_check_available
end

local options = {
  -- ESLint's cold start can take several seconds when loading a TypeScript project.
  -- Share the budget between manual formatting and format-on-save.
  default_format_opts = { timeout_ms = 10000 },

  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    javascript = get_js_formatters,
    typescript = get_js_formatters,
    javascriptreact = get_react_formatters,
    typescriptreact = get_react_formatters,

    python = { "blackd", "black", stop_after_first = true },

    go = { "gofumpt", "goimports" },
  },

  -- Configure formatters
  formatters = {
    prettierd = {
      prepend_args = { "--single-attribute-per-line" },
    },
    prettier = {
      prepend_args = { "--single-attribute-per-line" },
    },
    blackd = {
      command = "python3",
      args = { "-c", blackd_client },
      condition = function(_, ctx)
        return is_blackd_available(ctx)
      end,
    },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    lsp_fallback = true,
  },
}

return options
