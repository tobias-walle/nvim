---@type LazySpec
local plugin = {
  'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-context',
  },
  config = function()
    require('treesitter-context').setup({
      enable = true,
    })
    vim.g.skip_ts_context_commentstring_module = true
    ---@diagnostic disable-next-line: missing-fields
    require('ts_context_commentstring').setup({})
    ---@diagnostic disable-next-line: missing-fields
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
        disable = function(lang, buf)
          -- ignore big files
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats =
            pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = { enable = true },
      context_commentstring = { enable = true, enable_autocmd = false },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<cr>',
          show_help = '?',
        },
      },
      textobjects = {
        swap = {
          enable = true,
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
