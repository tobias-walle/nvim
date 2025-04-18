local M = {}

function M.pick_oil()
  local fd_available = vim.fn.executable('fd') == 1
  if not fd_available then
    vim.notify('fd command not found. Please install fd.', vim.log.levels.ERROR)
    return {}
  end

  Snacks.picker.pick({
    title = 'folders',
    finder = function()
      local cmd = {
        'fd',
        '--type',
        'd',
        '--hidden',
        '--exclude',
        '.git',
        '--color=never',
        '.',
        '.',
      }
      local result = vim.fn.systemlist(cmd)
      if vim.v.shell_error ~= 0 then
        vim.notify(
          'Error running fd command: ' .. table.concat(cmd, ' '),
          vim.log.levels.WARN
        )
        return {}
      end
      return vim
        .iter(result)
        :map(function(text) return { text = text } end)
        :totable()
    end,
    format = 'text',
    preview = function(ctx)
      local cmd = {
        'eza',
        '-al',
        '--no-permissions',
        '--no-filesize',
        '--no-user',
        '--no-time',
        '--icons=always',
        ctx.item.text,
      }
      vim.system(
        cmd,
        {},
        vim.schedule_wrap(function(result)
          local lines = vim.split(result.stdout or '', '\n')
          ctx.preview:reset()
          ctx.preview:set_lines(lines)
          ctx.preview:highlight({ ft = 'text' })
          ctx.preview:minimal()
        end)
      )
    end,
    confirm = function(picker, item)
      picker:close()
      vim.cmd('Oil ' .. item.text)
    end,
  })
end

M.pick_oil()

return M
