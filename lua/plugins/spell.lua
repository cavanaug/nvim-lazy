-- cspell + Neovim spell integration for prose filetypes (markdown, text, mdx).
-- Project cspell configs stay aligned with VS Code teammates.

local spell_filetypes = { "markdown", "mdx", "markdown.mdx", "text" }

---@param word string
---@param words string[]
---@return boolean
local function word_in_list(word, words)
  for _, existing in ipairs(words) do
    if existing == word then
      return true
    end
  end
  return false
end

--- Common singular/plural variants for English (tech prose).
---@param word string
---@return string[]
local function get_spelling_variants(word)
  if word == "" then
    return {}
  end

  local variants = { word }
  local seen = { [word] = true }

  local function add(candidate)
    if candidate ~= "" and not seen[candidate] then
      seen[candidate] = true
      variants[#variants + 1] = candidate
    end
  end

  -- Plural forms
  if word:match("ss$") then
    add(word .. "es")
  elseif word:match("[xz]$") or word:match("ch$") or word:match("sh$") then
    add(word .. "es")
  elseif word:match("[^aeiouAEIOU]y$") then
    add(word:sub(1, -2) .. "ies")
  elseif not word:match("s$") then
    add(word .. "s")
  end

  -- Singular forms (conservative: avoid stripping "status", "bus", etc.)
  if word:match("[sxz]es$") or word:match("ches$") or word:match("shes$") then
    add(word:sub(1, -3))
  elseif word:match("[^aeiouAEIOU]ies$") and #word > 4 then
    add(word:sub(1, -4) .. "y")
  elseif word:match("[^s]s$") and #word > 4 and not word:match("us$") and not word:match("is$") then
    add(word:sub(1, -2))
  end

  return variants
end

---@return string|nil cspell_word, string|nil vim_spell_word
local function get_misspelled_words()
  local cspell_word = nil
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  for _, d in ipairs(vim.diagnostic.get(0)) do
    if d.source == "cspell" and d.lnum == row and col >= d.col and col < d.end_col then
      local word = d.message:match("%((.-)%)")
      if word and word ~= "" then
        cspell_word = word
        break
      end
    end
  end

  local bad = vim.fn.spellbadword()
  local vim_spell_word = (bad[1] and bad[1] ~= "") and bad[1] or nil
  if not vim_spell_word then
    local word = vim.fn.expand("<cword>")
    if word ~= "" then
      vim_spell_word = word
    end
  end

  return cspell_word, vim_spell_word
end

---@return string
local function find_cspell_config()
  local configs = vim.fs.find(
    { "cspell.config.yaml", "cspell.config.yml", "cspell.json", ".cspell.json" },
    { upward = true, path = vim.fn.expand("%:p:h") }
  )
  if configs[1] then
    return configs[1]
  end
  return vim.fn.stdpath("config") .. "/cspell.json"
end

---@param words string[]
---@param config_path string
---@return boolean updated
local function add_words_to_cspell(words, config_path)
  if #words == 0 then
    return false
  end

  if config_path:match("%.ya?ml$") then
    local lines = vim.fn.readfile(config_path)
    local insert_idx = nil
    for i, line in ipairs(lines) do
      if line:match("^words:") then
        insert_idx = i
      elseif insert_idx and not line:match("^%s+-") then
        break
      elseif insert_idx then
        insert_idx = i
      end
    end
    if not insert_idx then
      vim.notify("No 'words:' section in cspell config: " .. config_path, vim.log.levels.WARN)
      return false
    end

    local existing = {}
    for i = insert_idx + 1, #lines do
      local word = lines[i]:match("^%s+-%s+(.+)$")
      if word then
        existing[word] = true
      elseif not lines[i]:match("^%s+-") then
        break
      end
    end

    local updated = false
    for _, word in ipairs(words) do
      if not existing[word] then
        table.insert(lines, insert_idx + 1, "  - " .. word)
        existing[word] = true
        insert_idx = insert_idx + 1
        updated = true
      end
    end

    if updated then
      vim.fn.writefile(lines, config_path)
    end
    return updated
  end

  if config_path:match("%.json$") then
    local file_lines = vim.fn.readfile(config_path)
    local ok, config = pcall(vim.json.decode, table.concat(file_lines, "\n"))
    if not ok or type(config) ~= "table" then
      vim.notify("Could not parse cspell config: " .. config_path, vim.log.levels.ERROR)
      return false
    end

    config.words = config.words or {}
    local updated = false
    for _, word in ipairs(words) do
      if not word_in_list(word, config.words) then
        config.words[#config.words + 1] = word
        updated = true
      end
    end

    if updated then
      vim.fn.writefile(vim.split(vim.json.encode(config, { indent = "  " }), "\n"), config_path)
    end
    return updated
  end

  return false
end

---@return string[]
local function collect_spelling_variants()
  local cspell_word, vim_spell_word = get_misspelled_words()
  local seeds = {}
  if cspell_word then
    seeds[#seeds + 1] = cspell_word
  end
  if vim_spell_word then
    seeds[#seeds + 1] = vim_spell_word
  end
  if #seeds == 0 then
    return {}
  end

  local variants = {}
  local seen = {}
  for _, seed in ipairs(seeds) do
    for _, word in ipairs(get_spelling_variants(seed)) do
      if not seen[word] then
        seen[word] = true
        variants[#variants + 1] = word
      end
    end
  end
  return variants
end

local function add_word_to_spell_dictionaries()
  local variants = collect_spelling_variants()
  if #variants == 0 then
    return
  end

  if vim.wo.spell then
    for _, word in ipairs(variants) do
      vim.fn.execute("silent! spellgood " .. vim.fn.fnameescape(word))
    end
  end

  if add_words_to_cspell(variants, find_cspell_config()) then
    require("lint").try_lint()
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = spell_filetypes,
  callback = function()
    vim.keymap.set("n", "zg", add_word_to_spell_dictionaries, {
      buffer = true,
      desc = "Add word (+ plurals) to spellfile and cspell",
    })
  end,
})

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      for _, ft in ipairs(spell_filetypes) do
        opts.linters_by_ft[ft] = { "cspell" }
      end
    end,
  },
}
