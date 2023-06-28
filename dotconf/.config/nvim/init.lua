require('packer').startup(function(use)
  use 'abdalrahman-ali/vim-remembers'
  use 'dense-analysis/ale'
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  }
  use 'nvim-lualine/lualine.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
  }
  use 'mfussenegger/nvim-jdtls'
  use 'tpope/vim-commentary'
  use 'wbthomason/packer.nvim'

  use {
    'neovim/nvim-lspconfig',
    requires = {
      'j-hui/fidget.nvim',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
  }
end)

vim.cmd 'colorscheme solarized'

vim.api.nvim_set_keymap('n', 'tn', ':tabnew<CR>', {})

vim.bo.expandtab = true
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2

vim.api.nvim_command([[
  autocmd FileType go setlocal sw=2 ts=2 noexpandtab
]])

-- Remove default gray color of sign column
vim.api.nvim_command([[
  highlight clear SignColumn
]])

-- Always show sign column
vim.o.signcolumn = "yes"
vim.o.dir = '/tmp'
vim.o.swapfile = true

vim.wo.number = true

vim.g.mapleader = ','
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('v', '<leader>y', '"+y', {noremap=true, silent=true})

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

require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c', 'go', 'haskell', 'lua', 'nix', 'python' },
  highlight = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "vn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = { enable = true },
  textobjects = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  }
}

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

require('mason').setup()

-- Subset of:
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local servers = {
  'bashls',
  'clangd',
  -- 'hls',
  'jdtls',
  'rust_analyzer',
  'pyright',
  'tsserver',
  'lua_ls',
  'gopls',
  -- 'yamlls',
}

require('mason-lspconfig').setup {
  ensure_installed = servers,
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local cmp = require 'cmp'
local luasnip = require 'luasnip'

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

local date = function() return {os.date('%Y-%m-%d')} end

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
  },
})
