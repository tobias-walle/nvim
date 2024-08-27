---@type LazySpec
local plugin = {
  'ThePrimeagen/harpoon',
  event = 'VeryLazy',
  config = function()
    require('which-key').add({
      { '<leader>h', group = 'Harpoon' },
      {
        '<leader>hh',
        function() require('harpoon.mark').add_file() end,
        desc = 'Add file',
      },
      {
        '<leader>hm',
        function() require('harpoon.ui').toggle_quick_menu() end,
        desc = 'Quick Menu',
      },
      -- Navigation
      {
        '<Leader>ha',
        function() require('harpoon.ui').nav_file(1) end,
        desc = 'Go to File 1',
      },
      {
        '<Leader>hs',
        function() require('harpoon.ui').nav_file(2) end,
        desc = 'Go to File 2',
      },
      {
        '<Leader>hd',
        function() require('harpoon.ui').nav_file(3) end,
        desc = 'Go to File 3',
      },
      {
        '<Leader>hf',
        function() require('harpoon.ui').nav_file(4) end,
        desc = 'Go to File 4',
      },
    })
  end,
}

return plugin
