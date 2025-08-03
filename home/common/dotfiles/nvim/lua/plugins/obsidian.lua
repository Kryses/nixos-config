return {
  "epwalsh/obsidian.nvim",
  -- the obsidian vault in this default config  ~/obsidian-vault
  -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
  -- event = { "bufreadpre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
  event = { "BufReadPre  */krys-brain/*.md" },
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
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
                  return "<Cmd>ObsidianFollowLink<CR>"
                else
                  return "gf"
                end
              end,
              desc = "Obsidian Follow Link",
            },
          },
          v = {
            ["<leader>i"] = { desc = "  Notes" },
            ["<leader>ie"] = { "<cmd>ObsidianExtractNote<cr>", desc = " Extract Note" },
            ["<leader>il"] = { "<cmd>ObsidianLink<cr>", desc = " Link" },
          },
        },
      },
    },
  },
  opts = {
    dir = vim.env.HOME .. "/krys-brain", -- specify the vault location. no need to call 'vim.fn.expand' here
    use_advanced_uri = true,
    finder = "telescope.nvim",
    new_notes_location = "00_inbox",
    daily_notes = {
      folder = "04_journal/daily",
      date_format = "%Y-%m-%d",
    },
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
    note_frontmatter_func = function(note)
      -- This is equivalent to the default frontmatter function.
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }
      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,
    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
    end,
    disable_frontmatter = true,
    nvim_completiom = {
      nvim_cmp = true,
      min_chars = 2,
    },
    -- Optional, customize how note file names are generated given the ID, target directory, and title.
    ---@param spec { id: string, dir: obsidian.Path, title: string|? }
    ---@return string|obsidian.Path The full path to the new note.
    note_path_func = function(spec)
      -- This is equivalent to the default behavior.
      local path = spec.dir / tostring(spec.id)
      return path:with_suffix ".md"
    end,
    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    follow_url_func = vim.ui.open or function(url) require("astrocore").system_open(url) end,
    ---@param img string
    follow_img_func = function(img)
      -- vim.fn.jobstart { "qlmanage", "-p", img } -- Mac OS quick look preview
      vim.fn.jobstart { "feh", img } -- linux
      -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
    end,
    attachments = {
      img_folder = "98_attachments/images",

      ---@return string
      img_name_func = function()
        -- Prefix image names with timestamp.
        return string.format("%s-", os.time())
      end,
      ---@param client obsidian.Client
      ---@param path obsidian.Path the absolute path to the image file
      ---@return string
      ---
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format("![[%s]]", path)
      end,
    },
  },
}
