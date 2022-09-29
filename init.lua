-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --
function keymap(mode, lhs, rhs, opts)
  return vim.api.nvim_set_keymap(mode, lhs, rhs, vim.tbl_extend('keep', opts or {}, {
      nowait = true,
      silent = true,
      noremap = true,
    }))
end

vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.signcolumn = 'yes'
vim.api.nvim_command("set noswapfile")

-- Space as leader key
vim.g.mapleader = ' '

-- Shortcuts
vim.keymap.set({'n', 'x', 'o'}, '<leader>h', '^')
vim.keymap.set({'n', 'x', 'o'}, '<leader>l', 'g_')
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')

-- Basic clipboard interaction
vim.keymap.set({'n', 'x'}, 'cp', '"+y')
vim.keymap.set({'n', 'x'}, 'cv', '"+p')

-- Delete text
vim.keymap.set({'n', 'x'}, 'x', '"_x')

-- Commands
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<leader>bq', '<cmd>bdelete<cr>')
vim.keymap.set('n', '<leader>bl', '<cmd>buffer #<cr>')

-- Map save to Ctrl + S
keymap('', '<c-s>', ':w<CR>', { noremap = false })
keymap('i', '<c-s>', '<C-o>:w<CR>', { noremap = false })
keymap('n', '<Leader>s', ':w<CR>')

-- Copy to system clipboard
keymap('v', '<C-c>', '"+y')

-- Paste from system clipboard with Ctrl + v
keymap('i', '<C-v>', '<Esc>"+p')

keymap('n', '<Leader>ab', '<Plug>(AerojumpBolt)')

_G.kris = {}

-- ========================================================================== --
-- ==                               COMMANDS                               == --
-- ========================================================================== --

vim.api.nvim_create_user_command(
  'ReloadConfig',
  'source $MYVIMRC | PackerCompile',
  {}
)

local group = vim.api.nvim_create_augroup('user_cmds', {clear = true})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = group,
  callback = function()
    vim.highlight.on_yank({higroup = 'Visual', timeout = 200})
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'help', 'man'},
  group = group,
  command = 'nnoremap <buffer> q <cmd>quit<cr>'
})


-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --
---
-- Automatically install packer
---
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local install_plugins = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  print('Installing packer...')
  local packer_url = 'https://github.com/wbthomason/packer.nvim'
  vim.fn.system({'git', 'clone', '--depth', '1', packer_url, install_path})
  print('Done.')

  vim.cmd('packadd packer.nvim')
  install_plugins = true
end

require('packer').startup(function(use)
  -- Plugin manager
  use {'wbthomason/packer.nvim'}

  -- Theming
  use {'folke/tokyonight.nvim'}
  use {'joshdick/onedark.vim'}
  use {'tanvirtin/monokai.nvim'}
  use {'lunarvim/darkplus.nvim'}
  use {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require'nvim-web-devicons'.setup({
        default = true
      })
    end
  }
  use {'nvim-lualine/lualine.nvim'}
  use {'akinsho/bufferline.nvim'}
  use {'lukas-reineke/indent-blankline.nvim'}
  use {'catppuccin/nvim', as = 'catppuccin'}
  use {'doums/darcula'}
  use { "briones-gabriel/darcula-solid.nvim", requires = "rktjmp/lush.nvim" }
  use {'sainnhe/everforest'}
  use {'morhetz/gruvbox'}

  -- File explorer
  use {'kyazdani42/nvim-tree.lua'}

  -- Fuzzy finder
  use {'nvim-telescope/telescope.nvim'}
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
  use {'nvim-telescope/telescope-ui-select.nvim'}
  use {'nvim-telescope/telescope-live-grep-args.nvim'}

  -- Git
  use {'lewis6991/gitsigns.nvim'}
  use {'tpope/vim-fugitive'}

  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use {'nvim-treesitter/nvim-treesitter'}
  use {'nvim-treesitter/nvim-treesitter-textobjects'}
  use {'nvim-treesitter/nvim-treesitter-refactor'}

  -- Code manipulation
  use {'numToStr/Comment.nvim'}
  use { -- auto remove spaces
    'lewis6991/spaceless.nvim',
    config = function()
      require'spaceless'.setup()
    end
  }
  use { -- Automagically configures 'tabstop', 'shiftwidth', 'softtabstop' and 'expandtab'
    'zsugabubus/crazy8.nvim'
  }
  use {'p00f/nvim-ts-rainbow'}

  -- Utilities
  use {'nvim-lua/plenary.nvim'}
  use {'akinsho/toggleterm.nvim'}
  use {'antoinemadec/FixCursorHold.nvim'} -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
  use {'ripxorip/aerojump.nvim', run = ':UpdateRemotePlugins'}


  -- LSP support
  use {'neovim/nvim-lspconfig'}
  use {'onsails/lspkind-nvim'}
  use {'jose-elias-alvarez/null-ls.nvim'} -- for formatters and linters
  use {'lvimuser/lsp-inlayhints.nvim'}

  -- Autocomplete
  use {'hrsh7th/nvim-cmp'}
  use {'hrsh7th/cmp-nvim-lsp'}
  use {'hrsh7th/cmp-nvim-lsp-signature-help'}
  use {'saadparwaiz1/cmp_luasnip'}

  -- Snippets
  use {'L3MON4D3/LuaSnip'}
  use {'rafamadriz/friendly-snippets'}

  -- CMake LSP support
  use {'Shatur/neovim-cmake'}
  use {'mfussenegger/nvim-dap'}

  if install_plugins then
    require('packer').sync()
  end
end)

