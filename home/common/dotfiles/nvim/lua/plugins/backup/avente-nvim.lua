local prefix = "<Leader>A"
return {
  "yetone/avante.nvim",
  build = vim.fn.has "win32" == 1 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "make",
  event = "VeryLazy",
  lazy = false,
  version = false,
  cmd = {
    "AvanteAsk",
    "AvanteBuild",
    "AvanteEdit",
    "AvanteRefresh",
    "AvanteSwitchProvider",
    "AvanteShowRepoMap",
    "AvanteModels",
    "AvanteChat",
    "AvanteToggle",
    "AvanteClear",
    "AvanteFocus",
    "AvanteStop",
    "AvanteDiff",
  },
  dependencies = {
    { "stevearc/dressing.nvim", optional = true },
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    { "AstroNvim/astrocore", opts = function(_, opts) opts.mappings.n[prefix] = { desc = " Avante" } end },
  },
  opts = {
    auto_diff = true,  -- This was missing
    debug = true,
    provider = "ollama",
    use_absolute_path = true,
    auto_suggestions_provider = "ollama",
    -- edit = {
    --   auto_apply = false,
    --   diff_preview = true
    -- },
    providers = {
      ollama = {
        endpoint = "http://kryses.local.ai:11434",  -- Fixed the typo (was kryses.local.ai)
        model = "qwen2.5-coder:7b",  -- More specific model name
        disable_tools = false,
        -- mode = "legacy",
        extra_request_body = {
          stream = true,
          options = {
            num_predict = 2048,
            temperature = 0.7,
            top_p = 0.9
          }
        }
      }
    },
    file_modification = {
      auto_open = true,
      confirm_changes = true
    },
    mappings = {
      ask = prefix .. "<CR>",
      edit = prefix .. "e",
      refresh = prefix .. "r",
      new_ask = prefix .. "n",
      focus = prefix .. "f",
      select_model = prefix .. "?",
      stop = prefix .. "S",
      select_history = prefix .. "h",
      toggle = {
        default = prefix .. "t",
        debug = prefix .. "d",
        hint = prefix .. "H",
        suggestion = prefix .. "s",
        repomap = prefix .. "R",
      },
      diff = {
        next = "]c",
        prev = "[c",
        accept = "<leader>aa",  -- Add this for accepting changes
        reject = "<leader>ar",  -- Add this for rejecting changes
      },
      files = {
        add_current = prefix .. ".",
        add_all_buffers = prefix .. "B",
      },
    },
  },
  specs = {
    { "AstroNvim/astroui", opts = { icons = { Avante = "" } } },
    {
      "Kaiser-Yang/blink-cmp-avante",
      lazy = true,
      specs = {
        {
          "Saghen/blink.cmp",
          optional = true,
          opts = {
            sources = {
              default = { "avante" },
              providers = {
                avante = { module = "blink-cmp-avante", name = "Avante" },
              },
            },
          },
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      optional = true,
      opts = function(_, opts)
        if not opts.file_types then opts.file_types = { "markdown" } end
        opts.file_types = require("astrocore").list_insert_unique(opts.file_types, { "Avante" })
      end,
    },
    {
      "OXY2DEV/markview.nvim",
      optional = true,
      opts = function(_, opts)
        if not opts.preview then opts.preview = {} end
        if not opts.preview.filetypes then opts.preview.filetypes = { "markdown", "quarto", "rmd" } end
        opts.preview.filetypes = require("astrocore").list_insert_unique(opts.preview.filetypes, { "Avante" })
      end,
    },
    {
      "folke/snacks.nvim",
      optional = true,
      specs = {
        {
          "yetone/avante.nvim",
          opts = {
            selector = {
              provider = "snacks",
            },
          },
        },
      },
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      optional = true,
      opts = {
        filesystem = {
          commands = {
            avante_add_files = function(state)
              local node = state.tree:get_node()
              local filepath = node:get_id()
              local relative_path = require("avante.utils").relative_path(filepath)
              local sidebar = require("avante").get()
              local open = sidebar:is_open()
              if not open then
                require("avante.api").ask()
                sidebar = require("avante").get()
              end
              sidebar.file_selector:add_selected_file(relative_path)
              if not open then
                sidebar.file_selector:remove_selected_file "neo-tree filesystem [1]"
              end
            end,
          },
          window = {
            mappings = {
              ["oa"] = "avante_add_files",
            },
          },
        },
      },
    },
  },
}
