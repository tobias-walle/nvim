local function evaluate_expression(expression)
  local func = load('return ' .. expression)
  if func then
    local success, eval_result = pcall(func)
    if success then
      return eval_result or 'ERROR'
    end
  end
  return 'ERROR'
end

local function render_result_to_buffer(bufnr, expression, result)
  if vim.trim(expression) == '' then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
      expression,
    })
    return
  end

  if not expression:match('%s$') then
    expression = expression .. ' '
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
    expression .. '= ' .. result,
  })
end

local function render_result_buffer(expression)
  local bufnr = vim.api.nvim_create_buf(false, true)
  render_result_to_buffer(bufnr, expression, evaluate_expression(expression))
  vim.api.nvim_buf_set_name(bufnr, 'Quick Math Result')
  vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
  vim.api.nvim_buf_set_option(bufnr, 'wrap', true)
  vim.api.nvim_buf_set_option(bufnr, 'filetype', 'lua')
  -- Open the window
  local width = 60
  local height = 20
  vim.api.nvim_open_win(bufnr, true, {
    style = 'minimal',
    relative = 'editor',
    width = width,
    height = height,
    row = (vim.o.lines - height) / 2,
    col = (vim.o.columns - width) / 2,
    border = 'rounded',
  })

  -- Set up autocmd for live updates
  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    buffer = bufnr,
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local expression = lines[1]:match('^([^=]+%s*)') or ''
      if expression then
        local result = evaluate_expression(expression)
        render_result_to_buffer(bufnr, expression, result)
      end
    end,
  })

  -- Create function to close buffer
  local delete_buffer = function()
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end

  -- Close with q
  vim.keymap.set(
    'n',
    'q',
    delete_buffer,
    { buffer = bufnr, noremap = true, silent = true }
  )

  -- Close on leave
  vim.api.nvim_create_autocmd('BufLeave', {
    buffer = bufnr,
    callback = delete_buffer,
  })
end

local function run_command(opts)
  if opts.args ~= '' or opts.range == 0 then
    render_result_buffer(opts.args or '')
    return
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
  render_result_buffer(expression)
end

vim.api.nvim_create_user_command(
  'QuickMath',
  run_command,
  { range = true, nargs = '*' }
)
