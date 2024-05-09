---@type LazySpec
local plugin = {
  -- Shows outline of source code
  'https://github.com/stevearc/profile.nvim',
  event = 'VeryLazy',
  config = function()
    local should_profile = os.getenv('NVIM_PROFILE')
    if should_profile then
      require('profile').instrument_autocmds()
      if should_profile:lower():match('^start') then
        require('profile').start('*')
      else
        require('profile').instrument('*')
      end
    end

    local function toggle_profiler()
      local prof = require('profile')
      if prof.is_recording() then
        prof.stop()
        vim.ui.input({
          prompt = 'Save profile to:',
          completion = 'file',
          default = 'profile.json',
        }, function(filename)
          if filename then
            prof.export(filename)
            vim.notify(string.format('Wrote %s', filename))
          end
        end)
      else
        prof.start('*')
        print('Profiling started...')
      end
    end
    local map = require('user.utils.keymaps').map
    map('n', '<leader>P', toggle_profiler, 'Toggle profiler')
  end,
}

return plugin
