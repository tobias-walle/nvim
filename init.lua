function dbg(arg)
  print(vim.inspect(arg))
  return arg
end

require 'user.plugins'

require 'user.bindings'
require 'user.general'

require 'user.make'
require 'user.telescope'
require 'user.completion'
require 'user.explorer'
require 'user.other'
require 'user.style'
require 'user.vim-test'
require 'user.projects'
