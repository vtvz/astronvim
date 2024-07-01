return {
  {
    "fatih/vim-go",
    event = "VeryLazy",
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
  },
  -- {
  --   "IndianBoy42/tree-sitter-just",
  --   event = "VeryLazy",
  --   after = "nvim-treesitter",
  --   config = function()
  --     require("tree-sitter-just").setup({})
  --   end,
  -- },
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
    config = function(_, opts)
      require("nvim-surround").setup(opts)
    end,
  },
  -- Smooth scrolling
  --[[ {
    "declancm/cinnamon.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        delay = 1,
      },
    },
    config = function(_, opts)
      require("cinnamon").setup(opts)
    end,
  }, ]]
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
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    opts = {
      -- open_cmd = "enew",
      color_devicons = false,
      mapping = {
        ["replace_cmd"] = {
          map = "<leader>rC",
        },
      },
    },
    config = function(_, opts)
      require("spectre").setup(opts)
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function(_, opts)
      require("todo-comments").setup(opts)
    end,
  },
  {
    "Wansmer/treesj",
    keys = { "<space>m", "<space>M" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })
      -- For use default preset and it work with dot
      vim.keymap.set("n", "<leader>m", require("treesj").toggle)
      -- For extending default preset with `recursive = true`, but this doesn't work with dot
      vim.keymap.set("n", "<leader>M", function()
        require("treesj").toggle({ split = { recursive = true } })
      end)
    end,
  },
  {
    "ckipp01/nvim-jenkinsfile-linter",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- {
  --   "ThePrimeagen/harpoon",
  --   branch = "harpoon2",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   config = function(_, opts)
  --     local harpoon = require("harpoon")
  --
  --     -- REQUIRED
  --     harpoon:setup(opts)
  --     harpoon.ui:toggle_quick_menu(harpoon:list())
  --   end,
  -- },
  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    config = function()
      require("silicon").setup({
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
      })
    end,
  },
  {
    "wellle/targets.vim",
    event = "VeryLazy",
  },
}
