vim.cmd("set number")
vim.cmd("set shiftwidth=4")
vim.cmd("set tabstop=4")
vim.g.mapleader = ' '
-- space + e {file explorer}
vim.keymap.set('n', '<leader>r', vim.cmd.Explore, {})

--lazy pm
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
-- falcon theme
{"fenetikm/falcon", name = "falcon", lazy = false, priority = 1000},
{
  "xero/miasma.nvim",
  lazy = false,
  priority = 1000,
},
-- telescope 
{'nvim-telescope/telescope.nvim', tag = '0.1.5',dependencies = { 'nvim-lua/plenary.nvim' }},
--treesitter
{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
-- code completion
{"ms-jpq/coq_nvim"},
{"ms-jpq/coq.artifacts"},
{"ms-jpq/coq.thirdparty"},
-- undotree
{"mbbill/undotree"},
-- lspconfig and dependencies
{'neovim/nvim-lspconfig'},
{'hrsh7th/cmp-nvim-lsp'},
{'hrsh7th/nvim-cmp'},
{'L3MON4D3/LuaSnip'},
-- lua line {editor status line}
{'nvim-lualine/lualine.nvim',dependencies = { 'nvim-tree/nvim-web-devicons' }},
-- mason
{"williamboman/mason.nvim"},
{"williamboman/mason-lspconfig.nvim"},
-- comment plugin
{'numToStr/Comment.nvim',lazy = false,},
-- DAP client
{'mfussenegger/nvim-dap'},
-- dap ui
{'rcarriga/nvim-dap-ui'},
{'jay-babu/mason-nvim-dap.nvim', event = "VeryLazy",
	opts = { handlers = {},}
},
-- neo tree
{
"nvim-neo-tree/neo-tree.nvim",
branch = "v3.x",
dependencies = {
"nvim-lua/plenary.nvim",
"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
"MunifTanjim/nui.nvim",
-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
}, 
},
--blue moon theme
{"kyazdani42/blue-moon"},
}
local opts = {}

require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
--telescope file finder
vim.keymap.set('n', '<leader>p', builtin.find_files, {})
--telescope live grep
vim.keymap.set('n', '<leader>o', builtin.live_grep, {})
--undo tree
vim.keymap.set('n', '<leader>i', vim.cmd.UndotreeToggle, {})
--neo tree
vim.keymap.set('n', '<leader>e', vim.cmd.Neotree, {})

--undo tree configuration
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.termguicolors = true


require("mason").setup()
require("mason-lspconfig").setup()
--ADD MORE LANGUAGE SERVERS HERE
--https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local lspconfig = require("lspconfig")
local coq = require("coq")
lspconfig.clangd.setup(coq.lsp_ensure_capabilities())
lspconfig.jdtls.setup(coq.lsp_ensure_capabilities()) 

-- comment shortcuts
require("Comment").setup()

--turn on code completion
vim.cmd("COQnow")

--treesitter
local config = require("nvim-treesitter.configs")
config.setup({
	ensure_installed = {"c", "cpp", "lua", "java"},
	sync_install = false,
	highlight = { enable = true },
	indent = { enable = true },
})
--editor bottom line thing
require('lualine').setup()
vim.cmd.colorscheme "blue-moon"


--DEBUGGER STUFF FOR LATER IF U WANNA ADD:
--DAP's CAN BE INSTALLED THROUGH MASON 
--ALL U GOTTA DO IS SET UP THE UI PLUGINS
--https://www.youtube.com/watch?v=oYzZxi3SSnM
local dap = require("dap") 
local dapui = require("dapui")
require("mason-nvim-dap").setup()
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, {})
vim.keymap.set('n', '<leader>n', dap.continue, {})

dapui.setup()
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end
