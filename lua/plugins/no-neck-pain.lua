return {
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    enabled = true,
    opts = {
      width = 150,
      buffers = {
        right = { enabled = false },
      },
      mappings = {
        -- When `true`, creates all the mappings that are not set to `false`.
        --- @type boolean
        enabled = true,
        -- Sets a global mapping to Neovim, which allows you to toggle the plugin.
        -- When `false`, the mapping is not created.
        --- @type string
        toggle = "<Leader>NN",
        -- Sets a global mapping to Neovim, which allows you to toggle the left side buffer.
        -- When `false`, the mapping is not created.
        --- @type string
        toggleLeftSide = "<Leader>Nql",
        -- Sets a global mapping to Neovim, which allows you to toggle the right side buffer.
        -- When `false`, the mapping is not created.
        --- @type string
        toggleRightSide = "<Leader>Nqr",
        -- Sets a global mapping to Neovim, which allows you to increase the width (+5) of the main window.
        -- When `false`, the mapping is not created.
        --- @type string | { mapping: string, value: number }
        widthUp = "<Leader>N=",
        -- Sets a global mapping to Neovim, which allows you to decrease the width (-5) of the main window.
        -- When `false`, the mapping is not created.
        --- @type string | { mapping: string, value: number }
        widthDown = "<Leader>N-",
        -- Sets a global mapping to Neovim, which allows you to toggle the scratchPad feature.
        -- When `false`, the mapping is not created.
        --- @type string
        scratchPad = "<Leader>Ns",
      },
    },
  },
}