if install_plugins then
  print '=================================='
  print '    Plugins will be installed.'
  print '    After you press Enter'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

---
-- Colorscheme
---
vim.opt.termguicolors = true
-- vim.cmd('colorscheme onedark')
vim.o.background = "dark" -- or "light" for light mode
vim.cmd('colorscheme gruvbox')
vim.g.catppuccin_flavour = "macchiato"
vim.cmd('colorscheme everforest')
require'nvim-web-devicons'.get_icons()

---
-- lualine.nvim (statusline)
---
vim.opt.showmode = false

-- See :help lualine.txt
require('lualine').setup({
  options = {
    theme = 'onedark',
    icons_enabled = true,
    component_separators = '|',
    section_separators = '',
  },
})


---
-- bufferline
---
-- See :help bufferline-settings
require('bufferline').setup({
  options = {
    mode = 'buffers',
    offsets = {
      {filetype = 'NvimTree'}
    },
  },
  -- :help bufferline-highlights
  highlights = {
    buffer_selected = {
      italic = false
    },
    indicator_selected = {
      fg = {attribute = 'fg', highlight = 'Function'},
      italic = false
    }
  }
})


---
-- Treesitter
---
-- See :help nvim-treesitter-modules
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  },
  -- :help nvim-treesitter-textobjects-modules
  textobjects = {
    enable = true,
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aC"] = "@class.outer",
        ["iC"] = "@class.inner",
        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",
        ["ae"] = "@block.outer",
        ["ie"] = "@block.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["is"] = "@statement.inner",
        ["as"] = "@statement.outer",
        ["ad"] = "@comment.outer",
        ["am"] = "@call.outer",
        ["im"] = "@call.inner"
      }
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
  refactor = {
    navigation = {
      enable = true,
      keymaps = {
        goto_definition_lsp_fallback = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>",
      },
    },
  },
  rainbow = {
    enable = true,
    extended_mode = false,
    max_file_lines = nil,
  },
  ensure_installed = {
    'c',
    'cpp'
  },
})


---
-- Comment.nvim
---
require('Comment').setup({})


---
-- Indent-blankline
---
-- See :help indent-blankline-setup
require('indent_blankline').setup({
  char = '▏',
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  use_treesitter = true,
  show_current_context = false
})


---
-- Gitsigns
---
-- See :help gitsigns-usage
require('gitsigns').setup({
  signs = {
    add = {text = '▎'},
    change = {text = '▎'},
    delete = {text = '➤'},
    topdelete = {text = '➤'},
    changedelete = {text = '▎'},
  }
})


---
-- Telescope
---
require('telescope').setup{
  defaults = {
    prompt_prefix = '🔍 ',
    sorting_strategy = "ascending",
    selection_strategy  = "reset",
    layout_strategy = 'current_buffer', --'flex/bottom_pane',
  },
  extensions = {
    fzf = {
      fuzzy                     = true,     -- false will only do exact matching
      override_generic_sorter   = false,    -- override the generic sorter
      override_file_sorter      = true,     -- override the file sorter
      case_mode                 = "smart_case", -- or "ignore_case" or "respect_case". the default case_mode is "smart_case"
    },
    ['ui-select'] = {
    },
    windows = {
    },
  },
}

-- See :help telescope.builtin
vim.keymap.set('n', '<leader>?', '<cmd>Telescope oldfiles<cr>')
vim.keymap.set('n', '<leader><space>', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]])
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>')
vim.keymap.set('n', '<leader>ss', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>sw', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]])

require('telescope').load_extension('fzf')
require("telescope").load_extension("live_grep_args")
require('telescope').load_extension('ui-select')

---
-- nvim-tree (File explorer)
---
-- See :help nvim-tree-setup
require('nvim-tree').setup({
  hijack_cursor = false,
  on_attach = function(bufnr)
    local bufmap = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, {buffer = bufnr, desc = desc})
    end

    -- :help nvim-tree.api
    local api = require('nvim-tree.api')

    bufmap('L', api.node.open.edit, 'Expand folder or go to file')
    bufmap('H', api.node.navigate.parent_close, 'Close parent folder')
    bufmap('gh', api.tree.toggle_hidden_filter, 'Toggle hidden files')
  end
})

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')


---
-- toggleterm
---
-- See :help toggleterm-roadmap
require('toggleterm').setup({
  open_mapping = '<C-g>',
  direction = 'horizontal',
  shade_terminals = true
})


