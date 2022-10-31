function dbg(arg)
  print(vim.inspect(arg))
  return arg
end

require('user.plugins')

require('user.bindings')
require('user.general')

require('user.git')
require('user.make')
require('user.telescope')
require('user.completion')
require('user.explorer')
require('user.other')
require('user.style')
require('user.test')
require('user.luasnip')
require('user.dashboard')
