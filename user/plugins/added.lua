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
  {
    "declancm/cinnamon.nvim",
    event = "VeryLazy",
    opts = {
      default_delay = 1,
    },
    config = function(_, opts)
      require("cinnamon").setup(opts)
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    event = "VeryLazy",
    dependencies = "mason-lspconfig.nvim", -- make sure to load after mason-lspconfig
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
}
