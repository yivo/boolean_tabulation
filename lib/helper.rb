class Helper

  def trailing_expression(func)
    func[Resources::R_TRAILING_EXPRESSION]
  end

  def leading_expression(func)
    func[Resources::R_LEADING_EXPRESSION]
  end

  def operation_index(func, operation)
    regex = %r{
      (?:#{Resources::R_OPERATION_LEFT_BOUNDARY.source})
      (#{Regexp.quote(operation)})
      (?:#{Resources::R_OPERATION_RIGHT_BOUNDARY.source})
    }xi
    match = func.match regex
    match.begin(1) if match
  end

  def wrap_in_parentheses(expr)
    operand?(expr) || in_parentheses?(expr) ? expr : "(#{expr})"
  end

  def operand?(str)
    str =~ /\A\w+\Z/
  end

  def in_parentheses?(expr)
    expr =~ /\A\(/ && expr =~ /\)\Z/
  end

  def function_variables(func)
    func.scan(Resources::R_OPERAND).uniq.sort
  end

end