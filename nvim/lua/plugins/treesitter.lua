return {
	"nvim-treesitter/nvim-treesitter", build = ":TSUpdate",

	config = function() 
		--treesitter
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = {"c", "cpp", "lua", "java", "python", "kotlin", "go", "javascript"},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end
}
