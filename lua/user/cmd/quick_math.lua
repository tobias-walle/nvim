local function run_command(opts)
  if opts.line1 == nil or opts.line2 == nil then
    error('Selection required')
  end

  -- Get the lines from the command range
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, true)

  -- Concatenate lines and extract numbers, operators, and brackets
  local expression_symbols = {}
  local patterns = { '[%d]+%.?%d*', '[%+%-%*/%%%(%)]' }
  for _, line in ipairs(lines) do
    local line_symbols = {}
    for _, pattern in ipairs(patterns) do
      local start_pos = 1
      while true do
        local match_start, match_end = line:find(pattern, start_pos)
        if not match_start then
          break
        end
        local match = line:sub(match_start, match_end)
        table.insert(line_symbols, { symbol = match, position = match_start })
        start_pos = match_end + 1
      end
    end
    table.sort(line_symbols, function(a, b) return a.position < b.position end)
    for _, item in ipairs(line_symbols) do
      table.insert(expression_symbols, item.symbol)
    end
  end

  local expression = table.concat(expression_symbols, ' ')

  if expression == '' then
    vim.notify(
      'No valid expression found in the selection.',
      vim.log.levels.WARN
    )
    return
  end

  -- Evaluate the expression
  local func, err = load('return ' .. expression)
  if not func then
    vim.notify('Error compiling expression: ' .. err, vim.log.levels.ERROR)
    return
  end

  local success, result = pcall(func)
  if not success then
    vim.notify('Error evaluating expression: ' .. result, vim.log.levels.ERROR)
    return
  end

  -- Open the result in a popup buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    expression .. ' = ' .. result,
  })
  -- Set the filetype to lua for syntax highlighting
  vim.api.nvim_buf_set_option(buf, 'filetype', 'lua')
  vim.api.nvim_buf_set_option(buf, 'wrap', true)
  -- Close with q
  vim.api.nvim_buf_set_keymap(
    buf,
    'n',
    'q',
    '<cmd>bd!<CR>',
    { noremap = true, silent = true }
  )
  -- Open the window
  local width = 60
  local height = 20
  vim.api.nvim_open_win(buf, true, {
    style = 'minimal',
    relative = 'editor',
    width = width,
    height = height,
    row = (vim.o.lines - height) / 2,
    col = (vim.o.columns - width) / 2,
    border = 'rounded',
  })
end

vim.api.nvim_create_user_command('QuickMath', run_command, { range = true })
