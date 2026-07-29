# Neovim Configuration Refactor Plan

## Baseline

The refactor starts from commit `fa6bc95`, which establishes the Neovim 0.12,
Mojo, and Tree-sitter migration as the initial working baseline. Phase 0
refreshes dependencies through Lazy and commits the resulting lockfile as the
execution baseline for the structural phases.

The current configuration starts successfully on Neovim 0.12.4. Mojo LSP and
formatting resolve project-local tools, the custom Mojo parser is pinned, and
the Tree-sitter plugins use their current APIs.

## Goals

- Make `init.lua` a small, obvious entry point.
- Give active personal configuration a single owner under `lua/custom/`.
- Group plugins by subsystem rather than creating one file per plugin.
- Resolve known keymap and lifecycle conflicts.
- Preserve current behavior unless this plan explicitly changes it.
- Keep the configuration understandable without introducing a framework or
  custom DSL.
- Bring the README, `AGENTS.md`, health checks, and cheatsheet in line with the
  runtime.

## Non-Goals

- Replacing `lazy.nvim` or adopting a Neovim distribution.
- Creating a file for every plugin or LSP server.
- Adding generic wrappers for options, mappings, autocmds, or plugin specs.
- Broadly replacing working plugins during the structural refactor.
- Enabling the existing DAP example as part of this work.

## Current Issues

### Structure

- `init.lua` owns startup globals, editor policy, plugin-manager bootstrap,
  plugin specs, diagnostics, LSP lifecycle, language servers, formatting, and
  completion.
- Active configuration is split between inline specs, `lua/kickstart/plugins/`,
  and `lua/custom/plugins/`.
- Files under `lua/kickstart/plugins/` now contain personal policy despite being
  presented as optional upstream examples.
- Plugin modules return inconsistent shapes because some are directly required
  while others are imported by Lazy.
- The original Kickstart single-file documentation no longer describes the
  repository accurately.

### Definite Conflicts And Bugs

- Harpoon replaces split navigation on `<C-h>`, `<C-j>`, `<C-k>`, and `<C-l>`.
- Copilot replaces Blink completion navigation on `<C-n>` and `<C-p>`.
- Gitsigns maps `<leader>hu` to `stage_hunk` instead of `undo_stage_hunk`.
- The diagnostic location-list mapping is described as a quickfix-list mapping.
- Lua LS is configured and enabled twice.
- Document-highlight autocmds can be duplicated when multiple LSP clients
  attach and can be removed while another capable client remains attached.
- Telescope's separate `LspAttach` handler can miss an attachment that occurs
  before Telescope loads.
- Tree-sitter textobject mappings are global even when the current language has
  no parser or `textobjects` query.

### Intentional Overrides To Preserve

- Flash owns `s` and `S` for navigation.
- Telescope-backed LSP mappings replace selected Neovim defaults.
- Tree-sitter textobjects replace native textobjects only in buffers where the
  required queries are available after this refactor.
- Multiple dependency declarations for Blink, LazyDev, Plenary, and devicons
  remain valid because Lazy deduplicates plugins by identity.

## Decisions

### Module Scope

Use subsystem modules. Do not use one file per plugin.

### Window And Harpoon Navigation

- Preserve `<C-h>`, `<C-j>`, `<C-k>`, and `<C-l>` for window navigation.
- Keep `<leader>a` for adding the current file to Harpoon.
- Move the Harpoon menu from `<C-e>` to `<leader>e`.
- Map Harpoon entries one through four to `<leader>1` through `<leader>4`.

This also restores native normal-mode `<C-e>` scrolling.

### Completion And Copilot

- Blink owns the standard insert-mode completion keys, including `<C-y>`,
  `<C-n>`, `<C-p>`, and `<C-e>`.
- Copilot uses explicit Alt-based mappings as a complete, visible key policy:
  - `<M-l>` accepts the suggestion.
  - `<M-]>` and `<M-[>` select the next and previous suggestions.
  - `<M-w>` and `<M-j>` accept the next word and line.
  - `<M-e>` dismisses the suggestion.
