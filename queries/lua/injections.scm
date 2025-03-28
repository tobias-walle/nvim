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

; Inject language from comments, like this:
; --[[ markdown ]] '...'
; --[[ python ]] [[...]]
(
  (comment
    content: (comment_content) @injection.language
    (#offset! @injection.language 0 1 0 -1)
  )
  (expression_list
    value:
      (string content: (string_content) @injection.content))
)

(
  (comment
    content: (comment_content) @injection.language
    (#offset! @injection.language 0 1 0 -1)
  )
  (string content: (string_content) @injection.content)
)
