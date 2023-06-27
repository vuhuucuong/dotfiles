if vim.g.vscode then
  -- VSCode extension
else
  -- default settings
  require("core.options")
  require("core.keymaps").default()

  -- Setup lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
    })
  end
  vim.opt.rtp:prepend(lazypath)

  -- Remap space as leader key
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "
  require("lazy").setup({

    "nvim-lua/plenary.nvim",
    -- List plugins here

    ---------- COLORSCHEME ----------
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      config = function()
        require("core.colorschemes")
      end
    },

    ---------- LSP ----------
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("plugins.nvim-treesitter")
      end
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "folke/neodev.nvim",
        "williamboman/mason-lspconfig.nvim",
        "ray-x/lsp_signature.nvim",
        "folke/trouble.nvim",
        "SmiteshP/nvim-navic",
        "b0o/schemastore.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "RRethy/vim-illuminate",
      },
      config = function()
        require("plugins.nvim-lspconfig")
      end
    },
    {
      "jose-elias-alvarez/null-ls.nvim",
      dependencies = {
        "jose-elias-alvarez/typescript.nvim",
      },
      config = function()
        require("plugins.null-ls")
      end
    },
    { "folke/neodev.nvim",                        opts = {} },
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      opts = {}
    },
    {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      init = function()
        -- lsp gutter icons
        local signs = {
          Error = " ",
          Warn = " ",
          Hint = " ",
          Info = " "
        }

        for type, icon in pairs(signs) do
          local hl = "DiagnosticSign" .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end
      end,
      opts = {},
      keys = require("plugins.keymaps").trouble
    },

    ---------- COMPLETION ----------
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
      },
      config = function()
        require("plugins.nvim-cmp")
      end

    },
    {
      "L3MON4D3/LuaSnip",
      version = "<CurrentMajor>.*",
      build = "make install_jsregexp"
    },
    ---------- KEYMAP UI ----------
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end,
      config = function()
        require("plugins.whichkey")
      end
    },
    ---------- FUZZY FINDER ----------
    {
      "nvim-telescope/telescope.nvim",
      tag          = "0.1.1",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzf-native.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-telescope/telescope-project.nvim"
      },
      keys         = require("plugins.keymaps").telescope
    },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    ---------- EXPLORER ----------
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      init = function()
        -- disable netrw
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
      end,
      config = function()
        require("plugins.nvim-tree")
      end,
    },

    ---------- UI ----------
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" },
      config = function()
        require("plugins.lualine")
      end
    },
    {
      "akinsho/bufferline.nvim",
      version = "*",
      dependencies = "nvim-tree/nvim-web-devicons",
      opts = {
        options = {
          diagnostics = "nvim_lsp",
          ---@diagnostic disable-next-line: unused-local
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local s = " "
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and " "
                  or (e == "warning" and " " or "")
              s = s .. n .. sym
            end
            return s
          end
        }
      }
    },
    {
      "SmiteshP/nvim-navic",
    },
    {
      "utilyre/barbecue.nvim",
      name = "barbecue",
      version = "*",
      dependencies = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons",
      },
      opts = {},
    },
    {
      "folke/noice.nvim",
      dependencies = {
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("plugins.noice")
      end
    },
    "norcalli/nvim-colorizer.lua",
    {
      "lewis6991/gitsigns.nvim",
      opts = {}
    },

    ---------- UTILS ----------
    {
      "windwp/nvim-ts-autotag",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("nvim-treesitter.configs").setup {
          autotag = {
            enable = true,
          }
        }
      end
    },
    {
      "nvim-pack/nvim-spectre",
      dependencies = "nvim-lua/plenary.nvim",
      ---@diagnostic disable-next-line: assign-type-mismatch
      keys = require("plugins.keymaps").nvim_spectre
    },
    {
      "sindrets/diffview.nvim",
      dependencies = "nvim-lua/plenary.nvim",
      config = function()
        require("plugins.diffview")
      end

    },
    {
      "windwp/nvim-autopairs",
      opts = {}
    },
    {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      opts = {}
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      opts = {
        show_current_context = true,
        show_current_context_start = true,
      }
    },
    {
      "numToStr/Comment.nvim",
      dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring"
      },
      opts = {}
    },
    {
      "iamcco/markdown-preview.nvim",
      build = function() vim.fn["mkdp#util#install"]() end,
      init = function()
        -- markdown preview
        vim.g.mkdp_auto_close = 0
      end
    },
    {
      'kevinhwang91/nvim-bqf',
      ft = 'qf',
      opts = {
        preview = { wrap = true }
      }
    }
  })
end
