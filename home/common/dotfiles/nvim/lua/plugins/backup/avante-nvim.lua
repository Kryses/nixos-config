return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    provider = "ollama",
    use_absolute_path = true,
    auto_suggestions_provider = "ollama",
    disable_tools = false,
    providers = {
      ollama = {
        endpoint = "http://localhost:11434",
        model = "deepseek-coder:6.7b",
      }
    },
    mappings = {
        diff = {
          ours = "co",          -- Use our changes
          theirs = "ct",        -- Use their changes
          all_theirs = "ca",    -- Use all their changes
          both = "cab",         -- Use both changes
          cursor = "cc",        -- Use changes at cursor
          next = "]x",          -- Go to next change
          prev = "[x",          -- Go to previous change
        },
      },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "folke/snacks.nvim",
    "stevearc/dressing.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
