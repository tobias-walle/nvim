local disable_big_files = function(lang, buf)
  -- ignore big files
  local max_filesize = 50 * 1024 -- 50 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
  return false
end

---@diagnostic disable: missing-fields
---@type LazySpec
local plugin = {
  --- The treesitter plugin is managed by nix
  dir = '~/.local/share/nvim/nix/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
  config = function()
    require('nvim-treesitter.configs').setup({
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        -- disable = disable_big_files,
      },
      indent = {
        enable = true,
        disable = disable_big_files,
      },
      context_commentstring = {
        enable = true,
        disable = disable_big_files,
        enable_autocmd = false,
      },
      textobjects = {
        swap = {
          enable = true,
          disable = disable_big_files,
          swap_next = {
            ['<leader>np'] = '@parameter.inner',
            ['<leader>nb'] = '@block.outer',
            ['<leader>nf'] = '@function.outer',
          },
          swap_previous = {
            ['<leader>Np'] = '@parameter.inner',
            ['<leader>Nf'] = '@function.outer',
          },
        },
      },
    })
  end,
}

return plugin
