return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    indent = {
      enable = true,
      disable = { "yaml" }, -- Disable treesitter indentation for YAML as it breaks indentation
    },
  },
}

