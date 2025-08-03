-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        colorcolumn = "79"
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      v = {
        ["J"] = { ":m '>+1<CR>gv=gv" },
        ["K"] = { ":m '<-2<CR>gv=gv" },
        ["<leader>d"] = { '"_d', desc = "Clear clipboard" },
        ["<leader>y"] = { '"+y', desc = "Copy to clipboard" },
        ["<leader>Y"] = { '"+Y', desc = "Copy to clipboard" },
      },
      i = {
        ["<C-c>"] = { "<Esc>" },
        ["<C-y>"] = { 'copilot#Accept("<CR>")', expr = true, replace_keycodes = false },
      },
      n = {
        -- second key is the lefthand side of the map

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
        ["<A-J>"] = { "i<CR><Esc>" },
        ["J"] = { "mzJ`z" },
        ["<C-d>"] = { "<C-d>zz" },
        ["<C-u>"] = { "<C-u>zz" },
        ["<leader>p"] = { '"_dP', desc = "Paste from clipboard" },
        ["<leader>y"] = { '"+y', desc = "Copy to clipboard" },
        ["<leader>Y"] = { '"+Y', desc = "Copy to clipboard" },
        ["Q"] = { "<nop>" },
        -- ['<C-k>'] = {'<cmd>cnext<cr>zz'},
        -- ['<C-j>'] = {'<cmd>cprev<cr>zz'},
        ["<leader>k"] = { "<cmd>lnext<cr>zz", desc = "Next Location List" },
        ["<leader>j"] = { "<cmd>lprev<cr>zz", desc = "Previous Location List" },
        ["<leader>lp"] = {
          "<cmd> lua require('nvim-dap-projects').search_project_config() <cr>",
          desc = "Load Project",
        },
        ["<C-h>"] = { "<cmd>TmuxNavigateLeft<cr>" },
        ["<C-j>"] = { "<cmd>TmuxNavigateDown<cr>" },
        ["<C-k>"] = { "<cmd>TmuxNavigateUp<cr>" },
        ["<C-l>"] = { "<cmd>TmuxNavigateRight<cr>" },
        ["<C-\\>"] = { "<cmd>TmuxNavigatePrevious<cr>" },

        ["<Leader>ff"] = {
            function()
              require("snacks").picker.files {
                hidden = false,
                ignored = true,
              }
            end,
          desc = "Find files"},
        ["<Leader>fw"] = {
            function()
              require("snacks").picker.grep {
                hidden = false,
                ignored = true,
              }
            end,
          desc = "Find words (kryses)"},
        -- mappings seen under group name "Buffer"
        ["<leader>bD"] = {
          function()
            require("astronvim.utils.status").heirline.buffer_picker(
              function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        -- tables with the `name` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<leader>b"] = { name = "Buffers" },
        -- quick save
        ["<C-s>"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
    },
  },
}
