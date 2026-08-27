vim.o.guifont = "0xProto Nerd Font:h12"
vim.g.neovide_title_background_color = string.format(
    "0%x",
    vim.api.nvim_get_hl(0, {id=vim.api.nvim_get_hl_id_by_name("Normal")}).fg
)

vim.g.neovide_title_text_color = string.format(
    "%x",
    vim.api.nvim_get_hl(0, {id=vim.api.nvim_get_hl_id_by_name("Normal")}).bg
)

vim.g.neovide_corner_preference = "round"
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_remember_window_size = true
vim.g.neovide_highlight_matching_pair = true
vim.g.neovide_cursor_animation_length = 0.1
vim.g.neovide_cursor_trail_size = 0.0
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_animate_coimmand_line = false
