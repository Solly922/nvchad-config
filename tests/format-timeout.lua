-- Run from the config root: nvim --headless -u NONE -l tests/format-timeout.lua
vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.rtp:append(vim.fn.stdpath "data" .. "/lazy/conform.nvim")

local options = require "configs.conform"
assert(options.default_format_opts.timeout_ms == 10000)
assert(options.format_on_save.timeout_ms == nil, "Save must inherit the shared timeout")

-- Exceed both old deadlines without depending on an ESLint daemon or project.
options.formatters.slow = {
  command = "sh",
  args = { "-c", "sleep 1.2; printf 'formatted\\n'" },
  stdin = true,
}
options.formatters_by_ft.timeout_test = { "slow" }
local conform = require "conform"
conform.setup(options)
vim.bo.filetype = "timeout_test"

-- Exercise the same call used by NvChad's manual formatting mapping.
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "unformatted" })
local completed = false
conform.format({ lsp_fallback = true }, function(err)
  assert(not err, err)
  completed = true
end)
assert(completed)
assert(vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] == "formatted")

-- Trigger the actual save hook without writing a file to disk.
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "unformatted" })
vim.api.nvim_exec_autocmds("BufWritePre", { buffer = 0 })
assert(vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] == "formatted")
print "PASS: manual and save formatting tolerate cold starts"
