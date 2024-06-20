local BORDER_STYLE = 'rounded'
local telescope_border_chars = {
  none = { '', '', '', '', '', '', '', '' },
  single = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  double = { '═', '║', '═', '║', '╔', '╗', '╝', '╚' },
  rounded = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  solid = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  shadow = { '', '', '', '', '', '', '', '' },
}
local connected_telescope_border_chars = {
  none = { '', '', '', '', '', '', '', '' },
  single = { '─', '│', '─', '│', '┌', '┐', '┤', '├' },
  double = { '═', '║', '═', '║', '╔', '╗', '╣', '╠' },
  rounded = { '─', '│', '─', '│', '╭', '╮', '┤', '├' },
  solid = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  shadow = { '', '', '', '', '', '', '', '' },
}

local M = {
  border = BORDER_STYLE,
  telescope_border_chars = telescope_border_chars[BORDER_STYLE],
  telescope_centered_picker = {
    results_title = false,
    layout_strategy = 'center',
    layout_config = {
      anchor = 'S',
      preview_cutoff = 1,
      prompt_position = 'bottom',
      width = 0.95,
      results_height = 5,
    },
    border = true,
    borderchars = {
      prompt = telescope_border_chars[BORDER_STYLE],
      results = connected_telescope_border_chars[BORDER_STYLE],
      preview = telescope_border_chars[BORDER_STYLE],
    },
  },
  lazy_loaded_colorschemes = {
    'github_dark_dimmed',
  },
}

M.apply = function()
  local in_jsx = require('chrollo.config.utils').in_jsx_tags
end

return M
