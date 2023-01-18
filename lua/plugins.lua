local lazy = require ('lazy')

local configs = {
    -- lualine
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 
            'nvim-tree/nvim-web-devicons', 
            opt = true
        },
        config = true
    },

    {
        "loctvl842/monokai-pro.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            require("monokai-pro").setup()
            local colorscheme = "monokai-pro"
            local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
            if not status_ok then
                vim.notify("colorscheme " .. colorscheme .. " 没有找到！")
                return
            end
        end,
    },

    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = "v2.x",
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
            'MunifTanjim/nui.nvim',
        },
        config = function()
            -- Unless you are still migrating, remove the deprecated commands from v1.x
            pcall(vim.cmd, "let g:neo_tree_remove_legacy_commands = 1")

            -- If you want icons for diagnostic errors, you'll need to define them somewhere:
            vim.fn.sign_define("DiagnosticSignError",
                {text = " ", texthl = "DiagnosticSignError"})
            vim.fn.sign_define("DiagnosticSignWarn",
                {text = " ", texthl = "DiagnosticSignWarn"})
            vim.fn.sign_define("DiagnosticSignInfo",
                {text = " ", texthl = "DiagnosticSignInfo"})
            vim.fn.sign_define("DiagnosticSignHint",
                {text = "", texthl = "DiagnosticSignHint"})
            -- NOTE: this is changed from v1.x, which used the old style of highlight groups
            -- in the form "LspDiagnosticsSignWarning"
            local neotree_config = require('plugin.neo-tree')
            require("neo-tree").setup(neotree_config)
        end
    },

    -- impatient
    -- speed up startup time
    {
        'lewis6991/impatient.nvim',
        lazy = false
    },

    -- telescope
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            local present, telescope = pcall(require, "telescope")
            if not present then
                return
            end

            local options = require("plugin.telescope")
            telescope.setup(options)

            -- load extensions
            for _, ext in ipairs(options.extensions_list) do
                telescope.load_extension(ext)
            end
        end
    },

    -- autopairs
    {
        "windwp/nvim-autopairs",
        config = true
    },

    -- Fuzzy finder syntax support
    {
        "nvim-telescope/telescope-fzf-native.nvim" ,
        dependencies = {
            'nvim-telescope/telescope.nvim'
        },
        config = function ()
            require("telescope").load_extension "fzf"
        end,
        build = 'make'
    },

    {
        url = "https://github.com/nvim-telescope/telescope-file-browser.nvim.git",
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim',
        },
        config = function()
            local file_browser_config = {
                file_browser = {
                    theme = "ivy",
                    -- disables netrw and use telescope-file-browser in its place
                    hijack_netrw = true,
                    mappings = {
                        ["i"] = {
                            -- your custom insert mode mappings
                        },
                        ["n"] = {
                            -- your custom normal mode mappings
                        },
                    },
                },
            }

            require("telescope").setup(file_browser_config)
            require("telescope").load_extension("file_browser")
        end
    },

    {
        "nvim-telescope/telescope-project.nvim",
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-telescope/telescope-file-browser.nvim'
        },
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            local present, nvimtree = pcall(require, "nvim-treesitter.configs")
            if not present then
                return
            end
            
            local options = require("plugin.nvim-treesitter")

            local status_ok, _ = pcall(vim.cmd, "TSEnable highlight")
            if not status_ok then
                vim.notify("nvim-treesitter 没有找到！")
                return
            end
            nvimtree.setup(options)
        end
    },

    {
        "mrjones2014/nvim-ts-rainbow",
    }
}

local opts = {}

lazy.setup(configs, opts);
