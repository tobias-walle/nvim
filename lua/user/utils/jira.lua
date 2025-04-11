local M = {}
-- Function to select and paste Jira issue using vim.ui.select
function M.selectJiraIssue(additional_query)
  -- Execute the jira command and capture its output
  local cmd = 'jira issue list --plain --columns KEY,SUMMARY,ASSIGNEE,TYPE,STATUS -q "sprint in openSprints() AND issuetype not in subTaskIssueTypes()'
    .. (additional_query or '')
    .. '"'
  local output = vim.fn.system(cmd)

  -- Check if command produced any output
  if output == '' then
    print('No Jira issues found or jira command failed')
    return
  end

  -- Split the output into lines
  local lines = vim.split(output, '\n')

  -- Filter out empty lines and header line
  local issues = {}
  local issue_keys = {}

  for i, line in ipairs(lines) do
    if line ~= '' and i > 1 then -- Skip header line
      local issue_key = string.match(line, '(%S+-%d+)')
      if issue_key then
        local line_display = line:gsub('\t', ' | ')
        table.insert(issues, line_display)
        table.insert(issue_keys, issue_key)
      end
    end
  end

  if #issues == 0 then
    print('No valid Jira issues found')
    return
  end

  -- Use vim.ui.select to display and select from issues
  vim.ui.select(issues, {
    prompt = 'Select Jira Issue:',
  }, function(selected_item, idx)
    if selected_item then
      -- Extract the Jira issue key from the selected item
      local issue_key = issue_keys[idx]

      -- Paste the issue key at the cursor position
      vim.api.nvim_put({ issue_key }, 'c', true, true)
    end
  end)
end
return M