- Copilot and Blink live in the same module so their key policy remains visible.

### Ownership

- `lua/custom/` owns all active configuration.
- `lua/kickstart/health.lua` remains as retained Kickstart infrastructure.
- `lua/kickstart/plugins/debug.lua` remains as an inactive reference example.
- Other enabled Kickstart plugin modules move into `lua/custom/plugins/`.

### Tree-Sitter

- Keep parser installation, custom Mojo registration, highlighting,
  indentation, textobjects, and textobject mappings in one module.
- Keep the Mojo grammar revision pinned and update it deliberately.
- Install each textobject mapping buffer-locally only when the language has a
  usable parser and the `textobjects` query defines that mapping's capture.
  The presence of a `textobjects.scm` file alone is insufficient because
  languages expose different capture subsets.
- Preserve native mappings in unsupported and parserless buffers.

### LSP

- Keep Lua, Rust, and Mojo server declarations in one `servers` table.
- Do not create one file per server.
- Configure and enable every server exactly once.
- Keep Mojo excluded from Mason because its tools are project-local.
- Register mappings and attachment behavior from one `LspAttach` handler, with
  one global `LspDetach` handler for cleanup.

## Target Layout

```text
.
|-- init.lua
|-- README.md
|-- CHEATSHEET.md
|-- lazy-lock.json
|-- docs/
|   `-- refactor-plan.md
|-- lua/
|   |-- custom/
|   |   |-- core.lua
|   |   |-- health.lua
|   |   |-- lazy.lua
|   |   |-- mojo.lua
|   |   `-- plugins/
|   |       |-- completion.lua
|   |       |-- editor.lua
|   |       |-- lsp.lua
|   |       |-- navigation.lua
|   |       |-- treesitter.lua
|   |       |-- ui.lua
|   |       `-- workflow.lua
|   `-- kickstart/
|       |-- health.lua
|       `-- plugins/
|           `-- debug.lua
`-- doc/
    |-- kickstart.txt
    `-- tags
```

The existing `doc/` directory remains Neovim help documentation. The `docs/`
directory contains repository-level design and maintenance documents.

## Module Responsibilities

### `init.lua`

Load core settings, then bootstrap and configure Lazy:

```lua
require 'custom.core'
require 'custom.lazy'
```

### `lua/custom/core.lua`

- Leader keys and startup globals
- Provider policy
- Nerd Font capability
- Editor options
- Non-plugin global mappings
- Yank highlighting and other core autocmds

Keep these concerns in one file. Separate `options.lua`, `keymaps.lua`, and
`autocmds.lua` files are not justified at the current scale.

### `lua/custom/lazy.lua`

- Lazy bootstrap
- Runtime-path setup
- `{ import = 'custom.plugins' }`
- Lazy UI and rocks configuration

Disable Lazy's rocks integration because no configured plugin requires it.

### `lua/custom/mojo.lua`

Retain the existing focused helper for Mojo project roots and executable
resolution. LSP, Conform, and Tree-sitter modules consume it without adding
plugin-manager knowledge to the helper.

### `lua/custom/plugins/completion.lua`

- `blink.cmp`
- LuaSnip
- Copilot
- Completion and AI key policy

### `lua/custom/plugins/editor.lua`

- guess-indent
- Conform
- nvim-lint
- autopairs
- indent-blankline
- mini.nvim editing modules and statusline

### `lua/custom/plugins/lsp.lua`

- LazyDev
- nvim-lspconfig
- Mason and mason-tool-installer
- Fidget
- Diagnostic presentation
- LSP mappings and attachment lifecycle
- Lua, Rust, and Mojo server declarations
- Tool installation policy

### `lua/custom/plugins/navigation.lua`

- Telescope and extensions
- Neo-tree
- Harpoon
- Flash
- Navigation key policy

### `lua/custom/plugins/treesitter.lua`

- nvim-treesitter
- nvim-treesitter-textobjects
- nvim-treesitter-context
- Parser installation
- Pinned Mojo parser registration
- Highlighting and indentation activation
- Buffer-local textobjects and movements

