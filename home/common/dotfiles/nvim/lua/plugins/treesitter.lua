-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  -- dependencies = {
  --   {"nushell/tree-sitter-nu", build=":TSUpdate nu"}
  -- },
  opts = {
    highlight = {
      enable = true
    },
    ensure_installed = {
      "lua",
      "vim",
      "nu"
      -- add more arguments for adding more treesitter parsers
    },
  },
  build = ":TSUpdate"
}
