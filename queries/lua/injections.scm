; extends
; Inject lua calls for Minitest
(
  (function_call
    name: (dot_index_expression
      table: (identifier) @function
      field: (identifier) @name)
    arguments: (arguments (string content: (string_content) @injection.content))
  )

  (#match? @name "^lua(_.*)?$")
  (#set! injection.language "lua")
)

(
  (function_call
    name: (identifier) @name
    arguments: (arguments (string content: (string_content) @injection.content))
  )

  (#match? @name "^lua(_.*)?$")
  (#set! injection.language "lua")
)
