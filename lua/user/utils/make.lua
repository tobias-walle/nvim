local M = {}

function M.runTypescriptCommand(cmd)
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
      vim.fn.setqflist(
        {},
        ' ',
        { title = cmd, lines = lines, efm = errorformat }
      )
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

return M
