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
    use { "ms-jpq/coq_nvim", commit = "5eddd31bf8a98d1b893b0101047d0bb31ed20c49", run = "python3 -m coq deps" }
    -- 9000+ Snippets
    use { "ms-jpq/coq.artifacts", branch = "artifacts" }

    -- lsp
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "neovim/nvim-lspconfig"
    use { "RRethy/vim-illuminate",
      config = function()
        vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#585B70", underline = true })
      end
    }
    use "b0o/schemastore.nvim"
    use "jose-elias-alvarez/null-ls.nvim"
    use { "folke/neodev.nvim", config = function()
      require("user.neodev")
    end
    }
    use {
      "folke/which-key.nvim",
      config = function()
        require("user.whichkey")
      end
    }

    -- Debugger
    use { "mfussenegger/nvim-dap", config = function()
      -- require("user.dap")
    end
    }
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" }, config = function()
      require("dapui").setup()
    end
    }
    -- use { "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } }
    -- -- language specific debug adapter
    -- use {
    --   "microsoft/vscode-js-debug",
    --   opt = true,
    --   run = "npm install --legacy-peer-deps && npm run compile"
    -- }

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
        require("user.telescope")
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

    -- auto tag
    use { "windwp/nvim-ts-autotag", requires = { "nvim-treesitter/nvim-treesitter" }, config = function()
      require("nvim-treesitter.configs").setup {
        autotag = {
          enable = true,
        }
      }
    end }

    -- file explorer
    use {
      "nvim-tree/nvim-tree.lua",
      requires = {
        "nvim-tree/nvim-web-devicons", -- optional, for file icons
      },
      config = function()
        require("user.nvim-tree")
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
        require("user.nvim-navic")
      end
    }
    use "norcalli/nvim-colorizer.lua"

    -- git

    use { "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup()
      end
    }

    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

    -- utils
    use({
      "iamcco/markdown-preview.nvim",
      run = function() vim.fn["mkdp#util#install"]() end,
    })


    -- window seperator border
    use {
      "nvim-zh/colorful-winsep.nvim",
      config = function()
        require("colorful-winsep").setup()
      end
    }

    -- quickfix
    use { 'kevinhwang91/nvim-bqf', ft = 'qf', config = function()
      require('bqf').setup({ preview = { wrap = true } })
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
