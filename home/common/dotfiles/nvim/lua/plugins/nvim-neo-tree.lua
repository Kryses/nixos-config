return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    commands = {
      find_files_in_dir = function(state)
        local node = state.tree:get_node()
        local path = node.type == "file" and node:get_parent_id() or node:get_id()
        require("snacks").picker.files { cwd = path,  hidden = true, ignored = true }
      end,
      find_all_files_in_dir = function(state)
        local node = state.tree:get_node()
        local path = node.type == "file" and node:get_parent_id() or node:get_id()
        require("snacks").picker.files { cwd = path, hidden = true, ignored = true }
      end,
      find_words_in_dir = function(state)
        local node = state.tree:get_node()
        local path = node.type == "file" and node:get_parent_id() or node:get_id()
        require("snacks").picker.grep { cwd = path, hidden = true, ignored = true }
      end,
      find_all_words_in_dir = function(state)
        local node = state.tree:get_node()
        local path = node.type == "file" and node:get_parent_id() or node:get_id()
        require("snacks").picker.grep { cwd = path, hidden = true, ignored = true }
      end,
    },
    check_ignore_in_search = false,
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = true,
        hide_gitignored = false,
      },
    },
  },
}
