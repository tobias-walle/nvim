local M = {}

local active_list = 'quick_fix'

local function activate_list(list)
  print('Activate ' .. list)
  active_list = list
end

function M.activate_local_list() activate_list('local') end

function M.activate_quick_fix_list() activate_list('quick_fix') end

function M.toggle_active_list()
  local list
  if active_list == 'quick_fix' then
    list = 'local'
  elseif active_list == 'local' then
    list = 'quick_fix'
  end
  print('Activate ' .. list)
  active_list = list
end

local function run_cmd(cmd_to_run)
  local ok, result = pcall(vim.cmd, cmd_to_run)
  print(result)
end

function M.next_in_active_list()
  if active_list == 'quick_fix' then
    run_cmd('cnext')
  elseif active_list == 'local' then
    run_cmd('lnext')
  end
end

function M.previous_in_active_list()
  if active_list == 'quick_fix' then
    run_cmd('cprevious')
  elseif active_list == 'local' then
    run_cmd('lprevious')
  end
end

return M
