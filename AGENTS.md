# Agent Guide: kickstart.nvim

This repository contains a Neovim configuration based on `kickstart.nvim`. It is designed to be a starting point for a custom Neovim setup, prioritizing readability, documentation, and ease of modification.

## 🛠 Build, Lint, and Test Commands

### Formatting
The project uses **StyLua** for Lua code formatting.
- **Format all files:** `stylua .`
- **Check formatting:** `stylua --check .`
- **Configuration:** See `.stylua.toml`.

### Linting
Linting is primarily handled within Neovim via **LSP (lua_ls)** and **nvim-lint**.
- **Run diagnostics in Neovim:** `:lua vim.diagnostic.setqflist()`
- **Health Check:** `nvim --headless +checkhealth +qa` (Verify that dependencies and configurations are correct)

### Testing
There are currently no automated tests in this repository. Most verification is done manually by running Neovim and checking for errors or using `:checkhealth`.

---

## 🎨 Code Style Guidelines

### General Lua Conventions
- **Indentation:** 2 spaces (no tabs).
- **Line Length:** Preferred maximum of 160 characters (as per `.stylua.toml`).
- **Quotes:** Use single quotes `'` whenever possible, unless the string contains single quotes.
- **Naming:**
    - Variables/Functions: `snake_case`.
    - Constants: `SCREAMING_SNAKE_CASE` (rarely used in this config).
    - Modules: `snake_case`.
- **Comments:** Use double dashes `--` for comments. For documentation, use `---` (LuaDoc).
- **Tables:** Prefer trailing commas in multi-line tables.

### Imports and Dependencies
- Use `require('module')` for local dependencies.
- For optional plugins, use `pcall` to avoid breaking the configuration if a plugin is missing:
  ```lua
  local ok, telescope = pcall(require, 'telescope')
  if not ok then
    return
  end
  ```
- Plugin management is handled by `lazy.nvim`. Plugin specifications should follow the `lazy.nvim` format.
- Avoid global variables. Always use `local` for variables unless they specifically need to be global (which is rare in this config).

### Neovim API Usage
- **Keymaps:** Always use `vim.keymap.set()` instead of the older `vim.api.nvim_set_keymap()`.
- **Options:** Use `vim.o` for global options and `vim.opt` for more complex table-based options.
- **Autocommands:** Always use `vim.api.nvim_create_autocmd()` and group them using `vim.api.nvim_create_augroup()` with `clear = true`.
- **UI:** Use `vim.notify` for user-facing messages instead of `print`.

### Error Handling
- Favor `pcall` or `xpcall` when calling functions that might fail (like loading a plugin or an external tool).
- Check if LSP clients or features are available before use:
  ```lua
  if client and client.supports_method('textDocument/formatting') then
    -- perform action
  end
  ```
- Use `vim.diagnostic` for reporting errors in the editor when appropriate.

---

## 🏗 Project Structure

- `init.lua`: The main entry point. Contains core settings, keymaps, and the plugin manager setup.
- `lua/kickstart/`: Contains "core" kickstart functionality and plugin configurations.
- `lua/kickstart/plugins/`: Individual plugin configuration files that are required by `init.lua`.
- `lua/custom/`: The intended location for user-specific customizations.
- `lua/custom/plugins/`: Add new plugin specifications here.
- `doc/`: Contains project documentation and help files.

### Adding New Features
1. **Plugins:** Add a new file in `lua/custom/plugins/` or add to `init.lua`.
2. **Settings:** Add to `init.lua` under the appropriate section (Options, Keymaps, etc.).
3. **Modularization:** If adding complex logic, create a new module in `lua/custom/` and `require` it in `init.lua`.

---

## 🧩 Plugin Configuration (lazy.nvim)

When adding or modifying plugins, follow these patterns:

```lua
return {
  'author/plugin-name',
  enabled = true,
  dependencies = { 'author/other-plugin' },
  event = 'VimEnter', -- lazy loading
  cmd = { 'PluginCommand' },
  ft = { 'lua', 'python' },
  keys = {
    { '<leader>k', '<cmd>PluginAction<cr>', desc = 'Description for which-key' },
  },
  opts = {
    -- Options passed to require('plugin').setup(opts)
  },
  config = function(_, opts)
    -- Custom configuration logic
    require('plugin').setup(opts)
  end,
}
```

---

## 🤖 Agent Instructions

When modifying this codebase:
1. **Preserve Documentation:** Keep the explanatory comments (marked with `NOTE:`, `TIP:`, etc.) as they are central to the "teaching tool" nature of kickstart.
2. **Follow Modelines:** Respect the modeline at the bottom of files (e.g., `vim: ts=2 sts=2 sw=2 et`).
3. **Lazy Loading:** Prefer lazy-loading plugins where appropriate using `event`, `cmd`, or `ft` keys in the plugin spec.
4. **Keymaps:** Ensure all new keymaps have a `desc` field for integration with `which-key.nvim`.
5. **No Chitchat in Code:** Do not add comments describing your changes; let the code and git commit message speak for themselves.
6. **LSP Config:** When configuring LSPs, use the `servers` table in `init.lua` to ensure they are handled by `mason` and `lspconfig`.

---

## 🔍 Existing Rules
- No existing `.cursorrules` or `.github/copilot-instructions.md` were found. If added, they should be incorporated into this guide.
