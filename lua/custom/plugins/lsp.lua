local function telescope(picker)
  return function()
    require('telescope.builtin')[picker]()
  end
end

return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      local highlight_buffers = {}
      local highlight_group = vim.api.nvim_create_augroup('custom-lsp-highlight', { clear = true })
      local lifecycle_group = vim.api.nvim_create_augroup('custom-lsp-lifecycle', { clear = true })
      local highlight_method = vim.lsp.protocol.Methods.textDocument_documentHighlight

      vim.api.nvim_create_autocmd('LspAttach', {
        group = lifecycle_group,
        callback = function(event)
          local bufnr = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local function map(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('grr', telescope 'lsp_references', '[G]oto [R]eferences')
          map('gri', telescope 'lsp_implementations', '[G]oto [I]mplementation')
          map('grd', telescope 'lsp_definitions', '[G]oto [D]efinition')
          map('gO', telescope 'lsp_document_symbols', 'Document Symbols')
          map('gW', telescope 'lsp_dynamic_workspace_symbols', 'Workspace Symbols')
          map('grt', telescope 'lsp_type_definitions', '[G]oto [T]ype Definition')

          if client and client:supports_method(highlight_method, bufnr) and not highlight_buffers[bufnr] then
            highlight_buffers[bufnr] = true
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = bufnr,
              group = highlight_group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = bufnr,
              group = highlight_group,
              callback = vim.lsp.buf.clear_references,
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = lifecycle_group,
        callback = function(event)
          local bufnr = event.buf
          local detached_client_id = event.data.client_id
          local has_highlight_client = vim.iter(vim.lsp.get_clients { bufnr = bufnr }):any(function(client)
            return client.id ~= detached_client_id and client:supports_method(highlight_method, bufnr)
          end)
          if has_highlight_client then
            return
          end

          highlight_buffers[bufnr] = nil
          vim.api.nvim_clear_autocmds { group = highlight_group, buffer = bufnr }
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_call(bufnr, vim.lsp.buf.clear_references)
          end
        end,
      })

      vim.diagnostic.config {
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = { source = 'if_many', spacing = 2 },
        jump = {
          on_jump = function(diagnostic, bufnr)
            if diagnostic then
              vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
            end
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local servers = {
        rust_analyzer = {},
        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT',
                path = { 'lua/?.lua', 'lua/?/init.lua' },
              },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file('', true),
              },
            })
          end,
          settings = {
            Lua = { completion = { callSnippet = 'Replace' } },
          },
        },
        mojo = {
          root_dir = function(bufnr, on_dir)
            local path = vim.api.nvim_buf_get_name(bufnr)
            on_dir(require('custom.mojo').root(path ~= '' and path or vim.fn.getcwd()))
          end,
          cmd = function(dispatchers, config)
            return vim.lsp.rpc.start({ require('custom.mojo').executable(config.root_dir, 'mojo-lsp-server') }, dispatchers, { cwd = config.root_dir })
          end,
        },
      }

      local ensure_installed = { 'lua-language-server', 'rust-analyzer', 'stylua', 'markdownlint' }
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },
}
