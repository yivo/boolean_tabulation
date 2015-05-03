module Resources
  PRIMITIVE_OPERATIONS  = %w{ && || }
  COMPLEX_OPERATIONS    = %w{ + | |> -> <> <-> }
  UNARY_OPERATIONS      = %w{ ! }
  BINARY_OPERATIONS     = [PRIMITIVE_OPERATIONS, COMPLEX_OPERATIONS].flatten

  SIMPLIFICATION_FORMULAS = {
      '+'   => '(\1 && !\2) || (!\1 && \2)',  # Сложение по модулю два
      '|>'  => '!\1 && !\2',                  # Стрелка Пирса
      '|'   => '!\1 || !\2',                  # Штрих Шеффера
      '->'  => '!\1 || \2',                   # Импликация
      '<>'  => '(\1 && \2) || (!\1 && !\2)'   # Эквивалентность
  }

  SIMPLIFICATION_FORMULAS['<->'] = SIMPLIFICATION_FORMULAS['<>']

  R_OPERAND         = /\w+/i
  R_OPERATION       = Regexp.new BINARY_OPERATIONS.map{ |op| "(#{Regexp.quote(op)})" }.join '|'
  R_UNARY_OPERATION = Regexp.new UNARY_OPERATIONS.map { |op| Regexp.quote(op) }.join '|'

  R_EXPRESSION = %r{
    (?<operation>
      #{R_OPERATION.source}
    ){0}

    (?<unary_operation> #{R_UNARY_OPERATION.source} ){0}

    (?<expression>
      (\g<operand> \g<operation>)+ \g<operand>
    ){0}

    (?<operand>
      \g<unary_operation>? (?> \g<group> | #{R_OPERAND.source})
    ){0}

    (?<group>
      (?> \(\g<expression>\) | \(\g<operand>\) )
    ){0}

    (?<content>
      (?> \g<group> | \g<expression> | \g<operand>)
    )
  }xi

  R_LEADING_EXPRESSION    = Regexp.new "\\A#{R_EXPRESSION.source}", R_EXPRESSION.options
  R_TRAILING_EXPRESSION   = Regexp.new "#{R_EXPRESSION.source}\\Z", R_EXPRESSION.options

  R_OPERATION_LEFT_BOUNDARY = %r{
    #{R_OPERAND.source} | \)
  }xi

  R_OPERATION_RIGHT_BOUNDARY = %r{
    #{R_UNARY_OPERATION.source} | \( | #{R_OPERAND.source}
  }xi
end