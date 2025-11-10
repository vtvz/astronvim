-- In v5, telescope is replaced by snacks.picker by default
-- This configuration re-enables telescope for backward compatibility
-- with your custom mappings
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "echasnovski/mini.icons", -- replaces nvim-web-devicons
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
