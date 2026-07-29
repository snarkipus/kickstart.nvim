# Agent Guide: Neovim Configuration

This repository is a personal Neovim 0.12 configuration derived from
`kickstart.nvim`. Active configuration belongs under `lua/custom/` and plugin
specs are grouped by subsystem.

## Validation

- Format: `stylua .`
- Formatting check: `stylua --check .`
- Lua syntax: `git ls-files -z '*.lua' | xargs -0 -n1 luac -p`
- Startup: `nvim --headless -u ./init.lua '+qa'`
- Health: `nvim --headless -u ./init.lua '+checkhealth custom' '+qa'`

There are no automated tests. Validate deferred plugin loading, mappings, LSP
attachment, formatting, and Tree-sitter behavior interactively when relevant.

## Style

- Use two spaces and prefer single quotes.
- Keep lines within the 160-column StyLua limit.
- Use `snake_case` for variables and functions.
- Use `local` unless a Neovim global is explicitly required.
- Use `vim.keymap.set()` and include a `desc` for every mapping.
- Group autocommands with `vim.api.nvim_create_augroup()`.
- Use `vim.notify` for user-facing messages.
- Preserve modelines and useful explanatory comments.
- Prefer lazy loading through `event`, `cmd`, `ft`, or `keys`.

## Layout

- `init.lua`: startup sequencing only
- `lua/custom/core.lua`: editor policy, global mappings, and core autocommands
- `lua/custom/lazy.lua`: lazy.nvim bootstrap and imports
- `lua/custom/mojo.lua`: Mojo root and executable resolution
- `lua/custom/plugins/completion.lua`: completion and Copilot
- `lua/custom/plugins/editor.lua`: editing, formatting, and linting
- `lua/custom/plugins/lsp.lua`: diagnostics, LSP lifecycle, servers, and Mason
- `lua/custom/plugins/navigation.lua`: Telescope, Neo-tree, Harpoon, and Flash
- `lua/custom/plugins/treesitter.lua`: parsers, queries, and textobjects
- `lua/custom/plugins/ui.lua`: colorscheme and interface helpers
- `lua/custom/plugins/workflow.lua`: Git, diagnostics workflow, and sessions
- `lua/custom/health.lua`: configuration-specific health policy
- `lua/kickstart/plugins/debug.lua`: inactive DAP reference

## Extension Points

- Add or change editor policy in `lua/custom/core.lua`.
- Add plugins to the matching subsystem module; every imported plugin module
  returns a list of specs.
- Add LSP servers to the `servers` table in `lua/custom/plugins/lsp.lua`.
- Add Mason-only tools to `ensure_installed` in that same module.
- Keep project-local Mojo tools out of Mason.
- Add Tree-sitter parsers and query-aware mappings in
  `lua/custom/plugins/treesitter.lua`.

Do not add wrappers or a custom DSL for mappings, options, autocommands, or
plugin specs. Keep changes direct and readable.
