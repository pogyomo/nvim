;; extends

((string_content) @injection.content
                  (#lua-match? @injection.content "^%s*SELECT")
                  (#set! injection.language "sql"))

((string_content) @injection.content
                  (#lua-match? @injection.content "^%s*INSERT")
                  (#set! injection.language "sql"))

((string_content) @injection.content
                  (#lua-match? @injection.content "^%s*UPDATE")
                  (#set! injection.language "sql"))

((string_content) @injection.content
                  (#lua-match? @injection.content "^%s*DELETE")
                  (#set! injection.language "sql"))

((string_content) @injection.content
                  (#lua-match? @injection.content "^%s*CREATE")
                  (#set! injection.language "sql"))

((string_content) @injection.content
                  (#lua-match? @injection.content "^%s*ALTER")
                  (#set! injection.language "sql"))
