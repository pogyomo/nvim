;; extends

(assignment_expression
  left: (variable_name
          (name) @_id
          (#match? @_id "sql|query"))
  right: (encapsed_string
           (string_content) @injection.content
           (#set! injection.language "sql")))
