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

require("lazy").setup("plugins")

vim.cmd.colorscheme "nvimgelion"
