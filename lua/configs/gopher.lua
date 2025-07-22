local Gopher = {}
local gopher = require "gopher"

Gopher.setup = function(opts)
  gopher.setup {
    commands = {
      go = "go",
      gomodifytags = "gomodifytags",
      gotests = "gotests",
      impl = "impl",
      iferr = "iferr",
    },
  }
end

return Gopher
