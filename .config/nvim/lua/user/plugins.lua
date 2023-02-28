-- Automatically install Packer.nvim
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- automatically run :PackerCompile whenever plugins.lua is updated
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require("packer").startup({
  function(use)
    use "wbthomason/packer.nvim"
    use "nvim-lua/plenary.nvim" -- common lua functions used by other plugins
    -- List plugins here
    -- colorscheme
    use { "catppuccin/nvim", as = "catppuccin" }

    -- completion
    use { "ms-jpq/coq_nvim", branch = "coq", run = "python3 -m coq deps" }
    -- 9000+ Snippets
    use { "ms-jpq/coq.artifacts", branch = "artifacts" }

    -- lsp
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "neovim/nvim-lspconfig"
    use { "RRethy/vim-illuminate",
      config = function()
        vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#45475A", underline = true })
      end
    }
    use "b0o/schemastore.nvim"
    use "jose-elias-alvarez/null-ls.nvim"
    use "folke/neodev.nvim"
    use {
      "folke/which-key.nvim",
      config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
        local wk = require("which-key")

        wk.setup {}
        wk.register({
          ["<leader>f"] = { name = "Find" },
          ["<leader>v"] = { name = "Vim" },
          ["<leader>g"] = { name = "Git" },
          ["<leader>l"] = { name = "LSP" },
          ["<leader>e"] = { name = "Explorer" },
        })
      end
    }

    -- finder
    use {
      "nvim-telescope/telescope.nvim", tag = "0.1.1",
      requires = {
        -- telescope plugins
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        }
      },
      config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")
        local actions = require "telescope.actions"

        telescope.setup {
          defaults = {
            layout_strategy = "horizontal",
            layout_config = {
              height = 0.95,
              width = 0.95,
              preview_width = 0.5
            },
            mappings = {
              i = {
                ["<C-n>"] = actions.cycle_history_next,
                ["<C-p>"] = actions.cycle_history_prev,

                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
              }
            }
          },
          pickers = {
          },
          extensions = {
            fzf = {
              fuzzy = true,
              override_generic_sorter = true,
              override_file_sorter = true,
              case_mode = "smart_case",
            }
          }
        }
        telescope.load_extension("fzf")
      end
    }


    -- language parser
    use {
      "nvim-treesitter/nvim-treesitter",
      run = function()
        local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
        ts_update()
      end,
    }

    -- file explorer
    use {
      "nvim-tree/nvim-tree.lua",
      requires = {
        "nvim-tree/nvim-web-devicons", -- optional, for file icons
      },
      config = function()
        local tree = require("nvim-tree")
        local api = require("nvim-tree.api")
        local lib = require("nvim-tree.lib")

        -- Fix tab titles when opening file in new tab
        local swap_then_open_tab = function()
          local node = lib.get_node_at_cursor()
          vim.cmd("wincmd l")
          api.node.open.tab(node)
        end

        tree.setup {
          live_filter = {
            prefix = "[FILTER]: ",
            always_show_folders = false,
          },
          view = {
            mappings = {
              custom_only = false,
              list = {
                { key = "t", action = "swap_then_open_tab", action_cb = swap_then_open_tab },
              }
            },
          },
        }

        api.events.subscribe(api.events.Event.FileCreated, function(file)
          vim.cmd("edit " .. file.fname)
        end)
        -- auto open on start up
        local function open_nvim_tree(data)
          -- buffer is a directory
          local directory = vim.fn.isdirectory(data.file) == 1

          if not directory then
            return
          end

          -- change to the directory
          vim.cmd.cd(data.file)

          -- open the tree
          require("nvim-tree.api").tree.open()
        end

        vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
      end

    }

    -- auto bracket pair
    use {
      "windwp/nvim-autopairs",
      config = function() require("nvim-autopairs").setup({}) end
    }

    -- surround
    use {
      "kylechui/nvim-surround",
      tag = "*",
      config = function()
        require("nvim-surround").setup({
        })
      end
    }

    -- indent
    use {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("indent_blankline").setup {
          show_current_context = true,
          show_current_context_start = true,
        }
      end
    }
    -- comment
    use {
      "numToStr/Comment.nvim",
      requires = {
        "JoosepAlviste/nvim-ts-context-commentstring"
      },
      config = function()
        require("Comment").setup {
          pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        }
      end
    }


    -- UI
    use {
      "nvim-lualine/lualine.nvim",
      requires = { "kyazdani42/nvim-web-devicons", "SmiteshP/nvim-navic" },
      config = function()
        require("user.lualine")
      end
    }
    use { "akinsho/bufferline.nvim", tag = "v3.*", requires = "nvim-tree/nvim-web-devicons",
      config = function()
        require("bufferline").setup {}
      end
    }
    -- Simple winbar/statusline plugin that shows your current code context
    use {
      "SmiteshP/nvim-navic",
      requires = { "neovim/nvim-lspconfig" },
      config = function()
        require("nvim-navic").setup {
          icons = {
            File          = " ",
            Module        = " ",
            Namespace     = " ",
            Package       = " ",
            Class         = " ",
            Method        = " ",
            Property      = " ",
            Field         = " ",
            Constructor   = " ",
            Enum          = "練",
            Interface     = "練",
            Function      = " ",
            Variable      = " ",
            Constant      = " ",
            String        = " ",
            Number        = " ",
            Boolean       = "◩ ",
            Array         = " ",
            Object        = " ",
            Key           = " ",
            Null          = "ﳠ ",
            EnumMember    = " ",
            Struct        = " ",
            Event         = " ",
            Operator      = " ",
            TypeParameter = " ",
          },
          highlight = false,
          separator = " > ",
          depth_limit = 0,
          depth_limit_indicator = "..",
          safe_output = true
        }
        vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
      end
    }
    use "norcalli/nvim-colorizer.lua"

    -- git

    use { "lewis6991/gitsigns.nvim",
      config = function()
        require('gitsigns').setup()
      end
    }
    -- utils
    use({
      "iamcco/markdown-preview.nvim",
      run = function() vim.fn["mkdp#util#install"]() end,
    })

    -- window seperator border
    use {
      "nvim-zh/colorful-winsep.nvim",
      config = function()
        require('colorful-winsep').setup()
      end
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = { snapshot = "latest", snapshot_path = vim.fn.stdpath("config") .. "/packer_snapshot" }
})
