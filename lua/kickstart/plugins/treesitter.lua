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
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    'nvim-treesitter/nvim-treesitter-context',
  },
  init = function()
    local group = vim.api.nvim_create_augroup('kickstart-treesitter', { clear = true })
    vim.api.nvim_create_autocmd('User', {
      pattern = 'TSUpdate',
      group = group,
      callback = register_mojo_parser,
    })
  end,
  config = function()
    local treesitter = require 'nvim-treesitter'
    treesitter.setup {}
    register_mojo_parser()
    treesitter.install(ensure_installed)

    local group = vim.api.nvim_create_augroup('kickstart-treesitter', { clear = false })
    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      callback = function(event)
        local filetype = vim.bo[event.buf].filetype
        local language = vim.treesitter.language.get_lang(filetype) or filetype
        if not vim.tbl_contains(ensure_installed, language) then
          return
        end

        local ok = pcall(vim.treesitter.start, event.buf, language)
        if ok and filetype ~= 'mojo' then
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    require('nvim-treesitter-textobjects').setup {
      select = { lookahead = true },
      move = { set_jumps = true },
    }

    local select = require 'nvim-treesitter-textobjects.select'
    local move = require 'nvim-treesitter-textobjects.move'
    local swap = require 'nvim-treesitter-textobjects.swap'

    local select_mappings = {
      aa = { '@parameter.outer', 'Select outer parameter' },
      ia = { '@parameter.inner', 'Select inner parameter' },
      af = { '@function.outer', 'Select outer function' },
      ['if'] = { '@function.inner', 'Select inner function' },
      ac = { '@class.outer', 'Select outer class' },
      ic = { '@class.inner', 'Select inner class' },
      ab = { '@block.outer', 'Select outer block' },
      ib = { '@block.inner', 'Select inner block' },
    }
    for keys, mapping in pairs(select_mappings) do
      local query, desc = mapping[1], mapping[2]
      vim.keymap.set({ 'x', 'o' }, keys, function()
        select.select_textobject(query, 'textobjects')
      end, { desc = desc })
    end

    local move_mappings = {
      [']m'] = { move.goto_next_start, '@function.outer', 'Next function start' },
      [']]'] = { move.goto_next_start, '@class.outer', 'Next class start' },
      [']M'] = { move.goto_next_end, '@function.outer', 'Next function end' },
      [']['] = { move.goto_next_end, '@class.outer', 'Next class end' },
      ['[m'] = { move.goto_previous_start, '@function.outer', 'Previous function start' },
      ['[['] = { move.goto_previous_start, '@class.outer', 'Previous class start' },
      ['[M'] = { move.goto_previous_end, '@function.outer', 'Previous function end' },
      ['[]'] = { move.goto_previous_end, '@class.outer', 'Previous class end' },
    }
    for keys, mapping in pairs(move_mappings) do
      local movement, query, desc = mapping[1], mapping[2], mapping[3]
      vim.keymap.set({ 'n', 'x', 'o' }, keys, function()
        movement(query, 'textobjects')
      end, { desc = desc })
    end

    vim.keymap.set('n', '<leader>sN', function()
      swap.swap_next('@parameter.inner', 'textobjects')
    end, { desc = 'Swap with next parameter' })
    vim.keymap.set('n', '<leader>sp', function()
      swap.swap_previous('@parameter.inner', 'textobjects')
    end, { desc = 'Swap with previous parameter' })
  end,
}
