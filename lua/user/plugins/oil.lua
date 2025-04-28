-- local function save_unsaved_buffers()
--   for _, buf in ipairs(vim.api.nvim_list_bufs()) do
--     if
--       vim.api.nvim_buf_get_option(buf, 'modified')
--       and vim.api.nvim_buf_get_option(buf, 'buftype') == ''
--     then
--       vim.api.nvim_buf_call(buf, function() vim.cmd('write') end)
--     end
--   end
-- end

---@type LazySpec
local plugin = {
  'stevearc/oil.nvim',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'folke/snacks.nvim',
  },
  config = function()
    local oil = require('oil')
    oil.setup({
      default_file_explorer = true,
      skip_confirm_for_simple_edits = false,
      delete_to_trash = false,
      use_default_keymaps = false,
      keymaps = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['L'] = 'actions.select',
        ['<C-s>'] = {
          'actions.select',
          opts = { vertical = true },
          desc = 'Open the entry in a vertical split',
        },
        ['<C-t>'] = {
          'actions.select',
          opts = { tab = true },
          desc = 'Open the entry in new tab',
        },
        ['<C-c>'] = 'actions.close',
        ['<C-r>'] = 'actions.refresh',
        ['P'] = 'actions.preview',
        ['-'] = 'actions.parent',
        ['H'] = 'actions.parent',
        ['_'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = {
          'actions.cd',
          opts = { scope = 'tab' },
          desc = ':tcd to the current oil directory',
        },
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
      },
      columns = { 'icon' },
      lsp_file_methods = {
        enabled = true,
      },
      view_options = {
        show_hidden = true,
      },
    })
    --
    -- local function oil_event_to_lsp_changes(event)
    --   local changes = { files = {} }
    --   for _, action in ipairs(event.data.actions) do
    --     if action.type == 'move' then
    --       local src = action.src_url:gsub('^oil://', '')
    --       local dest = action.dest_url:gsub('^oil://', '')
    --       table.insert(changes.files, {
    --         oldUri = vim.uri_from_fname(src),
    --         newUri = vim.uri_from_fname(dest),
    --       })
    --     end
    --   end
    --   return changes
    -- end
    --
    -- vim.api.nvim_create_autocmd('User', {
    --   pattern = 'OilActionsPre',
    --   callback = function(event)
    --     local changes = oil_event_to_lsp_changes(event)
    --
    --     local clients = vim.lsp.get_clients()
    --     for _, client in ipairs(clients) do
    --       if client:supports_method('workspace/willRenameFiles') then
    --         local resp =
    --           client:request_sync('workspace/willRenameFiles', changes, 1000, 0)
    --         if resp and resp.result ~= nil then
    --           dbg(resp.result)
    --           vim.lsp.util.apply_workspace_edit(
    --             resp.result,
    --             client.offset_encoding
    --           )
    --         end
    --       end
    --     end
    --     save_unsaved_buffers()
    --   end,
    -- })
    --
    -- vim.api.nvim_create_autocmd('User', {
    --   pattern = 'OilActionsPost',
    --   callback = function(event)
    --     local changes = oil_event_to_lsp_changes(event)
    --     local clients = vim.lsp.get_clients()
    --     for _, client in ipairs(clients) do
    --       if client:supports_method('workspace/didRenameFiles') then
    --         client:notify('workspace/didRenameFiles', changes)
    --       end
    --     end
    --   end,
    -- })
  end,
}

return plugin
