vim.g.mapleader = ','
vim.cmd 'set clipboard=unnamedplus'
vim.cmd 'set cc=80'

vim.api.nvim_set_keymap('n', 'tn', ':tabnew<CR>', {})
vim.keymap.set('x', '<leader>w', ":normal @w<CR>", {})
--
-- Normally I have the following, but the BufReadPost fixes issues
-- with Telescope that won't load buffer settings.
-- vim.bo.expandtab = true
-- vim.bo.softtabstop = 2
-- vim.bo.shiftwidth = 2
-- vim.bo.tabstop = 2
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  end,
})

vim.api.nvim_command([[
  autocmd FileType go setlocal sw=2 ts=2 noexpandtab
  autocmd FileType kotlin setlocal expandtab softtabstop=2 shiftwidth=2
]])

-- Show editable carriage return (^M)
-- Currently not working with telescope
-- vim.schedule(function()
--   vim.cmd('edit ++ff=unix')
-- end)

-- Remove default gray color of sign column
vim.api.nvim_command([[
  highlight clear SignColumn
]])

-- Always show sign column
vim.o.signcolumn = "yes"
vim.o.dir = '/tmp'
vim.o.swapfile = true

vim.wo.number = true

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.git_bcommits, {})
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, silent = true })
-- NERDTree
vim.api.nvim_set_keymap('n', 'ft', ':NERDTree<CR>', {})
vim.api.nvim_set_keymap('n', 'fv', ':NERDTreeFind<CR>', {})

-- Go to most recent visited line in buffer
vim.api.nvim_create_autocmd(
  "BufReadPost",
  { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
)

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'horizon',
    component_separators = '|',
    section_separators = '',
  },
}

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<leader>w', vim.diagnostic.disable, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local luasnip = require("luasnip")
local luasnip_extras = require 'luasnip.extras'
local rep = luasnip_extras.rep
local t = luasnip.text_node
local i = luasnip.insert_node

cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'buffer' },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
  })
})

local date = function() return { os.date('%Y-%m-%d') } end

luasnip.add_snippets(nil, {
  all = {
    luasnip.snippet({
        trig = "date",
        namr = "Date",
        dscr = "Date in the form of YYYY-MM-DD",
      },
      {
        luasnip.function_node(date, {}),
      }),
    luasnip.snippet("html-tag", {
      t("<"),
      i(1),
      t(">"),
      t("</"),
      rep(1),
      t(">"),
    }),
  },
})
