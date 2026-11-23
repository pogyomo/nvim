; extends

((function_definition) @indent.begin
  (#set! indent.immediate 1))
((if_statement) @indent.begin
  (#set! indent.immediate 1))
((while_statement) @indent.begin
  (#set! indent.immediate 1))
((for_statement) @indent.begin
  (#set! indent.immediate 1))
((pattern_section) @indent.begin
  (#set! indent.immediate 1))
((lambda) @indent.begin
  (#set! indent.immediate 1))

((parameters) @indent.align
  (#set! indent.open_delimiter "(")
  (#set! indent.close_delimiter ")"))
((arguments) @indent.align
  (#set! indent.open_delimiter "(")
  (#set! indent.close_delimiter ")"))
((dictionary) @indent.align
  (#set! indent.open_delimiter "{")
  (#set! indent.close_delimiter "}"))
((array) @indent.align
  (#set! indent.open_delimiter "[")
  (#set! indent.close_delimiter "]"))
[
  ")"
  "}"
  "]"
] @indent.branch
