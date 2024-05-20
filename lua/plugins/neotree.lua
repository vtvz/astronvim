return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    event_handlers = {
      {
        event = "neo_tree_window_after_open",
        handler = function()
          require("user.utils").neotree_open()
        end,
      },
      {
        event = "neo_tree_window_before_close",
        handler = function()
          require("user.utils").neotree_close()
        end,
      },
    },
    filesystem = {
      filtered_items = {
        hide_gitignored = false,
        always_show = {
          ".gitignore",
        },
        always_show_by_pattern = {
          ".env*",
        },
        never_show = {
          ".directory",
        },
        never_show_by_pattern = {
          ".null-ls_*",
        },
      },
      commands = {
        live_grep_directory = function(state)
          local node = state.tree:get_node()
          if node.type ~= "directory" then
            return
          end

          require("telescope.builtin").live_grep({
            search_dirs = { node.path },
          })
        end,
        git_srcr_open = function(state)
          local node = state.tree:get_node()
          if not node then
            return
          end
          local path = vim.fn.fnamemodify(node.path, ":.")
          local link = require("git_srcr").generate_link(path)
          require("git_srcr").open_link(link)
        end,
        git_srcr_yank = function(state)
          local node = state.tree:get_node()
          if not node then
            return
          end
          local path = vim.fn.fnamemodify(node.path, ":.")
          local link = require("git_srcr").generate_link(path)
          require("git_srcr").yank_link(link)
        end,
      },
      window = {
        mappings = {
          ["w"] = "live_grep_directory",
          ["<leader>vgx"] = "git_srcr_open",
          ["<leader>vyx"] = "git_srcr_yank",
        },
      },
    },
  },
}
