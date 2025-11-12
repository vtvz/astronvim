return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "echasnovski/mini.icons",
    },
    opts = {
      defaults = {
        cache_picker = {
          num_pickers = 10,
        },
        layout_config = {
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
      },
    },
  },
}
