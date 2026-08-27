vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open the directory tree from the current location."})
vim.keymap.set("n", "<leader>ws", vim.cmd("set list!"), { desc = "Toggle visible whitespace.", })
vim.keymap.set("n", "<leader>dl", vim.cmd.DarkLightSwitch, { desc = 'Switch between light and dark modes.'})

vim.keymap.set("n", "<leader>bp", vim.cmd("bp"), { desc = "Switch to the previous buffer." })
vim.keymap.set("n", "<leader>bp", vim.cmd("bn"), { desc = "Switch to the next buffer." })

vim.keymap.set("n", "<leader>tn", vim.cmd("tabnew"), { desc = "Open a new tab." })
vim.keymap.set("n", "<leader>tc", vim.cmd("tabclose"), { desc = "Close the current tab." })
