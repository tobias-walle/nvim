local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local fmt = require('luasnip.extras.fmt').fmt

local casing = require('user.utils.casing')

local function get_cased_file_name(case)
  local name = vim.fn.expand('%:t:r')
  if name == nil then
    return 'ComponentName'
  end
  return case(casing.splitLowerCase(name))
end

local function get_cased_file_name_node(case)
  return function()
    return sn(nil, i(1, get_cased_file_name(case)))
  end
end

ls.add_snippets('typescript', {
  s(
    'fun',
    fmt(
      [[
    function {name}({arguments}): {return_type} {{
      {end_pos}
    }}
  ]],
      {
        name = d(1, get_cased_file_name_node(casing.camelCase)),
        arguments = i(2),
        return_type = i(3, 'void'),
        end_pos = i(0),
      }
    )
  ),
  s(
    'efun',
    fmt(
      [[
    export function {name}({arguments}): {return_type} {{
      {end_pos}
    }}
  ]],
      {
        name = d(1, get_cased_file_name_node(casing.camelCase)),
        arguments = i(2),
        return_type = i(3, 'void'),
        end_pos = i(0),
      }
    )
  ),
})

ls.filetype_extend('typescriptreact', { 'typescript' })
ls.add_snippets('typescriptreact', {
  s(
    'comp',
    fmt(
      [[
    import React from "react";

    export const {name}: React.FC = () => {{
      return (
        <div>{content}</div>
      );
    }}
  ]],
      { name = d(1, get_cased_file_name_node(casing.pascalCase)), content = i(0, 'Hello World') }
    )
  ),

  s(
    'compp',
    fmt(
      [[
    import React from "react";

    export interface {props} {{
    }}

    export const {name}: React.FC<{props}> = () => {{
      return (
        <div>{content}</div>
      );
    }}
  ]],
      {
        name = d(1, get_cased_file_name_node(casing.pascalCase)),
        content = i(0, 'Hello World'),
        props = f(function(args)
          return args[1][1] .. 'Props'
        end, { 1 }),
      }
    )
  ),
})
