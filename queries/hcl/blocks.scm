; just an attribute
(
  (attribute (
    (identifier) @attribute
  )) @root (#set! "type" "attribute")
)

; "resource" and "data" block
(
  (block (
    (identifier) @type
    (string_lit (template_literal) @resource)
    (string_lit (template_literal) @name)
    (block_start)
  )) @root (#set! "type" "resource")
)

; variable and output block
(
  (block (
    (identifier) @type
    (string_lit (template_literal) @resource)
    (block_start)
  )) @root (#set! "type" "variable")
)

; local block
(
  (block (
    (identifier) @type
    (block_start)
  )) @root (#set! "type" "block")
)

; variable
(
  (expression (variable_expr)) @root (#set! "type" "variable_expr")
)
