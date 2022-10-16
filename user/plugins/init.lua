return {
	["lambdalisue/suda.vim"] = {
		-- Save with sudo
		cmd = {
			"SudaWrite",
		},
	},
	["nvim-treesitter/playground"] = {
		cmd = {
			"TSPlaygroundToggle",
			"TSCaptureUnderCursor",
			"TSHighlightCapturesUnderCursor",
		},
	},
	["tpope/vim-surround"] = {
		-- Surround with things
	},
	["declancm/cinnamon.nvim"] = {
		-- Smooth scrolling
		config = function()
			require("cinnamon").setup()
		end,
	},
	["hrsh7th/cmp-nvim-lua"] = {
		after = "nvim-cmp",
		config = function()
			astronvim.add_user_cmp_source({ name = "nvim_lua", priority = 1000 })
		end,
	},
	["hrsh7th/cmp-nvim-lsp-signature-help"] = {
		after = "nvim-cmp",
		config = function()
			astronvim.add_user_cmp_source({ name = "nvim_lsp_signature_help", priority = 1000 })
		end,
	},
	["milisims/nvim-luaref"] = {},
	["simrat39/rust-tools.nvim"] = {
		after = "mason-lspconfig.nvim", -- make sure to load after mason-lspconfig
		config = function()
			local rt = require("rust-tools")

			rt.setup({
				server = astronvim.lsp.server_settings("rust_analyzer"), -- get the server settings and built in capabilities/on_attach
			})

			rt.inlay_hints.enable()
		end,
	},
}
