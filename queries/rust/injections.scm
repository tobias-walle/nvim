; Inject html into the view macro used by leptos in rust
(
  (macro_invocation
    macro: ((identifier) @_html_def)
    (token_tree) @html)

    (#eq? @_html_def "view")
)
