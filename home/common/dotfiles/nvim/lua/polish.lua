require("codecompanion").setup {
  adapters = {
    ollama = function()
      return require("codecompanion.adapters").extend("ollama", {
        env = {
          url = "http://kryses.local.ai:11434",
        },
        headers = {
          ["Content-Type"] = "application/json",
        },
        parameters = {
          sync = true,
        },
      })
    end,
  },
  strategies = {
    chat = {
      adaptor = "ollama",
    },
    inline = {
      adaptor = {
        name = "ollama",
        model = "qwen2.5-code:7b", -- Changed from qwen2.5-coder:7b
      },
    },
    cmd = {
      adaptor = {
        name = "ollama",
        model = "qwen2.5-code:7b", -- Changed from qwen2.5-coder:7b
      },
    },
  },
}
