return {
  {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require("telescope").load_extension("frecency")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        cache_picker = {
          num_pickers = 10,
        },
      },
    },
  },
}
