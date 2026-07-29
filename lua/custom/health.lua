local function executable(name, required)
  if vim.fn.executable(name) == 1 then
    vim.health.ok("Found executable: '" .. name .. "'")
  elseif required then
    vim.health.error("Required executable not found: '" .. name .. "'")
  else
    vim.health.warn("Optional executable not found: '" .. name .. "'")
  end
end

local function check_compiler()
  for _, compiler in ipairs { 'cc', 'gcc', 'clang', 'cl' } do
    if vim.fn.executable(compiler) == 1 then
      vim.health.ok("Found C compiler: '" .. compiler .. "'")
      return
    end
  end
  vim.health.error 'No C compiler found'
end

local function check_treesitter_cli()
  if vim.fn.executable 'tree-sitter' == 0 then
    vim.health.error "Required executable not found: 'tree-sitter' (0.26.1 or later)"
    return
  end

  local output = vim.fn.system { 'tree-sitter', '--version' }
  local version = output:match '(%d+%.%d+%.%d+)'
  if version and vim.version.ge(vim.version.parse(version), '0.26.1') then
    vim.health.ok('Tree-sitter CLI version: ' .. version)
  else
    vim.health.error('Tree-sitter CLI must be 0.26.1 or later; found: ' .. vim.trim(output))
  end
end

local function check_node()
  if vim.fn.executable 'node' == 0 then
    vim.health.warn "Optional executable not found: 'node' (22 or later is required for Copilot)"
    return
  end

  local output = vim.fn.system { 'node', '--version' }
  local version = output:match 'v?(%d+%.%d+%.%d+)'
  if version and vim.version.ge(vim.version.parse(version), '22.0.0') then
    vim.health.ok('Node.js version: ' .. version)
  else
    vim.health.warn('Copilot requires Node.js 22 or later; found: ' .. vim.trim(output))
  end
end

return {
  check = function()
    vim.health.start 'Custom Neovim configuration'

    if vim.version.ge(vim.version(), '0.12.0') then
      vim.health.ok('Neovim version: ' .. tostring(vim.version()))
    else
      vim.health.error('Neovim 0.12 or later is required; found: ' .. tostring(vim.version()))
    end

    vim.health.start 'Required base tools'
    for _, name in ipairs { 'git', 'curl', 'tar', 'unzip', 'gzip' } do
      executable(name, true)
    end
    check_compiler()
    check_treesitter_cli()

    vim.health.start 'Optional feature tools'
    for _, name in ipairs { 'make', 'rg', 'npm' } do
      executable(name, false)
    end
    check_node()

    local mason_markdownlint = vim.fn.stdpath 'data' .. '/mason/bin/markdownlint'
    if vim.uv.fs_stat(mason_markdownlint) then
      vim.health.ok('Found Mason-managed markdownlint: ' .. mason_markdownlint)
    else
      vim.health.warn 'Mason-managed markdownlint is not installed yet; run :MasonToolsInstallSync'
    end

    vim.health.start 'Optional Mojo project tools'
    for _, name in ipairs { 'pixi', 'uv', 'mojo', 'mojo-lsp-server' } do
      executable(name, false)
    end
    vim.health.info 'Mojo and mojo-lsp-server may be provided by a project-local Pixi or virtual environment.'
  end,
}
