# Neovim Cheatsheet

## Table of Contents
- [Neovim Basics](#neovim-basics)
- [Leader Key](#leader-key)
- [Built-in Commands](#built-in-commands)
- [Navigation](#navigation)
- [Editing](#editing)
- [Search & Replace](#search--replace)
- [Windows & Splits](#windows--splits)
- [Buffers](#buffers)
- [Plugin Manager (Lazy)](#plugin-manager-lazy)
- [LSP & Diagnostics](#lsp--diagnostics)
- [Telescope (Fuzzy Finder)](#telescope-fuzzy-finder)
- [File Explorer (Neo-tree)](#file-explorer-neo-tree)
- [Git (Gitsigns)](#git-gitsigns)
- [Treesitter](#treesitter)
- [Harpoon](#harpoon)
- [Flash (Navigation)](#flash-navigation)
- [Copilot](#copilot)
- [Formatting & Linting](#formatting--linting)
- [Sessions (Persistence)](#sessions-persistence)
- [Trouble (Diagnostics)](#trouble-diagnostics)
- [Comments](#comments)
- [Surround](#surround)
- [Text Objects](#text-objects)
- [Which-key](#which-key)

---

## Neovim Basics

| Command | Description |
|---------|-------------|
| `:q` | Quit current window |
| `:q!` | Quit without saving |
| `:w` | Save file |
| `:wq` or `:x` | Save and quit |
| `:e <file>` | Open file |
| `:bn` / `:bp` | Next / previous buffer |
| `:bd` | Delete buffer |
| `:set number` | Show line numbers |
| `:set relativenumber` | Show relative line numbers |
| `:syntax on` | Enable syntax highlighting |
| `:help <topic>` | Open help for topic |
| `:Tutor` | Interactive tutorial |

---

## Leader Key

The **Leader** key is set to `<Space>`.

Most custom keybindings start with the leader key.

---

## Built-in Commands

| Command | Description |
|---------|-------------|
| `:checkhealth` | Run health checks |
| `:Lazy` | Open plugin manager |
| `:Mason` | Open LSP/linter/formatter manager |
| `:Telescope` | Open Telescope pickers |
| `:Copilot auth` | Authenticate GitHub Copilot |
| `:Copilot status` | Check Copilot status |
| `:ConformInfo` | Show formatter info |
| `:TSUpdate` | Update treesitter parsers |
| `:TSInstall <lang>` | Install treesitter parser |

---

## Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `h` / `j` / `k` / `l` | n | Left / down / up / right |
| `w` | n | Next word start |
| `W` | n | Next WORD start |
| `e` | n | Next word end |
| `E` | n | Next WORD end |
| `b` | n | Previous word start |
| `B` | n | Previous WORD start |
| `0` | n | Start of line |
| `^` | n | First non-blank character |
| `$` | n | End of line |
| `gg` | n | Go to first line |
| `G` | n | Go to last line |
| `<C-u>` | n | Half page up |
| `<C-d>` | n | Half page down |
| `<C-b>` | n | Full page up |
| `<C-f>` | n | Full page down |
| `zz` | n | Center current line |
| `%` | n | Jump to matching bracket |

### Window Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `<C-h>` | n | Move to left window |
| `<C-j>` | n | Move to lower window |
| `<C-k>` | n | Move to upper window |
| `<C-l>` | n | Move to right window |

---

## Editing

| Key | Mode | Description |
|-----|------|-------------|
| `i` | n | Insert before cursor |
| `I` | n | Insert at line start |
| `a` | n | Insert after cursor |
| `A` | n | Insert at line end |
| `o` | n | New line below, insert |
| `O` | n | New line above, insert |
| `r` | n | Replace character |
| `R` | n | Replace mode |
| `x` | n | Delete character |
| `dd` | n | Delete line |
| `yy` | n | Yank (copy) line |
| `yw` | n | Yank word |
| `p` | n | Paste after |
| `P` | n | Paste before |
| `u` | n | Undo |
| `<C-r>` | n | Redo |
| `.` | n | Repeat last command |
| `J` | n | Join lines |
| `>>` | n | Indent line |
| `<<` | n | Unindent line |
| `==` | n | Auto-indent line |

### Visual Mode

| Key | Mode | Description |
|-----|------|-------------|
| `v` | n | Visual mode (character) |
| `V` | n | Visual mode (line) |
| `<C-v>` | n | Visual mode (block) |
| `o` | v | Move to other end of selection |
| `gv` | n | Reselect last selection |

---

## Search & Replace

| Key | Mode | Description |
|-----|------|-------------|
| `/` | n | Search forward |
| `?` | n | Search backward |
| `n` | n | Next search result |
| `N` | n | Previous search result |
| `*` | n | Search word under cursor (forward) |
| `#` | n | Search word under cursor (backward) |
| `<Esc>` | n | Clear search highlights |
| `:s/old/new/g` | n | Replace in line |
| `:%s/old/new/g` | n | Replace in file |
| `:%s/old/new/gc` | n | Replace with confirmation |

---

## Windows & Splits

| Key | Mode | Description |
|-----|------|-------------|
| `:split` or `:sp` | n | Horizontal split |
| `:vsplit` or `:vs` | n | Vertical split |
| `<C-w>q` | n | Close current window |
| `<C-w>o` | n | Close other windows |
| `<C-w>=` | n | Equal window sizes |
| `<C-w>_` | n | Maximize height |
| `<C-w>\|` | n | Maximize width |

---

## Buffers

| Key | Mode | Description |
|-----|------|-------------|
| `:ls` | n | List buffers |
| `:bn` | n | Next buffer |
| `:bp` | n | Previous buffer |
| `:bd` | n | Delete buffer |
| `:b<n>` | n | Go to buffer n |
| `<leader><leader>` | n | Find existing buffers (Telescope) |

---

## Plugin Manager (Lazy)

| Command | Description |
|---------|-------------|
| `:Lazy` | Open Lazy UI |
| `:Lazy update` | Update all plugins |
| `:Lazy install` | Install missing plugins |
| `:Lazy clean` | Remove unused plugins |
| `:Lazy sync` | Sync (install + update + clean) |
| `:Lazy log` | View update log |
| `:Lazy profile` | View startup profile |
| `:Lazy debug` | Debug mode |
| `:Lazy help` | Help |
| `?` | In Lazy UI, show help |

---

## LSP & Diagnostics

### LSP Keymaps (available when LSP attached)

| Key | Mode | Description |
|-----|------|-------------|
| `grn` | n | Rename symbol |
| `gra` | n, x | Code action |
| `grD` | n | Go to declaration |
| `grr` | n | Go to references (Telescope) |
| `gri` | n | Go to implementation (Telescope) |
| `grd` | n | Go to definition (Telescope) |
| `grt` | n | Go to type definition (Telescope) |
| `gO` | n | Document symbols (Telescope) |
| `gW` | n | Workspace symbols (Telescope) |
| `K` | n | Hover documentation |
| `<C-k>` | i | Signature help |
| `<leader>th` | n | Toggle inlay hints |

### Diagnostics

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>q` | n | Open diagnostic quickfix list |
| `[d` | n | Previous diagnostic |
| `]d` | n | Next diagnostic |
| `<leader>xx` | n | Diagnostics (Trouble) |
| `<leader>xX` | n | Buffer diagnostics (Trouble) |
| `<leader>cs` | n | Symbols (Trouble) |
| `<leader>cl` | n | LSP definitions/references (Trouble) |

---

## Telescope (Fuzzy Finder)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>sh` | n | Search help |
| `<leader>sk` | n | Search keymaps |
| `<leader>sf` | n | Search files |
| `<leader>ss` | n | Search select Telescope |
| `<leader>sw` | n | Search current word |
| `<leader>sg` | n | Search by grep |
| `<leader>sd` | n | Search diagnostics |
| `<leader>sr` | n | Search resume |
| `<leader>s.` | n | Search recent files |
| `<leader>s/` | n | Search in open files |
| `<leader>sn` | n | Search Neovim config files |
| `<leader>/` | n | Fuzzy search in current buffer |
| `<C-/>` | i | Show Telescope keymaps |
| `?` | n | Show Telescope keymaps (normal mode) |

---

## File Explorer (Neo-tree)

| Key | Mode | Description |
|-----|------|-------------|
| `\` | n | Toggle file explorer (reveal current file) |

### Inside Neo-tree

| Key | Mode | Description |
|-----|------|-------------|
| `Enter` | n | Open file |
| `s` | n | Open in vertical split |
| `t` | n | Open in new tab |
| `a` | n | Add file/directory |
| `d` | n | Delete |
| `r` | n | Rename |
| `c` | n | Copy |
| `m` | n | Move |
| `y` | n | Copy to clipboard |
| `x` | n | Cut to clipboard |
| `p` | n | Paste from clipboard |
| `R` | n | Refresh |
| `H` | n | Toggle hidden files |
| `/` | n | Filter |
| `<C-h>` | n | Change root to parent |
| `\` | n | Close window |
| `?` | n | Show all keymaps |
| `q` | n | Close |

---

## Git (Gitsigns)

| Key | Mode | Description |
|-----|------|-------------|
| `]h` | n | Next git hunk |
| `[h` | n | Previous git hunk |
| `<leader>hs` | n | Stage hunk |
| `<leader>hr` | n | Reset hunk |
| `<leader>hS` | n | Stage buffer |
| `<leader>hu` | n | Undo stage hunk |
| `<leader>hR` | n | Reset buffer |
| `<leader>hp` | n | Preview hunk |
| `<leader>hb` | n | Blame line |
| `<leader>hd` | n | Diff this |
| `<leader>tb` | n | Toggle blame line |
| `<leader>hd` | n | Diff this (~) |
| `<leader>hs` | v | Stage hunk (visual) |
| `<leader>hr` | v | Reset hunk (visual) |

---

## Treesitter

### Text Objects

| Key | Mode | Description |
|-----|------|-------------|
| `aa` | o, x | Select around argument |
| `ia` | o, x | Select inside argument |
| `af` | o, x | Select around function |
| `if` | o, x | Select inside function |
| `ac` | o, x | Select around class |
| `ic` | o, x | Select inside class |
| `ab` | o, x | Select around block |
| `ib` | o, x | Select inside block |

### Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `]m` | n | Next function start |
| `[m` | n | Previous function start |
| `]M` | n | Next function end |
| `[M` | n | Previous function end |
| `]]` | n | Next class start |
| `[[` | n | Previous class start |
| `][` | n | Next class end |
| `[]` | n | Previous class end |

### Swap

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>sn` | n | Swap with next parameter |
| `<leader>sp` | n | Swap with previous parameter |

---

## Harpoon

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>a` | n | Add current file to harpoon |
| `<C-e>` | n | Toggle harpoon menu |
| `<C-h>` | n | Jump to harpoon file 1 |
| `<C-j>` | n | Jump to harpoon file 2 |
| `<C-k>` | n | Jump to harpoon file 3 |
| `<C-l>` | n | Jump to harpoon file 4 |

### Inside Harpoon Menu

| Key | Mode | Description |
|-----|------|-------------|
| `Enter` | n | Select file |
| `dd` | n | Remove file from list |
| `q` | n | Close menu |

---

## Flash (Navigation)

| Key | Mode | Description |
|-----|------|-------------|
| `s` | n, x, o | Jump to location |
| `S` | n, x, o | Treesitter jump |
| `r` | o | Remote (operate without moving cursor) |
| `<C-s>` | c | Toggle flash in search |

---

## Copilot

| Key | Mode | Description |
|-----|------|-------------|
| `<C-y>` | i | Accept suggestion |
| `<C-Right>` | i | Accept word |
| `<C-Down>` | i | Accept line |
| `<C-n>` | i | Next suggestion |
| `<C-p>` | i | Previous suggestion |
| `<C-e>` | i | Dismiss suggestion |

### Commands

| Command | Description |
|---------|-------------|
| `:Copilot auth` | Authenticate with GitHub |
| `:Copilot status` | Check authentication status |
| `:Copilot enable` | Enable Copilot |
| `:Copilot disable` | Disable Copilot |
| `:Copilot panel` | Open suggestion panel |

---

## Formatting & Linting

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>f` | n, x | Format buffer |
| `:ConformInfo` | - | Show formatter info |

Formatting is also automatic on save (via conform.nvim).

---

## Sessions (Persistence)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>qs` | n | Restore session for current directory |
| `<leader>ql` | n | Restore last session |
| `<leader>qd` | n | Don't save current session |

Sessions are automatically saved on exit.

---

## Trouble (Diagnostics)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>xx` | n | Toggle diagnostics |
| `<leader>xX` | n | Toggle buffer diagnostics |
| `<leader>cs` | n | Toggle symbols |
| `<leader>cl` | n | Toggle LSP definitions/references |
| `<leader>xL` | n | Toggle location list |
| `<leader>xQ` | n | Toggle quickfix list |

### Inside Trouble

| Key | Mode | Description |
|-----|------|-------------|
| `q` | n | Close |
| `?` | n | Show help |
| `r` | n | Refresh |
| `Enter` | n | Jump to item |
| `<C-v>` | n | Open in split |
| `<C-t>` | n | Open in tab |

---

## Comments

| Key | Mode | Description |
|-----|------|-------------|
| `gcc` | n | Toggle comment on line |
| `gc` | n, x | Toggle comment (motion/selection) |
| `gcO` | n | Add comment on line above |
| `gco` | n | Add comment on line below |
| `gcA` | n | Add comment at end of line |

---

## Surround

| Key | Mode | Description |
|-----|------|-------------|
| `ys{motion}{char}` | n | Add surround |
| `yss{char}` | n | Add surround to line |
| `ds{char}` | n | Delete surround |
| `cs{old}{new}` | n | Change surround |

### Examples

| Command | Result |
|---------|--------|
| `ysiw"` | Surround word with `"` |
| `ysiw)` | Surround word with `()` |
| `yss"` | Surround line with `"` |
| `ds"` | Delete `"` surround |
| `cs"')` | Change `"` to `()` |
| `dsq` | Delete surrounding quote |

### In Visual Mode

| Key | Mode | Description |
|-----|------|-------------|
| `S{char}` | x | Surround selection |

---

## Text Objects

### mini.ai Text Objects

| Key | Mode | Description |
|-----|------|-------------|
| `va{char}` | n, x | Select around text object |
| `vi{char}` | n, x | Select inside text object |
| `da{char}` | n, x | Delete around text object |
| `di{char}` | n, x | Delete inside text object |
| `ca{char}` | n, x | Change around text object |
| `ci{char}` | n, x | Change inside text object |
| `ya{char}` | n, x | Yank around text object |
| `yi{char}` | n, x | Yank inside text object |

### Available Text Objects

| Char | Description |
|------|-------------|
| `(` or `)` | Parentheses |
| `[` or `]` | Brackets |
| `{` or `}` | Braces |
| `<` or `>` | Angle brackets |
| `"` | Double quotes |
| `'` | Single quotes |
| `` ` `` | Backticks |
| `t` | Tag (HTML/XML) |
| `?` | Interactive query |

---

## Which-key

Press `<leader>` and wait to see available keymaps.

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>` | n | Show which-key menu |
| `<C-w>` | n | Show window keymaps |

### Which-key Groups

| Prefix | Description |
|--------|-------------|
| `<leader>c` | Code |
| `<leader>d` | Document |
| `<leader>r` | Rename |
| `<leader>s` | Search |
| `<leader>w` | Workspace |
| `<leader>t` | Toggle |
| `<leader>h` | Git hunk |
| `<leader>x` | Trouble |
| `<leader>q` | Session/Quickfix |

---

## Terminal Mode

| Key | Mode | Description |
|-----|------|-------------|
| `:terminal` | n | Open terminal |
| `<Esc><Esc>` | t | Exit terminal mode |
| `<C-\><C-n>` | t | Exit terminal mode (alternative) |

---

## Tips & Tricks

### Faster Editing
- Use `.` to repeat last action
- Use macros with `q{register}` to record, `q` to stop, `@{register}` to play
- Use `<C-a>` and `<C-x>` to increment/decrement numbers

### Multiple Cursors (via visual block)
1. `<C-v>` to enter visual block mode
2. Select lines with `j`/`k`
3. `I` to insert, or `c` to change
4. `<Esc>` to apply to all lines

### Quick File Navigation
- Use `<leader>sf` to find files quickly
- Use `<leader><leader>` to switch between open buffers
- Use `\` to reveal current file in file tree

### Search Tips
- Use `<leader>sw` to search for the word under cursor
- Use `<leader>sg` for live grep across project
- Use `<C-c>` to exit search without changing

---

## Configuration Files

| File | Description |
|------|-------------|
| `~/.config/nvim/init.lua` | Main configuration |
| `~/.config/nvim/lua/custom/plugins/` | Custom plugins |
| `~/.config/nvim/lua/kickstart/plugins/` | Kickstart plugins |
| `~/.local/share/nvim/` | Plugin data |
| `~/.local/state/nvim/` | State files (undo, sessions) |
| `~/.cache/nvim/` | Cache files |

---

*Generated for kickstart.nvim configuration*
*Last updated: 2025*
