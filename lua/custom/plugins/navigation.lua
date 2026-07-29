local function telescope(picker, opts)
  return function()
    require('telescope.builtin')[picker](opts)
  end
end

local directory_start = vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1

return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      'nvim-telescope/telescope-ui-select.nvim',
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    keys = {
      { '<leader>sh', telescope 'help_tags', desc = '[S]earch [H]elp' },
      { '<leader>sk', telescope 'keymaps', desc = '[S]earch [K]eymaps' },
      { '<leader>sf', telescope 'find_files', desc = '[S]earch [F]iles' },
      { '<leader>ss', telescope 'builtin', desc = '[S]earch [S]elect Telescope' },
      { '<leader>sw', telescope 'grep_string', desc = '[S]earch current [W]ord' },
      { '<leader>sg', telescope 'live_grep', desc = '[S]earch by [G]rep' },
      { '<leader>sd', telescope 'diagnostics', desc = '[S]earch [D]iagnostics' },
      { '<leader>sr', telescope 'resume', desc = '[S]earch [R]esume' },
      { '<leader>s.', telescope 'oldfiles', desc = '[S]earch Recent Files' },
      { '<leader><leader>', telescope 'buffers', desc = '[ ] Find existing buffers' },
      {
        '<leader>/',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
        end,
        desc = '[/] Fuzzily search in current buffer',
      },
      { '<leader>s/', telescope('live_grep', { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }), desc = '[S]earch [/] in Open Files' },
      { '<leader>sn', telescope('find_files', { cwd = vim.fn.stdpath 'config' }), desc = '[S]earch [N]eovim files' },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = require('telescope.themes').get_dropdown(),
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    lazy = not directory_start,
    cmd = 'Neotree',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    keys = {
      { '\\', '<cmd>Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    opts = {
      filesystem = {
        window = { mappings = { ['\\'] = 'close_window' } },
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
        '<leader>e',
        function()
          require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
        end,
        desc = 'Harpoon: Toggle menu',
      },
      {
        '<leader>1',
        function()
          require('harpoon'):list():select(1)
        end,
        desc = 'Harpoon: File 1',
      },
      {
        '<leader>2',
        function()
          require('harpoon'):list():select(2)
        end,
        desc = 'Harpoon: File 2',
      },
      {
        '<leader>3',
        function()
          require('harpoon'):list():select(3)
        end,
        desc = 'Harpoon: File 3',
      },
      {
        '<leader>4',
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
        '<C-s>',
        mode = 'c',
        function()
          require('flash').toggle()
        end,
        desc = 'Flash: Toggle search',
      },
    },
  },
}
