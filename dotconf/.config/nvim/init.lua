vim.cmd 'colorscheme solarized'

local buffer_options = vim.bo
local options_global = vim.o
local window_options = vim.wo

buffer_options.expandtab = true
buffer_options.softtabstop = 2
buffer_options.shiftwidth = 2
buffer_options.tabstop = 2

options_global.dir = '/tmp'
options_global.swapfile = true

window_options.number = true

vim.g.mapleader = ','
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- Go to most recent visited line in buffer
vim.api.nvim_create_autocmd(
  "BufReadPost",
  { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
)

return require('packer').startup(function(use)
  use 'abdalrahman-ali/vim-remembers'
  use 'dense-analysis/ale'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'tpope/vim-commentary'
  use 'wbthomason/packer.nvim'
end)
