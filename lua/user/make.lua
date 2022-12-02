local M = {}

local function createTypescriptCommand(cmd)
  local lines = { '' }
  local makeprg = cmd
  local errorformat = [[%A%f(%l\,%c): %trror TS%n: %m,%C%m,%-G]]

  local cmd = vim.fn.expandcmd(makeprg)

  local function on_event(job_id, data, event)
    if event == 'stdout' or event == 'stderr' then
      if data then
        vim.list_extend(lines, data)
      end
    end

    if event == 'exit' then
      vim.fn.setqflist({}, ' ', { title = cmd, lines = lines, efm = errorformat })
      vim.cmd([[ copen ]])
    end
  end

  local job_id = vim.fn.jobstart(cmd, {
    on_stderr = on_event,
    on_stdout = on_event,
    on_exit = on_event,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end

function M.typeCheck()
  createTypescriptCommand('yarn type-check')
end

function M.tscCheck()
  createTypescriptCommand('yarn tsc --noEmit')
end

function M.tsBuild()
  createTypescriptCommand('yarn tsc --build')
end

function M.ngCheck()
  createTypescriptCommand('yarn ng build')
end

vim.api.nvim_create_user_command('Mtc', M.typeCheck, {})
vim.api.nvim_create_user_command('Mtsc', M.tscCheck, {})
vim.api.nvim_create_user_command('Mtsb', M.tsBuild, {})
vim.api.nvim_create_user_command('Mng', M.ngCheck, {})

return M
