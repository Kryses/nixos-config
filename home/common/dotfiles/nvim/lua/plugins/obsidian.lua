return {
  "obsidian-nvim/obsidian.nvim",
  -- the obsidian vault in this default config  ~/obsidian-vault
  -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
  -- event = { "bufreadpre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
  event = { "BufReadPre  */krys-brain/*.md" },

  dependencies = {
    "nvim-lua/plenary.nvim",
    { "hrsh7th/nvim-cmp", optional = true },
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<leader>i"] = { desc = "  Notes" },
            ["<leader>in"] = { "<cmd>ObsidianNew<cr>", desc = "󰎚 New Note" },
            ["<leader>iC"] = { "<cmd>ObsidianTOC<cr>", desc = "󰠶 Table of Contents" },
            ["<leader>ic"] = { "<cmd>ObsidianToggleCheckbox<cr>", desc = " Toggle Check" },
            ["<leader>io"] = { "<cmd>ObsidianOpen<cr>", desc = "󰏕 Open in Obsidian" },
            ["<leader>iS"] = { "<cmd>ObsidianSearch<cr>", desc = "󰍉 Search" },
            ["<leader>is"] = { "<cmd>ObsidianQuickSwitch<cr>", desc = " Switch" },
            ["<leader>it"] = { "<cmd>ObsidianTemplate<cr>", desc = " Template" },
            ["<leader>ia"] = { "<cmd>ObsidianToday<cr>", desc = "󰃶 Today" },
            ["<leader>iT"] = { "<cmd>ObsidianTags<cr>", desc = " Tags" },
            ["<leader>id"] = { "<cmd>ObsidianDailies<cr>", desc = " Dailies" },
            ["<leader>ib"] = { "<cmd>ObsidianBacklinks<cr>", desc = "󰌍 Back Links" },
            ["<leader>iL"] = { "<cmd>ObsidianLinks<cr>", desc = " Links" },
            ["<leader>ir"] = { "<cmd>ObsidianRename<cr>", desc = "󰑕 Rename" },
            ["<leader>ip"] = { "<cmd>ObsidianPasteImg<cr>", desc = " Paste Image" },
            ["<leader>iN"] = { desc = " New..." },
            ["<leader>iNl"] = { "<cmd>ObsidianLinkNew<cr>", desc = "󱄀 New Link" },
            ["<leader>iNe"] = { "<cmd>ObsidianExtractNote<cr>", desc = " Extract Note" },
            ["<leader>iNN"] = { "<cmd>ObsidianNewFromTemplate<cr>", desc = "  New From Template" },
            ["gf"] = {
              function()
                if require("obsidian").util.cursor_on_markdown_link() then
                  return "<Cmd>Obsidian follow_link<CR>"
                else
                  return "gf"
                end
              end,
              desc = "Obsidian Follow Link",
            },
          },
        },
      },
    },
  },
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      workspaces = {
        {
          path = vim.env.HOME .. "/krys-brain", -- specify the vault location. no need to call 'vim.fn.expand' here
        },
      },
      open = {
        use_advanced_uri = true,
      },
      finder = (astrocore.is_available "snacks.pick" and "snacks.pick")
        or (astrocore.is_available "telescope.nvim" and "telescope.nvim")
        or (astrocore.is_available "fzf-lua" and "fzf-lua")
        or (astrocore.is_available "mini.pick" and "mini.pick"),

      templates = {
        subdir = "99_templates/nvim",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
        substitutions = {
          yesterday = function() return os.date("%Y-%m-%d", os.time() - 86400) end,
          today = function() return os.date("%Y-%m-%d", os.time()) end,
          tomorrow = function() return os.date("%Y-%m-%d", os.time() + 86400) end,
          current_day = function() return os.date("%A", os.time()) end,
          note_id = function() return os.date("%Y-%m-%d-%H-%M-%S", os.time()) end,
        },
      },
      daily_notes = {
        folder = "04_journal/daily",
        date_format = "%Y-%m-%d",
      },
      completion = {
        nvim_cmp = astrocore.is_available "nvim-cmp",
        blink = astrocore.is_available "blink",
      },
      note_frontmatter_func = function(note)
        -- This is equivalent to the default frontmatter function.
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      follow_url_func = vim.ui.open,
    })
  end,
}
