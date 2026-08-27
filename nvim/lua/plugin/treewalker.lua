local settings = {
    highlight = true,
    highlight_duration = 250,
    highlight_group = "Search",
    select = false,
    notifications = true,
    jumplist = true,
    scope_confined = false,
    keys = {
        {
            { "n", "v" },
            "<C-k>",
            "<cmd>Treewalker Up<cr>",
            desc = "Move to the previous neighbor node (Treewalker)",
            { silent = true },
        },
        {
            { "n", "v" },
            "<C-j>",
            "<cmd>Treewalker Down<cr>",
            desc = "Move to the next neighbor node (Treewalker)",
            { silent = true },
        },
        {
            { "n", "v" },
            "<C-h>",
            "<cmd>Treewalker Left<cr>",
            desc = "Move to the first ancestor node that's on a different line from the current node (Treewalker)",
            { silent = true },
        },
        {
            { "n", "v" },
            "<C-l>",
            "<cmd>Treewalker Right<cr>",
            desc = "Move to the next node down that's indented further than the current node (Treewalker)",
            { silent = true },
        },

        {
            "n",
            "<C-S-k>",
            "<cmd>Treewalker SwapUp<cr>",
            desc = "Swap the highest node on the line upwards in the document (Treewalker)",
            { silent = true },
        },
        {
            "n",
            "<C-S-j>",
            "<cmd>Treewalker SwapDown<cr>",
            desc = "Swap the highest node on the line downward in the document (Treewalker)",
            { silent = true },
        },
        {
            "n",
            "<C-S-h>",
            "<cmd>Treewalker SwapLeft<cr>",
            desc = "Swap the node under the cursor with it's previous neighbor (Treewalker)",
            { silent = true },
        },
        {
            "n",
            "<C-S-l>",
            "<cmd>Treewalker SwapRight<cr>",
            desc = "Swap the node under the cursor with its next neighbor (Treewalker)",
            { silent = true },
        },
    }
}

local M = {
    "aaronik/treewalker.nvim",
    opts = settings,
}

return M
