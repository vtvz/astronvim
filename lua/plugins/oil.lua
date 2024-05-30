local function get_searchable_dir()
  local dir = require("oil").get_current_dir()
  local entry = require("oil").get_cursor_entry()
  if entry and entry.type == "directory" then
    dir = dir .. "/" .. entry.parsed_name
  end

  return dir
end

return {
  {
    "stevearc/oil.nvim",
    opts = {
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["Y"] = function()
          local dir = require("oil").get_current_dir()
          local filename = require("oil").get_cursor_entry().parsed_name
          local filepath = dir .. filename

          require("user.utils").copy_filename(filepath)
        end,

        ["<Leader>fw"] = function()
          require("telescope.builtin").live_grep({
            search_dirs = { get_searchable_dir() },
          })
        end,

        ["<Leader>ff"] = function()
          require("telescope.builtin").find_files({
            search_dirs = { get_searchable_dir() },
          })
        end,
      },
      buf_options = {
        buflisted = true,
        bufhidden = "hide",
      },
      delete_to_trash = true,
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