### `lua/custom/plugins/ui.lua`

- TokyoNight
- which-key
- todo-comments

### `lua/custom/plugins/workflow.lua`

- Gitsigns
- Trouble
- Persistence

Combine the current Gitsigns sign and mapping specs here so its complete
behavior is discoverable in one place.

## Implementation Phases

### Phase 0: Refresh The Dependency Baseline

1. Run `:Lazy check`, then update plugins through Lazy rather than editing
   `lazy-lock.json` by hand.
2. Review release notes for every major-version change before accepting it.
3. Prefer current stable release tags where a plugin publishes maintained
   releases. Keep existing branch tracking where tags are absent or stale.
4. At minimum, refresh the Neovim 0.12-sensitive stack: LuaSnip, Blink,
   Copilot, Mason, nvim-lspconfig, Neo-tree, Mini, Fidget, and Gitsigns.
5. Verify startup, Copilot authentication and suggestions, completion, LSP
   attachment, formatting, Mason tools, and the affected plugin surfaces.
6. Commit the dependency and lockfile refresh separately from structural moves.

Use Lazy's committed lockfile as the rollback boundary. Do not combine this
dependency refresh with module extraction.

### Phase 1: Extract Core And Lazy

1. Move startup globals, options, global mappings, and the yank autocmd into
   `custom/core.lua` without changing behavior.
2. Move Lazy bootstrap and setup into `custom/lazy.lua`.
3. Initially preserve the existing plugin list while moving it, so entry-point
   extraction is tested independently from plugin reorganization.
4. Reduce `init.lua` to the two module loads.
5. Verify startup and formatting.

### Phase 2: Establish Plugin Ownership

1. Create the seven subsystem plugin modules.
2. Move existing custom specs into completion, navigation, and workflow.
3. Move enabled Kickstart specs into the appropriate custom modules.
4. Leave only health and the disabled debug example under `kickstart`.
5. Normalize every imported plugin module to return a list of specs.
6. Remove direct `require 'kickstart.plugins.*'` entries from Lazy setup.

Move one subsystem at a time and verify startup after each move.

### Phase 3: Move Inline Plugin Specs

1. Move Telescope into navigation.
2. Move LSP, LazyDev, Mason, and Fidget into LSP.
3. Move Blink and LuaSnip into completion.
4. Move Conform, Mini, and Guess Indent into editor.
5. Move Which-key, TokyoNight, and Todo Comments into UI.
6. Combine Gitsigns configuration in workflow.

This phase should move code without redesigning it beyond resolving module
dependencies.

### Phase 4: Resolve Behavior And Lifecycle Problems

1. Restore window navigation and remap Harpoon according to the decisions
   above.
2. Restore Blink ownership of completion keys and use Copilot's Alt mappings.
3. Correct `<leader>hu` to `gitsigns.undo_stage_hunk`.
4. Correct the diagnostic location-list description.
5. Merge Lua LS settings and `on_init` into its server entry.
6. Configure and enable Lua LS only through the common server loop.
7. Merge Telescope-backed mappings into the primary LSP attachment handler.
8. Deduplicate document-highlight autocmds per buffer.
9. On detach, remove document-highlight autocmds only when no remaining client
   supports document highlighting for that buffer.
10. Make each Tree-sitter textobject, motion, and swap mapping buffer-local
    after confirming its specific capture exists in the active language's
    `textobjects` query. Do not install an all-or-nothing mapping bundle based
    only on query-file presence.
11. Load Neo-tree through its key or command for normal starts, but load it
    eagerly when Neovim's sole startup argument is a directory so netrw does not
    claim that buffer first.
12. Add missing Which-key groups where they improve discoverability.

### Phase 5: Health And Documentation

1. Divide health checks into required base tools and optional feature tools.
2. Validate the Tree-sitter CLI version, `tar`, `curl`, and a C compiler.
3. Report Mojo environment managers and tools as optional project-level
   requirements.
4. Add Mason's `markdownlint` package to the tool installation list and verify
   that nvim-lint resolves the Mason-managed `markdownlint` executable.
