local M = {}

local root_markers = { 'pixi.toml', 'uv.lock', 'pyproject.toml', '.git' }

function M.root(path)
  local root = vim.fs.root(path, root_markers)
  if root then
    return root
  end

  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == 'directory' and path or vim.fs.dirname(path)
end

function M.executable(root, name)
  if root then
    for _, path in ipairs {
      root .. '/.pixi/envs/default/bin/' .. name,
      root .. '/.venv/bin/' .. name,
      root .. '/.derived/bin/' .. name,
    } do
      if vim.fn.executable(path) == 1 then
        return path
      end
    end
  end

  local path = vim.fn.exepath(name)
  return path ~= '' and path or name
end

return M
