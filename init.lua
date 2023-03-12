if require('user.bootstrap') then
  return
end

require('impatient')

require('user.plugins')
require('user.utils')

require('user.bindings')
require('user.general')

require('user.git')
require('user.make')
require('user.mini')
require('user.telescope')
require('user.completion')
require('user.lsp')
require('user.explorer')
require('user.other')
require('user.autopairs')
require('user.treesitter')
require('user.style')
require('user.test')
require('user.luasnip')
require('user.dashboard')
