return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    highlights = {
      init = {
        -- Native diff mode (claudecode.nvim split diff, vimdiff, gitsigns)
        DiffAdd = { bg = "#1e4620" },
        DiffChange = { bg = "#1c3a5e" },
        DiffDelete = { bg = "#5c1f24" },
        DiffText = { bg = "#2f5e9e", bold = true },

        -- claudecode.nvim inline diff
        ClaudeCodeInlineDiffAdd = { bg = "#1e4620" },
        ClaudeCodeInlineDiffDelete = { bg = "#5c1f24", strikethrough = true },
        ClaudeCodeInlineDiffAddSign = { fg = "#4caf50" },
        ClaudeCodeInlineDiffDeleteSign = { fg = "#f44336" },
      },
    },
  },
}