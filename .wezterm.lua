-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.set_environment_variables = {
  TERMINFO_DIRS = '/usr/share/terminfo'
}

config.term = 'wezterm'

config.tiling_desktop_environments = {
  'X11 i3'
}

config.enable_tab_bar = false
config.font_size = 20.0
config.font = wezterm.font ({
    family = 'NotoSansM Nerd Font',
    weight = 'DemiBold',
})
config.force_reverse_video_cursor = false
config.cursor_thickness = "2pt"
config.window_close_confirmation = 'NeverPrompt'

config.window_background_gradient = {
  -- Can be "Vertical" or "Horizontal".  Specifies the direction
  -- in which the color gradient varies.  The default is "Horizontal",
  -- with the gradient going from left-to-right.
  -- Linear and Radial gradients are also supported; see the other
  -- examples below
  -- orientation = {
  --   Linear = { angle = 15.0 }
  -- },
  orientation = {
    Radial = {cx = 0.5, cy = 0.5, radius = 0.65}
  },

  -- Specifies the set of colors that are interpolated in the gradient.
  -- Accepts CSS style color specs, from named colors, through rgb
  -- strings and more
  colors = {
    '#00394d',
    '#00131a',
  },

  -- Instead of specifying `colors`, you can use one of a number of
  -- predefined, preset gradients.
  -- A list of presets is shown in a section below.
  -- preset = "Warm",

  -- Specifies the interpolation style to be used.
  -- "Linear", "Basis" and "CatmullRom" as supported.
  -- The default is "Linear".
  interpolation = 'Basis',

  -- How the colors are blended in the gradient.
  -- "Rgb", "LinearRgb", "Hsv" and "Oklab" are supported.
  -- The default is "Rgb".
  blend = 'Rgb',

  -- To avoid vertical color banding for horizontal gradients, the
  -- gradient position is randomly shifted by up to the `noise` value
  -- for each pixel.
  -- Smaller values, or 0, will make bands more prominent.
  -- The default value is 64 which gives decent looking results
  -- on a retina macbook pro display.
  -- noise = 64,

  -- By default, the gradient smoothly transitions between the colors.
  -- You can adjust the sharpness by specifying the segment_size and
  -- segment_smoothness parameters.
  -- segment_size configures how many segments are present.
  -- segment_smoothness is how hard the edge is; 0.0 is a hard edge,
  -- 1.0 is a soft edge.

  -- segment_size = 11,
  -- segment_smoothness = 0.0,
}

config.color_scheme = 'Kanagawa (Gogh)'

config.colors = {
  -- The default text color
  foreground = '#c3e600',
  -- The default background color
  background = '#013345',

  -- Overrides the cell background color when the current cell is occupied by the
  -- cursor and the cursor style is set to Block
  cursor_bg = 'Orange',
  -- Overrides the text color when the current cell is occupied by the cursor
  cursor_fg = 'Black',
  -- Specifies the border color of the cursor when the cursor style is set to Block,
  -- or the color of the vertical or horizontal bar when the cursor style is set to
  -- Bar or Underline.
  cursor_border = 'Orange',

  -- the foreground color of selected text
  selection_fg = '00000000',
  -- the background color of selected text
  selection_bg = '#213249',

  -- The color of the scrollbar "thumb"; the portion that represents the current viewport
  scrollbar_thumb = '#222222',

  -- The color of the split lines between panes
  split = '#444444',

  ansi = {
    '#090618',
    '#C34043',
    '#76946A',
    '#C0A36E',
    '#7E9CD8',
    '#957FB8',
    '#6A9589',
    '#C8C093',
  },
  brights = {
    '#727169',
    '#E82424',
    '#98BB6C',
    '#E6C384',
    '#7FB4CA',
    '#938AA9',
    '#7AA89F',
    'Orange',
  },

  -- Arbitrary colors of the palette in the range from 16 to 255
  indexed = { [136] = '#af8700' },

  -- Since: 20220319-142410-0fcdea07
  -- When the IME, a dead key or a leader key are being processed and are effectively
  -- holding input pending the result of input composition, change the cursor
  -- to this color to give a visual cue about the compose state.
  compose_cursor = 'orange',

  -- Colors for copy_mode and quick_select
  -- available since: 20220807-113146-c2fee766
  -- In copy_mode, the color of the active text is:
  -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
  -- 2. selection_* otherwise
  copy_mode_active_highlight_bg = { Color = '#000000' },
  -- use `AnsiColor` to specify one of the ansi color palette values
  -- (index 0-15) using one of the names "Black", "Maroon", "Green",
  --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
  -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
  copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
  copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
  copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

  quick_select_label_bg = { Color = 'peru' },
  quick_select_label_fg = { Color = '#ffffff' },
  quick_select_match_bg = { AnsiColor = 'Navy' },
  quick_select_match_fg = { Color = '#ffffff' },
}

config.keys = {
  {
    key = "Enter",
    mods = "CTRL|SHIFT",
    action = wezterm.action{
      SpawnCommandInNewWindow = {
        domain = 'CurrentPaneDomain'
      }
    },
  }
}

-- and finally, return the configuration to wezterm
return config