---
-- Luasnip (snippet engine)
---
-- See :help luasnip-loaders
require('luasnip.loaders.from_vscode').lazy_load()


---
-- nvim-cmp (autocomplete)
---
local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = {behavior = cmp.SelectBehavior.Select}

-- See :help cmp-config
cmp.setup({
  completion = {
    completeopt = 'menu,noinsert',
    autocomplete = false,
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = {
    {name = 'nvim_lsp', keyword_length = 3},
    {name = 'luasnip', keyword_length = 2},
    { name = 'nvim_lsp_signature_help' }
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  formatting = {
    format = require('lspkind').cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 80, -- prevent the popup from showing more than provided characters
      before = function (entry, vim_item)
        -- set a name for each source
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[LuaSnip]",
          nvim_lua = "[Lua]",
          latex_symbols = "[Latex]",
        })[entry.source.name]
        return vim_item
      end
    })
  },
  -- See :help cmp-mapping
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    ['<C-d>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, {'i', 's'}),
  },
})


---
-- null_ls config
---
require('null-ls').setup({
  debug = true,
  sources = {
    require('null-ls').builtins.formatting.clang_format
  },
})

---
-- LSP config
---
-- See :help lspconfig-global-defaults
local lsp_defaults = {
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  on_attach = function(client, bufnr)
    vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
  end
}

local lspconfig = require('lspconfig')

lspconfig.util.default_config = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config,
  lsp_defaults
)

---
-- Diagnostic customization
---
local sign = function(opts)
  -- See :help sign_define()
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = '✘'})
sign({name = 'DiagnosticSignWarn', text = '▲'})
sign({name = 'DiagnosticSignHint', text = '⚑'})
sign({name = 'DiagnosticSignInfo', text = ''})

-- See :help vim.diagnostic.config()
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {border = 'rounded'}
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {border = 'rounded'}
)


---
-- LSP servers
---

-- Prevent multiple instance of lsp servers
-- if file is sourced again
if vim.g.lsp_setup_ready == nil then
  vim.g.lsp_setup_ready = true

  -- See :help lspconfig-setup
  lspconfig.clangd.setup({
    cmd = {
      "/home/phuongnguyen/.local/clangd_15.0.0/bin/clangd",
      "--background-index",
      "--header-insertion=never",
      "--cross-file-rename",
      "--clang-tidy",
      "--clang-tidy-checks=*",
      "--all-scopes-completion=true",
      "--enable-config",
      "--completion-style=bundled",
      "-j=2",
      "--malloc-trim",
      "--pch-storage=memory",
      "--log=error",
      "--query-driver=/**/*"
    },
    sdettings = {clangd = {fallbackFlags = {"-std=c++17"}}}
  })
end

---
-- LSP Keybindings
---
local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  })
end
vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- inlayhints
    require("lsp-inlayhints").on_attach(client, bufnr)

    -- You can search each function in the help page.
    -- For example :help vim.lsp.buf.hover()
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')

    -- Invole null-ls
    if client.supports_method("textDocument/formatting") then
      -- vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          lsp_formatting(bufnr)
        end,
      })
    end
  end,
})

---
-- DAP
---
local dap = require('dap')
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = '/home/phuongnguyen/.local/cpptools-linux/extension/debugAdapters/bin/OpenDebugAD7',
}
local dap = require('dap')
dap.configurations.cpp = {
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',
    miDebuggerPath = 'arm-poky-linux-gnueabi-gdb',
    cwd = '${workspaceFolder}',
    "setupCommands": [
      { "text": "-file-exec-and-symbols ${workspaceFolder}/blinky/build/zephyr/zephyr.elf", "description": "load file", "ignoreFailures": false},
    ],
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
}
dap.configurations.c = dap.configurations.cpp
---
-- CMAKE
---
local Path = require('plenary.path')
require('cmake').setup({
  cmake_executable = 'cmake',
  save_before_build = true,
  parameters_file = 'neovim.json',
  build_dir = tostring(Path:new('{cwd}', 'build', '{os}-{build_type}')),
  configure_args = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1', '-D', 'EnableStripBinary=ON' },
  build_args = {},
  on_build_output = nil,
  quickfix = {
    pos = 'botright', -- Where to open quickfix
    height = 10, -- Height of the opened quickfix.
    only_on_error = true, -- Open quickfix window only if target build failed.
  },
  copy_compile_commands = true,
  dap_open_command = false
})

-- ========================================================================== --
-- ==                               MAPPINGS                               == --
-- ========================================================================== --

-- Copy to system clipboard
vim.api.nvim_set_keymap('i', '<C-c>', '"+y', { noremap = true, nowait = false, silent = true, expr = true })

-- Paste from system clipboard with Ctrl + v
vim.api.nvim_set_keymap('i', 'C-v', '<Esc>"+p', {})
vim.api.nvim_set_keymap('n', 'C-v', '"0p', {})