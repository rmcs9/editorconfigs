return {
	'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' },

	config = function() 
		require('telescope').setup({})
		local telescope = require("telescope.builtin")
		--FILE FINDING KEYBINDS
		--telescope file finder
		vim.keymap.set('n', '<leader>p', telescope.find_files, {})
	end
}
