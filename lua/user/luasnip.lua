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

-- React
ls.add_snippets('typescriptreact', {
  s(
    'rcomp',
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
    'rcompp',
    fmt(
      [[
import React from "react";

export interface {props} {{
  {props_content}
}}

export const {name}: React.FC<{props}> = ({{{props_destructure}}}) => {{
  return (
    <div>{content}</div>
  );
}}
  ]],
      {
        name = d(1, get_cased_file_name_node(casing.pascalCase)),
        props_content = i(2),
        props_destructure = i(3),
        content = i(0, 'Hello World'),
        props = f(function(args)
          return args[1][1] .. 'Props'
        end, { 1 }),
      }
    )
  ),

  s(
    'rstate',
    fmt(
      [[
const [{name}, {setter}] = useState({default});
  ]],
      {
        name = i(1),
        setter = f(function(args)
          return 'set' .. casing.pascalCase(casing.splitLowerCase(args[1][1]))
        end, { 1 }),
        default = i(2),
      }
    )
  ),
})

-- SolidJs
ls.add_snippets('typescriptreact', {
  s(
    'scomp',
    fmt(
      [[
export const {name}: Component = () => {{
  return (
    <div>{content}</div>
  );
}}
  ]],
      { name = d(1, get_cased_file_name_node(casing.pascalCase)), content = i(0, 'Hello World') }
    )
  ),

  s(
    'scompp',
    fmt(
      [[
export interface {props} {{
  {props_content}
}}

export const {name}: Component<{props}> = (props) => {{
  return (
    <div>{content}</div>
  );
}}
  ]],
      {
        name = d(1, get_cased_file_name_node(casing.pascalCase)),
        props_content = i(2),
        content = i(0, 'Hello World'),
        props = f(function(args)
          return args[1][1] .. 'Props'
        end, { 1 }),
      }
    )
  ),
})