5. Rewrite the README as documentation for this configuration while retaining
   a link to upstream Kickstart.
6. Update `AGENTS.md` so its layout, extension points, validation commands, and
   LSP ownership match the refactored configuration.
7. Remove stale comments that describe enabled plugin modules as optional
   examples.
8. Audit the cheatsheet against runtime mappings.
9. Correct stale Gitsigns, Mini Surround, Neo-tree, Harpoon, and navigation
   entries.
10. Update the cheatsheet date only after the runtime audit is complete.

## Validation

Run after each phase:

```sh
stylua --check .
git ls-files -z '*.lua' | xargs -0 -n1 luac -p
nvim --headless -u ./init.lua '+qa'
```

Run after the complete refactor:

```sh
nvim --headless -u ./init.lua '+checkhealth' '+qa'
nvim --headless -u ./init.lua '+checkhealth kickstart' '+qa'
nvim --headless -u ./init.lua '+checkhealth nvim-treesitter' '+qa'
```

Also verify interactively:

- `:Lazy` reports no failed specs or unexpected eager loads.
- `:Lazy profile` shows no major startup regression.
- `<C-h>`, `<C-j>`, `<C-k>`, and `<C-l>` navigate windows.
- `<leader>1` through `<leader>4` select Harpoon entries.
- `<leader>e` opens the Harpoon menu.
- Blink owns `<C-y>`, `<C-n>`, `<C-p>`, and `<C-e>` in insert mode.
- Copilot suggestion actions work through `<M-l>`, `<M-]>`, `<M-[>`, `<M-w>`,
  `<M-j>`, and `<M-e>`.
- Lua, Rust, and Mojo attach exactly one expected LSP client.
- Telescope-backed LSP mappings exist on the first attached buffer.
- Document highlighting works correctly with one and multiple clients.
- Mojo resolves LSP and formatter binaries from Pixi and virtual environments.
- Tree-sitter highlighting works for every configured parser.
- Each Tree-sitter textobject overrides a native mapping only when its specific
  capture exists in the active language.
- Markdown linting uses the Mason-managed executable.
- Persistence, Trouble, Gitsigns, Neo-tree, and Flash retain expected behavior.

## Acceptance Criteria

- The dependency baseline was refreshed through Lazy, breaking changes were
  reviewed, and the resulting lockfile was committed separately.
- `init.lua` contains only startup sequencing.
- Every active plugin spec is under `lua/custom/plugins/`.
- No active personal configuration remains under `lua/kickstart/plugins/`.
- All imported plugin modules return lists consistently.
- No known Harpoon/window or Copilot/Blink key conflict remains.
- Copilot's explicit Alt mappings are implemented and documented.
- Lua LS is configured and enabled once.
- LSP highlight autocmds are safe for multiple clients.
- Tree-sitter mappings are capture-aware and buffer-local; unsupported captures
  leave native mappings intact.
- Mason installs `markdownlint`, and nvim-lint resolves that managed executable.
- Headless startup, formatting, Lua syntax checks, and health checks pass.
- README, `AGENTS.md`, and cheatsheet describe the final runtime accurately.

## Risks And Controls

- Dependency changes can obscure structural regressions. Refresh and validate
  the Lazy lockfile in a separate baseline commit before moving modules.
- Moving many plugin specs can obscure behavioral regressions. Move one
  subsystem at a time and verify after each move.
- Lazy merges duplicate specs by plugin identity. Preserve valid dependency
  declarations and avoid deleting a declaration solely because a top-level spec
  exists elsewhere.
- Autocmd ordering can change when modules move. Keep leader setup before Lazy
  and register LSP handlers before enabling servers.
- Buffer-local Tree-sitter mappings can interact with filetype plugins. Inspect
  effective mappings with `:verbose map` in representative languages.
- Mojo tooling is project-local. Do not replace explicit executable discovery
  with `pixi run` or `uv run`, because opening a file should not mutate an
  environment.
- Do not combine plugin replacement or unrelated feature work with this
  structural refactor.
