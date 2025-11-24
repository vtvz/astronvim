return {
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
  },
  {
    "nvim-treesitter/playground",
    cmd = {
      "TSPlaygroundToggle",
      "TSCaptureUnderCursor",
      "TSHighlightCapturesUnderCursor",
    },
  },
  {
    "Joorem/vim-haproxy",
    event = "VeryLazy",
  },
  {
    -- Jinja2 template
    "HiPhish/jinja.vim",
    url = "https://gitlab.com/HiPhish/jinja.vim.git",
    event = "VeryLazy",
  },
  {
    -- Save with sudo
    "lambdalisue/suda.vim",
    cmd = {
      "SudaWrite",
    },
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nicwest/vim-camelsnek",
    event = "VeryLazy",
  },
  {
    "chaoren/vim-wordmotion",
    event = "VeryLazy",
  },
  {
    "dahu/vim-fanfingtastic",
    event = "VeryLazy",
  },
  {
    "nvim-pack/nvim-spectre",
    cmd = {
      "Spectre",
    },
    dependencies = { "nvim-lua/plenary.nvim", "echasnovski/mini.icons" },
    opts = {
      -- open_cmd = "enew",
      color_devicons = false,
      mapping = {
        ["replace_cmd"] = {
          map = "<leader>rC",
        },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
  },
  {
    "ckipp01/nvim-jenkinsfile-linter",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    opts = {
      font = "FiraCode Nerd Font Mono",
      to_clipboard = true,
      no_window_controls = true,
      line_offset = function(args)
        return args.line1
      end,
      pad_horiz = 10,
      pad_vert = 10,
      window_title = function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":.")
      end,
    },
  },
  {
    "wellle/targets.vim",
    event = "VeryLazy",
  },
}
