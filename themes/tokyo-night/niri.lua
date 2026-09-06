-- Tokyo Night theme for Niri compositor
-- Based on official Omarchy Tokyo Night theme colors

return {
  name = "Tokyo Night",
  description = "Deep night city blues with neon accents",

  colors = {
    -- Background
    bg = "#1a1b26",
    bg_secondary = "#16161e",
    bg_popup = "#24283b",

    -- Foreground
    fg = "#c0caf5",
    fg_secondary = "#a9b1d6",

    -- Window borders
    border_active = "#7aa2f7",
    border_inactive = "#3b4261",
    border_floating = "#bb9af7",

    -- Accent colors
    blue = "#7aa2f7",
    purple = "#bb9af7",
    green = "#9ece6a",
    red = "#f7768e",
    orange = "#ff9e64",
    yellow = "#e0af68",
    cyan = "#7dcfff",

    -- UI elements
    selection = "#33467c",
    error = "#f7768e",
    warning = "#e0af68",
    success = "#9ece6a",
    info = "#7aa2f7",
  },

  -- Niri-specific settings
  niri = {
    -- Window border width
    border_width = 2,

    -- Shadow settings
    shadow = {
      enabled = true,
      color = "#000000",
      offset = { x = 0, y = 4 },
      spread = 2,
      softness = 8,
    },

    -- Active window effects
    active_window = {
      border_color = "#7aa2f7",
      glow = {
        enabled = true,
        color = "#7aa2f7",
        intensity = 0.3,
      },
    },

    -- Inactive window
    inactive_window = {
      border_color = "#3b4261",
      opacity = 0.9,
    },

    -- Workspace indicator
    workspace = {
      active_bg = "#7aa2f7",
      active_fg = "#1a1b26",
      inactive_bg = "#24283b",
      inactive_fg = "#a9b1d6",
    },
  },
}
