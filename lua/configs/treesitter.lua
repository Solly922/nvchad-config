local options = {
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "html",
    "css",
    "javascript",
    "typescript",
    "jsdoc",
    "go",
    "gotmpl",
    "gomod",
    "gosum",
    "gowork",
    "php",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
}

local function capture_node(capture)
  if capture == nil then
    return nil
  end

  if pcall(function()
    capture:range()
  end) then
    return capture
  end

  if type(capture) ~= "table" then
    return nil
  end

  for _, node in ipairs(capture) do
    if pcall(function()
      node:range()
    end) then
      return node
    end
  end
end

function options.setup_query_compat()
  local directive_opts = vim.fn.has "nvim-0.10" == 1 and { force = true, all = false } or true
  local aliases = {
    ex = "elixir",
    pl = "perl",
    sh = "bash",
    ts = "typescript",
    uxn = "uxntal",
  }

  vim.treesitter.query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local node = capture_node(match[pred[2]])
    if not node then
      return
    end

    local info_string = vim.treesitter.get_node_text(node, bufnr):lower()
    metadata["injection.language"] = vim.filetype.match { filename = "a." .. info_string } or aliases[info_string] or info_string
  end, directive_opts)
end

return options
