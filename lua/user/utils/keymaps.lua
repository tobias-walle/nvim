local M = {}

---@param mode string | string[]
---@param shortcut string
---@param command string | function
---@param desc string
---@param opts? table<string, any>
---@return nil
function M.map(mode, shortcut, command, desc, opts)
  local options = vim.tbl_extend('force', { noremap = true, silent = true, desc = desc }, opts or {})
  vim.keymap.set(mode, shortcut, command, options)
end

---@param command string
---@param run string | function
---@param desc string
---@param opts? table<string, any>
---@return nil
function M.new_cmd(command, run, desc, opts)
  local options = vim.tbl_extend('force', { desc = desc }, opts or {})
  vim.api.nvim_create_user_command(command, run, options)
end

return M
