return {
  { 'NMAC427/guess-indent.nvim', opts = {} },
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    cmd = 'ConformInfo',
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.tbl_contains({ 'c', 'cpp' }, vim.bo[bufnr].filetype) then
          return
        end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        mojo = { 'mojo_format' },
      },
      formatters = {
        mojo_format = {
          command = function(_, ctx)
            local mojo = require 'custom.mojo'
            return mojo.executable(mojo.root(ctx.filename), 'mojo')
          end,
        },
      },
    },
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = { markdown = { 'markdownlint' } }
      lint.linters.markdownlint.args = vim.list_extend({ '--disable', 'MD013', 'MD041', 'MD033' }, lint.linters.markdownlint.args or { '--stdin' })

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('custom-lint', { clear = true }),
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
  {
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.comment').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}
