-- Tokyo Night for Neovim
-- https://github.com/folke/tokyonight.nvim

return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    transparent = true,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      functions = { italic = false },
      variables = { italic = false },
    },
    colors = {
      border = "#3b4261",
    },
  },
}
