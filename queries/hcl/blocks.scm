(
  (attribute (
    (identifier) @attribute
  )) @root (#set! "type" "attribute")
)

(
  (block (
    (identifier) @type
    (string_lit (template_literal) @resource)
    (string_lit (template_literal) @name)
    (block_start)
  )) @root (#set! "type" "resource")
)

(
  (block (
    (identifier) @type
    (string_lit (template_literal) @resource)
    (block_start)
  )) @root (#set! "type" "variable")
)

(
  (block (
    (identifier) @type
    (block_start)
  )) @root (#set! "type" "block")
)
