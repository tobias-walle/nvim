local db = require('dashboard')
db.session_directory = 'sessions'
db.session_auto_save_on_exit = true
db.custom_center = {
  {
    icon = '  ',
    desc = 'Recently latest session                  ',
    shortcut = 'SPC s l',
    action = 'SessionLoad',
  },
  {
    icon = '  ',
    desc = 'Recently opened files                   ',
    action = 'DashboardFindHistory',
    shortcut = 'SPC f h',
  },
}
