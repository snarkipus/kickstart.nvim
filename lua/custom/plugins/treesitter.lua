local ensure_installed = {
  'bash',
  'c',
  'diff',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'mojo',
  'query',
  'vim',
  'vimdoc',
}

local function register_mojo_parser()
  require('nvim-treesitter.parsers').mojo = {
    install_info = {
      url = 'https://github.com/dmitry-salin/tree-sitter-mojo',
      revision = '2901b90f88c0b85cc2c96d6c387e805b3956ff4e',
      queries = 'nvim-queries/mojo',
    },
    tier = 2,
  }
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
      { 'nvim-treesitter/nvim-treesitter-context', opts = {} },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'TSUpdate',
        group = vim.api.nvim_create_augroup('custom-treesitter-parser', { clear = true }),
        callback = register_mojo_parser,
      })
    end,
    config = function()
      local treesitter = require 'nvim-treesitter'
      local select = require 'nvim-treesitter-textobjects.select'
      local move = require 'nvim-treesitter-textobjects.move'
      local swap = require 'nvim-treesitter-textobjects.swap'
      local installed_mappings = {}

      treesitter.setup {}
      register_mojo_parser()
      treesitter.install(ensure_installed)
      require('nvim-treesitter-textobjects').setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }

      local mappings = {
        {
          { 'x', 'o' },
          'aa',
          '@parameter.outer',
          select.select_textobject,
          'Select outer parameter',
        },
        {
          { 'x', 'o' },
          'ia',
          '@parameter.inner',
          select.select_textobject,
          'Select inner parameter',
        },
        {
          { 'x', 'o' },
          'af',
          '@function.outer',
          select.select_textobject,
          'Select outer function',
        },
        {
          { 'x', 'o' },
          'if',
          '@function.inner',
          select.select_textobject,
          'Select inner function',
        },
        {
          { 'x', 'o' },
          'ac',
          '@class.outer',
          select.select_textobject,
          'Select outer class',
        },
        {
          { 'x', 'o' },
          'ic',
          '@class.inner',
          select.select_textobject,
          'Select inner class',
        },
        {
          { 'x', 'o' },
          'ab',
          '@block.outer',
          select.select_textobject,
          'Select outer block',
        },
        {
          { 'x', 'o' },
          'ib',
          '@block.inner',
          select.select_textobject,
          'Select inner block',
        },
        { { 'n', 'x', 'o' }, ']m', '@function.outer', move.goto_next_start, 'Next function start' },
        { { 'n', 'x', 'o' }, ']]', '@class.outer', move.goto_next_start, 'Next class start' },
        { { 'n', 'x', 'o' }, ']M', '@function.outer', move.goto_next_end, 'Next function end' },
        { { 'n', 'x', 'o' }, '][', '@class.outer', move.goto_next_end, 'Next class end' },
        { { 'n', 'x', 'o' }, '[m', '@function.outer', move.goto_previous_start, 'Previous function start' },
        { { 'n', 'x', 'o' }, '[[', '@class.outer', move.goto_previous_start, 'Previous class start' },
        { { 'n', 'x', 'o' }, '[M', '@function.outer', move.goto_previous_end, 'Previous function end' },
        { { 'n', 'x', 'o' }, '[]', '@class.outer', move.goto_previous_end, 'Previous class end' },
        { 'n', '<leader>sN', '@parameter.inner', swap.swap_next, 'Swap with next parameter' },
        { 'n', '<leader>sp', '@parameter.inner', swap.swap_previous, 'Swap with previous parameter' },
      }

      local function clear_mappings(bufnr)
        for _, mapping in ipairs(installed_mappings[bufnr] or {}) do
          pcall(vim.keymap.del, mapping[1], mapping[2], { buffer = bufnr })
        end
        installed_mappings[bufnr] = nil
      end

      local function configure_buffer(bufnr)
        clear_mappings(bufnr)
        local filetype = vim.bo[bufnr].filetype
        local language = vim.treesitter.language.get_lang(filetype) or filetype
        if not vim.tbl_contains(ensure_installed, language) then
          return
        end

        local parser_ok, parser = pcall(vim.treesitter.get_parser, bufnr, language)
        if not parser_ok or not parser then
          return
        end
        if not pcall(vim.treesitter.start, bufnr, language) then
          return
        end
        if filetype ~= 'mojo' then
          vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        local query_ok, query = pcall(vim.treesitter.query.get, language, 'textobjects')
        if not query_ok or not query then
          return
        end

        for _, mapping in ipairs(mappings) do
          local modes, keys, capture, action, desc = unpack(mapping)
          if vim.tbl_contains(query.captures, capture:sub(2)) then
            vim.keymap.set(modes, keys, function()
              action(capture, 'textobjects')
            end, { buffer = bufnr, desc = desc })
            installed_mappings[bufnr] = installed_mappings[bufnr] or {}
            table.insert(installed_mappings[bufnr], { modes, keys })
          end
        end
      end

      local group = vim.api.nvim_create_augroup('custom-treesitter', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        callback = function(event)
          configure_buffer(event.buf)
        end,
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'TSUpdate',
        group = group,
        callback = function()
          register_mojo_parser()
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(bufnr) then
              configure_buffer(bufnr)
            end
          end
        end,
      })
      vim.api.nvim_create_autocmd('BufWipeout', {
        group = group,
        callback = function(event)
          installed_mappings[event.buf] = nil
        end,
      })
    end,
  },
}
