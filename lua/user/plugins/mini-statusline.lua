---@type LazySpec
local plugin = {
  'echasnovski/mini.statusline',
  lazy = false,
  config = function()
    local function render()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git = MiniStatusline.section_git({ trunc_width = 75 })
      local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      local location = MiniStatusline.section_location({ trunc_width = 75 })
      local recording = vim.fn.reg_recording()
      if recording ~= '' then
        recording = '@recording ' .. recording
      end

      return MiniStatusline.combine_groups({
        { hl = 'MiniStatuslineRecording', strings = { recording } },
        { hl = mode_hl, strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diagnostics } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl, strings = { location } },
      })
    end
    require('mini.statusline').setup({
      content = {
        active = render,
      },
    })
  end,
}

return plugin
