---@type LazySpec
local plugin = {
  'L3MON4D3/LuaSnip',
  event = 'VeryLazy',
  config = function()
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
      return function() return sn(nil, i(1, get_cased_file_name(case))) end
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
          {
            name = d(1, get_cased_file_name_node(casing.pascalCase)),
            content = i(0, 'Hello World'),
          }
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
            props = f(function(args) return args[1][1] .. 'Props' end, { 1 }),
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
            setter = f(
              function(args)
                return 'set'
                  .. casing.pascalCase(casing.splitLowerCase(args[1][1]))
              end,
              { 1 }
            ),
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
import {{ Component }} from "solid-js";

export const {name}: Component = () => {{
  return (
    <div>{content}</div>
  );
}}
          ]],
          {
            name = d(1, get_cased_file_name_node(casing.pascalCase)),
            content = i(0, 'Hello World'),
          }
        )
      ),

      s(
        'spcomp',
        fmt(
          [[
import {{ ParentComponent }} from "solid-js";

export const {name}: ParentComponent = () => {{
  return (
    <div>{content}</div>
  );
}}
          ]],
          {
            name = d(1, get_cased_file_name_node(casing.pascalCase)),
            content = i(0, 'Hello World'),
          }
        )
      ),

      s(
        'scompp',
        fmt(
          [[
import {{ Component }} from "solid-js";

type Props = {{
  {props_content}
}}

export const {name}: Component<Props> = (props) => {{
  return (
    <div>{content}</div>
  );
}}
          ]],
          {
            name = d(1, get_cased_file_name_node(casing.pascalCase)),
            props_content = i(2),
            content = i(0, 'Hello World'),
          }
        )
      ),

      s(
        'spcompp',
        fmt(
          [[
import {{ ParentComponent }} from "solid-js";

type Props = {{
  {props_content}
}}

export const {name}: ParentComponent<Props> = (props) => {{
  return (
    <div>{content}</div>
  );
}}
          ]],
          {
            name = d(1, get_cased_file_name_node(casing.pascalCase)),
            props_content = i(2),
            content = i(0, 'Hello World'),
          }
        )
      ),

      s(
        'createStyles',
        fmt(
          [[
const styles = createStyles({{
  {name}: () =>
    css({{
      {class}
    }}),
}});
          ]],
          {
            name = i(1, 'wrapper'),
            class = i(0),
          }
        )
      ),
    })
  end,
}

return plugin
