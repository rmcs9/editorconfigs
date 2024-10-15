--editor line nums
vim.cmd("set number")
vim.cmd("set shiftwidth=4")
vim.cmd("set tabstop=4")
vim.g.mapleader = ' '
vim.opt.termguicolors = true

--lazy pm setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--plugins and dependencies list
local plugins = {

	-- telescope 
	{'nvim-telescope/telescope.nvim', tag = '0.1.5',dependencies = { 'nvim-lua/plenary.nvim' }},


	--treesitter
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},


	-- code completion
	{	
		"ms-jpq/coq_nvim",
		dependencies={	
			{"ms-jpq/coq.artifacts"},
			{"ms-jpq/coq.thirdparty"},
		}
	},


	-- undotree
	{"mbbill/undotree"},


	-- lspconfig and dependencies
	{
		'neovim/nvim-lspconfig',
		dependancies={
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/nvim-cmp'},
			{'L3MON4D3/LuaSnip'},
		}
	},
	

	-- lua line {editor status line}
	{'nvim-lualine/lualine.nvim',dependencies = { 'nvim-tree/nvim-web-devicons' }},


	-- mason
	{"williamboman/mason.nvim"},
	{"williamboman/mason-lspconfig.nvim"},


	-- comment plugin
	{'numToStr/Comment.nvim',lazy = false,},	


	--trouble error plugin
	{
		"folke/trouble.nvim",
 		dependencies = { "nvim-tree/nvim-web-devicons" },
 		opts = {}, 
  		cmd = "Trouble",
  		keys = {
    		{
      			"<leader>t",
      			"<cmd>Trouble diagnostics toggle<cr>",
      			desc = "Diagnostics (Trouble)",
    		},
		}
	},


	-- neo tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		}, 
	},

	-- indent underlining and highlighting
	{
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
	},

	{'eandrju/cellular-automaton.nvim'},

	{'ojroques/nvim-osc52'}, 

	--THEMES
	--blue moon theme
	{"kyazdani42/blue-moon"},
	--evangelion theme
	{"nyngwang/nvimgelion"},
	-- falcon theme
	{"fenetikm/falcon", name = "falcon", lazy = false, priority = 1000},
}
local opts = {}

require("lazy").setup(plugins, opts)




local telescope = require("telescope.builtin")
--FILE FINDING KEYBINDS
--telescope file finder
vim.keymap.set('n', '<leader>p', telescope.find_files, {})
--telescope live grep
vim.keymap.set('n', '<leader>o', telescope.live_grep, {})
--undo tree
vim.keymap.set('n', '<leader>i', vim.cmd.UndotreeToggle, {})
--neo tree
vim.keymap.set('n', '<leader>e', vim.cmd.Neotree, {})
-- space + r {file explorer}
vim.keymap.set('n', '<leader>r', vim.cmd.Explore, {})


--undo tree configuration
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

--osc52 clipboard operations
--copy given text in normal mode
vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
--copy given text on current line
vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
--copy given text in visual mode
vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)


--LSP CONFIGURATION
require("mason").setup()
require("mason-lspconfig").setup()
--ADD MORE LANGUAGE SERVERS HERE
--https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local lspconfig = require("lspconfig")
local coq = require("coq")
lspconfig.clangd.setup(coq.lsp_ensure_capabilities())
lspconfig.jdtls.setup(coq.lsp_ensure_capabilities()) 
lspconfig.pyright.setup(coq.lsp_ensure_capabilities())
lspconfig.kotlin_language_server.setup(coq.lsp_ensure_capabilities())
lspconfig.gopls.setup(coq.lsp_ensure_capabilities())
lspconfig.vtsls.setup(coq.lsp_ensure_capabilities())
--turn on code completion
vim.cmd("COQnow --shut-up")
--treesitter
local config = require("nvim-treesitter.configs")
config.setup({
	ensure_installed = {"c", "cpp", "lua", "java", "python", "kotlin", "go", "javascript"},
	sync_install = false,
	highlight = { enable = true },
	indent = { enable = true },
})

-- indent underlining setup
require("ibl").setup()
--indent underlining colorscheme
vim.api.nvim_create_autocmd({ 'ColorScheme', 'FileType' }, {
  callback = function ()
    vim.cmd([[
      hi IndentBlanklineChar gui=nocombine guifg=#444C55
      hi IndentBlanklineSpaceChar gui=nocombine guifg=#444C55
      hi IndentBlanklineContextChar gui=nocombine guifg=#FB5E2A
      hi IndentBlanklineContextStart gui=underline guisp=#FB5E2A
    ]])
  end,
})


-- comment shortcuts
-- "gc" to comment out line or selection
require("Comment").setup()

--editor bottom line
require('lualine').setup()

--current theme cycle:
-- falcon
-- nvimgelion
-- blue-moon
vim.cmd.colorscheme "nvimgelion"
