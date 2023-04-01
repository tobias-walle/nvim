---@type LazySpec
local plugin = {
  'ThePrimeagen/harpoon',
  event = 'VeryLazy',
  config = function()
    require('which-key').register({
      ['<leader>h'] = {
        name = 'Harpoon',
        h = {
          function()
            require('harpoon.mark').add_file()
          end,
          'Add file',
        },
        m = {
          function()
            require('harpoon.ui').toggle_quick_menu()
          end,
          'Quick Menu',
        },
      },
      -- Navigation
      ['<M-a>'] = {
        function()
          require('harpoon.ui').nav_file(1)
        end,
        'Go to File 1',
      },
      ['<M-s>'] = {
        function()
          require('harpoon.ui').nav_file(2)
        end,
        'Go to File 2',
      },
      ['<M-d>'] = {
        function()
          require('harpoon.ui').nav_file(3)
        end,
        'Go to File 3',
      },
      ['<M-f>'] = {
        function()
          require('harpoon.ui').nav_file(4)
        end,
        'Go to File 4',
      },
    })
  end,
}

return plugin
