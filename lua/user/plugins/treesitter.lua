---@diagnostic disable-next-line: unused-local
local disable_big_files = function(lang, buf)
  -- ignore big files
  local max_filesize = 1024 * 1024 -- 1 Mb
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
  return false
end

---@diagnostic disable: missing-fields
---@type LazySpec
local plugin = {
  'nvim-treesitter/nvim-treesitter',
  build = function() vim.cmd('TSUpdate') end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-context',
  },
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = 'all',
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = disable_big_files,
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
    require('treesitter-context').setup({
      enable = true,
      mode = 'topline',
      max_lines = 5,
      multiline_threshold = 1,
      trim_scope = 'inner',
    })
  end,
}

return plugin
