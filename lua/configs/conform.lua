-- Helper function to detect if ESLint is configured in the project
local function has_eslint_config()
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
  }

  -- Find root directory by looking for package.json or git root
  local found = vim.fs.find({ "package.json", ".git" }, { upward = true })
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
local function get_js_formatters()
  if has_eslint_config() then
    -- Try eslint_d first (faster), then eslint, then fall back to prettier
    return { "eslint_d", "eslint", "prettierd", "prettier", stop_after_first = true }
  else
    return { "prettierd", "prettier", stop_after_first = true }
  end
end

-- Function to determine formatters for React files
local function get_react_formatters()
  if has_eslint_config() then
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
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
