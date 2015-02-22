class Simplificator

  attr_reader :helper

  def initialize
    @helper = Helper.new
  end

  def simplify_all(func)
    Resources::COMPLEX_OPERATIONS.each do |operation|
      func = simplify_operation func, operation
    end
    func
  end

  def simplify_operation(func, op)
    formula = formula_for_operation! op
    remove_whitespace! func

    while op_index = helper.operation_index(func, op)
      op_length = op.length

      left_part   = func[0...op_index]
      right_part  = func[op_index + op_length..-1]

      left_expr   = helper.trailing_expression left_part
      right_expr  = helper.leading_expression right_part
      new_expr    = build_expression formula.clone, left_expr, right_expr

      debug_iteration func, op, op_index, left_part, left_expr, right_part, right_expr, new_expr

      func = func[0...op_index - left_expr.length] +
          wrap_in_parentheses(new_expr) +
          func[op_index + right_expr.length + op_length..-1]
    end
    func
  end

  def formula_for_operation!(operation)
    formula = Resources::SIMPLIFICATION_FORMULAS[operation]
    raise "No formula found for '#{operation}'" unless formula
    formula
  end

  def wrap_in_parentheses(expr)
    helper.wrap_in_parentheses expr
  end

  def remove_whitespace(expr)
    expr.gsub /\s+/, ''
  end

  def remove_whitespace!(expr)
    expr.gsub! /\s+/, ''
  end

  protected

  def build_expression(formula, left, right)
    new_expr = formula
    new_expr.gsub! '\1', wrap_in_parentheses(left)
    new_expr.gsub! '\2', wrap_in_parentheses(right)
    remove_whitespace! new_expr
    new_expr
  end

  private

  def debug_iteration(func, op, op_index, left_part, left_expr, right_part, right_expr, new_expr)
    print %Q{
      Operation:        #{op}
      Operation index:  #{op_index}
      Around operation: #{func[op_index - 2..op_index + 2]}
      Function:         #{func}
      Left part:        #{left_part}
      Left expression:  #{left_expr}
      Right part:       #{right_part}
      Right expression: #{right_expr}
      New expression:   #{new_expr}
    }
  end

end