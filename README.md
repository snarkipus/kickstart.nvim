# Neovim Configuration

Personal Neovim 0.12 configuration derived from
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). The configuration
uses subsystem modules rather than the original single-file layout.

## Requirements

Required tools:

- Neovim 0.12 or later
- `git`, `curl`, `tar`, `unzip`, and `gzip`
- A C compiler (`cc`, `gcc`, `clang`, or `cl`)
- `tree-sitter` CLI 0.26.1 or later, installed through the system package
  manager rather than npm
- A Nerd Font for configured icons and diagnostic signs

Optional feature tools:

- `make` for telescope-fzf-native and LuaSnip regex support
- `rg` for Telescope live grep
- Node.js 22 or later for Copilot, and `npm` for Mason's `markdownlint` package
- A clipboard provider appropriate for the operating system
- Pixi or `uv`, with project-local `mojo` and `mojo-lsp-server`, for Mojo
  projects

Run `:checkhealth custom` to inspect these requirements.

## Layout

- `init.lua` loads the core and plugin-manager modules.
- `lua/custom/core.lua` owns editor options, global mappings, and core
  autocommands.
- `lua/custom/lazy.lua` bootstraps and configures lazy.nvim.
- `lua/custom/health.lua` owns configuration-specific health policy.
- `lua/custom/mojo.lua` resolves Mojo project roots and executables.
- `lua/custom/plugins/` contains plugin specs grouped by subsystem.
- `lua/kickstart/health.lua` retains the Kickstart health-check entry point.
- `lua/kickstart/plugins/debug.lua` is an inactive DAP reference example.
- `CHEATSHEET.md` documents effective runtime mappings.

## Plugin Subsystems

- `completion.lua`: Blink, LuaSnip, and Copilot
- `editor.lua`: formatting, linting, indentation, autopairs, and Mini modules
- `lsp.lua`: LSP lifecycle, diagnostics, Mason, and server declarations
- `navigation.lua`: Telescope, Neo-tree, Harpoon, and Flash
- `treesitter.lua`: parsers, highlighting, indentation, and textobjects
- `ui.lua`: colorscheme, which-key, and TODO comments
- `workflow.lua`: Gitsigns, Trouble, and sessions

## Installation

Clone the repository to the Neovim configuration directory and start Neovim:

```sh
git clone https://github.com/snarkipus/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
nvim
```

Lazy installs plugins on first start. Mason then installs Lua LS, Rust Analyzer,
StyLua, and markdownlint. Mojo tools remain project-local and are not managed by
Mason.

Useful commands:

- `:Lazy` inspects or updates plugins.
- `:Mason` inspects managed external tools.
- `:checkhealth custom` checks configuration requirements.
- `:ConformInfo` shows formatter resolution.
- `:Copilot auth` authenticates Copilot.

## Validation

```sh
stylua --check .
git ls-files -z '*.lua' | xargs -0 -n1 luac -p
nvim --headless -u ./init.lua '+qa'
```

See `docs/refactor-plan.md` for architecture decisions and `CHEATSHEET.md` for
key mappings.
