require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!
o.linebreak = true

local opt = vim.opt
opt.relativenumber = true

-- Keep new lines indented inside blocks (functions, ifs, ...).
-- NvChad enables smartindent (C-braces only); autoindent is the fallback
-- that copies the previous line's indent, while treesitter/filetype indent
-- adds a level where the language supports it.
opt.autoindent = true
