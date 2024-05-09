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
  'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    require('nvim-treesitter.configs').setup({
      ensured_installed = {
        'angular',
        'astro',
        'awk',
        'bash',
        'c',
        'c_sharp',
        'comment',
        'cpp',
        'css',
        'csv',
        'diff',
        'dockerfile',
        'gdscript',
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'go',
        'gdresource',
        'graphql',
        'html',
        'hurl',
        'java',
        'javascript',
        'jq',
        'jsdoc',
        'json',
        'json5',
        'jsonc',
        'jsonnet',
        'just',
        'kotlin',
        'latex',
        'lua',
        'luadoc',
        'lua_patterns',
        'markdown',
        'markdown_inline',
        'nix',
        'passwd',
        'proto',
        'python',
        'query',
        'r',
        'regex',
        'requirements',
        'ruby',
        'rust',
        'sql',
        'scss',
        'ssh_config',
        'svelte',
        'terraform',
        'tmux',
        'toml',
        'typescript',
        'tsv',
        'vim',
        'vimdoc',
        'vue',
        'xml',
        'yaml',
      },
      auto_install = true,
      sync_install = false,
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
  end,
}

return plugin
