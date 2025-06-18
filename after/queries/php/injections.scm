;; extends

(encapsed_string
  (string_content) @injection.content
  (#match? @injection.content "^\\W*(SELECT|INSERT|UPDATE|DELETE|CEATE|ALTER)")
  (#set! injection.language "sql"))
