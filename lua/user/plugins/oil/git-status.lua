-- Based on https://gist.github.com/bassamsdata/eec0a3065152226581f8d4244cce9051 but modified for oil.nvim
local M = {}

local ns_id = vim.api.nvim_create_namespace('oil_git')

-- Cache for git status
local git_status_cache = {}
local cacheTimeout = 2000

vim.api.nvim_set_hl(0, 'OilGitIgnore', {
  link = 'Comment',
})

---@type table<string, {symbol: string, hlGroup: string}>
---@param status string
---@return { symbol: string, hl_group: string } | nil
local function map_status(status)
  local status_map = {
    -- stylua: ignore start
    [" M"] = { symbol = "• ",  hl_group  = "GitSignsChange"}, -- Modified in the working directory
    ["M "] = { symbol = "✹ ",  hl_group  = "GitSignsChange"}, -- modified in index
    ["MM"] = { symbol = "≠ ",  hl_group  = "GitSignsChange"}, -- modified in both working tree and index
    ["A "] = { symbol = "+ ",  hl_group  = "GitSignsAdd"   }, -- Added to the staging area, new file
    ["AA"] = { symbol = "≈ ",  hl_group  = "GitSignsAdd"   }, -- file is added in both working tree and index
    ["D "] = { symbol = "- ",  hl_group  = "GitSignsDelete"}, -- Deleted from the staging area
    ["AM"] = { symbol = "⊕ ",  hl_group  = "GitSignsChange"}, -- added in working tree, modified in index
    ["AD"] = { symbol = "-•",  hl_group = "GitSignsChange"}, -- Added in the index and deleted in the working directory
    ["R "] = { symbol = "→ ",  hl_group  = "GitSignsChange"}, -- Renamed in the index
    ["U "] = { symbol = "‖ ",  hl_group  = "GitSignsChange"}, -- Unmerged path
    ["UU"] = { symbol = "⇄ ",  hl_group  = "GitSignsAdd"   }, -- file is unmerged
    ["UA"] = { symbol = "⊕ ",  hl_group  = "GitSignsAdd"   }, -- file is unmerged and added in working tree
    ["??"] = { symbol = "? ",  hl_group  = "GitSignsDelete"}, -- Untracked files
    ["!!"] = { symbol = "! ",  hl_group  = "Comment"}, -- Ignored files
    -- stylua: ignore end
  }

  local result = status_map[status]
  return result
end

---@param str string?
local function escapePattern(str)
  str = str or ''
  return str:gsub('([%^%$%(%)%%%.%[%]%*%+%-%?])', '%%%1')
end

-- Thanks for the idea of gettings https://github.com/refractalize/oil-git-status.nvim signs for dirs
---@param content string
---@return table
local function parse_git_status(content)
  local gitStatusMap = {}
  -- lua match is faster than vim.split (in my experience )
  for line in content:gmatch('[^\r\n]+') do
    local status, filePath = string.match(line, '^(..)%s+(.*)')
    -- Split the file path into parts
    local parts = {}
    for part in filePath:gmatch('[^/]+') do
      table.insert(parts, part)
    end
    -- Start with the root directory
    local currentKey = ''
    for i, part in ipairs(parts) do
      if i > 1 then
        -- Concatenate parts with a separator to create a unique key
        currentKey = currentKey .. '/' .. part
      else
        currentKey = part
      end
      -- If it's the last part, it's a file, so add it with its status
      if i == #parts then
        gitStatusMap[currentKey] = status
      else
        -- If it's not the last part, it's a directory. Check if it exists, if not, add it.
        if not gitStatusMap[currentKey] then
          gitStatusMap[currentKey] = status
        end
      end
    end
  end
  return gitStatusMap
end

---@param cwd string
---@param callback fun(status_map: table | nil)
local function update_git_status(cwd, callback)
  vim.system(
    { 'git', 'status', '--ignored', '--porcelain' },
    { text = true, cwd = cwd },
    function(content)
      if content.code == 0 then
        vim.g.content = content.stdout
        callback(parse_git_status(content.stdout))
      else
        callback(nil)
      end
    end
  )
end

---@param buf_id integer
---@param file_name string
---@param callback fun(result: { status: string, highlight: { symbol: string, hl_group: string } } | nil)
function M.get_status(buf_id, file_name, callback)
  local cwd = vim.fs.root(buf_id, '.git')
  if not cwd then
    callback(nil)
    return
  end

  local cache_entry = git_status_cache[cwd]
  local currentTime = os.time()

  local process_status_map = vim.schedule_wrap(function()
    local escaped_cwd = escapePattern(cwd)
    local parent_dir = require('oil').get_current_dir(buf_id) or ''
    local entry_path = parent_dir .. file_name
    local relative_path = entry_path:gsub('^' .. escaped_cwd .. '/', '')

    local status = cache_entry.status_map[relative_path]
    local highlight = status and map_status(status) or nil
    callback(status and { status = status, highlight = highlight } or nil)
  end)

  if
    not cache_entry or currentTime - git_status_cache[cwd].time < cacheTimeout
  then
    update_git_status(cwd, function(status_map)
      if status_map then
        cache_entry = {
          time = currentTime,
          status_map = status_map,
        }
        git_status_cache[cwd] = cache_entry
      end
      process_status_map()
    end)
  else
    process_status_map()
  end
end

---@return nil
function M.clearCache() git_status_cache = {} end

function M.setup()
  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = { 'OilEnter' },
    callback = function(args)
      local oil = require('oil')
      local buf_id = args.data.buf

      --- Cancel if git is not used
      if not vim.fs.root(buf_id, '.git') then
        return
      end

      local highlight_default = { symbol = '  ', hl_group = 'NonText' }
      local highlights = {}
      local update_is_running = false

      local function render()
        local nlines = vim.api.nvim_buf_line_count(buf_id)
        vim.api.nvim_buf_clear_namespace(buf_id, ns_id, 0, -1)
        for line = 0, nlines do
          local highlight = highlights[line + 2] or highlight_default
          vim.api.nvim_buf_set_extmark(buf_id, ns_id, line, 0, {
            virt_text = { { highlight.symbol, highlight.hl_group } },
            virt_text_pos = 'inline',
          })
        end
      end

      local function update()
        if update_is_running then
          return
        end
        update_is_running = true
        local nlines = vim.api.nvim_buf_line_count(buf_id)

        -- Fast prerender
        render()

        -- Do the (slow) update
        highlights = {}
        local pending = nlines
        local set_highlight = function(line, highlight)
          highlights[line + 1] = highlight or highlight_default
          pending = pending - 1
          if pending == 0 then
            render()
            update_is_running = false
          end
        end
        for line = 0, nlines do
          local entry = oil.get_entry_on_line(buf_id, line)
          if entry then
            M.get_status(buf_id, entry.name, function(status)
              local highlight = status and status.highlight or highlight_default
              set_highlight(line, highlight)
            end)
          else
            set_highlight(line, highlight_default)
          end
        end
      end

      update()
      vim.api.nvim_create_autocmd({
        'TextChanged',
        'InsertLeave',
      }, {
        buffer = buf_id,
        callback = update,
      })
    end,
  })
end

return M
