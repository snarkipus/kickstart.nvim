-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<C-y>',
          accept_word = '<C-Right>',
          accept_line = '<C-Down>',
          next = '<C-n>',
          prev = '<C-p>',
          dismiss = '<C-e>',
        },
      },
      panel = { enabled = false },
    },
  },

  {
    'folke/trouble.nvim',
    opts = {},
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },

  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
    keys = {
      {
        '<leader>qs',
        function()
          require('persistence').load()
        end,
        desc = 'Restore Session',
      },
      {
        '<leader>ql',
        function()
          require('persistence').load { last = true }
        end,
        desc = 'Restore Last Session',
      },
      {
        '<leader>qd',
        function()
          require('persistence').stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      {
        '<leader>a',
        function()
          require('harpoon'):list():add()
        end,
        desc = 'Harpoon: Add file',
      },
      {
        '<C-e>',
        function()
          require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
        end,
        desc = 'Harpoon: Toggle menu',
      },
      {
        '<C-h>',
        function()
          require('harpoon'):list():select(1)
        end,
        desc = 'Harpoon: File 1',
      },
      {
        '<C-j>',
        function()
          require('harpoon'):list():select(2)
        end,
        desc = 'Harpoon: File 2',
      },
      {
        '<C-k>',
        function()
          require('harpoon'):list():select(3)
        end,
        desc = 'Harpoon: File 3',
      },
      {
        '<C-l>',
        function()
          require('harpoon'):list():select(4)
        end,
        desc = 'Harpoon: File 4',
      },
    },
    opts = {},
  },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash: Jump',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash: Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Flash: Remote',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Flash: Toggle search',
      },
    },
  },
}
