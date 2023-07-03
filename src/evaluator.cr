require "./lisp_value"

module Cryslisp
  class Evaluator
    def initialize
      # Initialize any necessary state or environment here
    end

    # Whats wrong here?
    
    def eval(expr : LispValue) : LispValue
      case expr
      when LispList
        if expr.empty?
          LispNil.new
        else
          operator = eval(expr.first)
          operands = expr.rest.map { |operand| eval(operand) }
          apply_operator(operator, operands)
        end
      when LispSymbol
        # Look up symbol value in an environment or return as is
        expr
      else
        expr
      end
    end

    private def eval_list(list : LispList) : LispValue
      case list.elements.first
      when LispSymbol.new("+")
        eval_addition(list.elements)
      when LispSymbol.new("-")
        eval_subtraction(list.elements)
      when LispSymbol.new("*")
        eval_multiplication(list.elements)
      when LispSymbol.new("/")
        eval_division(list.elements)
      else
        raise "Unknown function: #{list.elements.first}"
      end
    end

    private def eval_addition(args : Array(LispValue) | LispList) : LispValue
      args = args.elements.to_a if args.is_a?(LispList)

      return LispNumber.new(0) if args.empty?

      result = args[0]

      args[1..-1].each do |arg|
        if result.is_a?(LispNumber) && arg.is_a?(LispNumber)
          result = LispNumber.new(result.value + arg.value)
        elsif result.is_a?(LispSymbol) || arg.is_a?(LispSymbol)
          # Handle addition involving LispSymbols separately
          return LispSymbol.new(result.to_s + arg.to_s)
        else
          raise "Invalid arguments for addition: #{result.inspect} and #{arg.inspect}"
        end
      end

      result
    end

    private def eval_subtraction(args : Array(LispValue)) : LispValue
      raise "Invalid number of arguments for subtraction" if args.size < 2
    
      result = eval(args[0])
    
      args[1..-1].each do |arg|
        evaluated_arg = eval(arg)
    
        unless result.is_a?(LispNumber) && evaluated_arg.is_a?(LispNumber)
          raise "Invalid arguments for subtraction: #{result.inspect} and #{evaluated_arg.inspect}"
        end
    
        result = LispNumber.new(result.value - evaluated_arg.value)
      end
    
      result
    end     

    private def eval_multiplication(args : LispList) : LispValue
      result = 1

      args.elements.each do |arg|
        evaluated_arg = eval(arg)
        if evaluated_arg.is_a?(LispNumber)
          result *= evaluated_arg.value
        elsif evaluated_arg.is_a?(LispNil)
          return LispNil.new
        else
          raise "Invalid argument for multiplication: #{arg.inspect}"
        end
      end

      LispNumber.new(result)
    end  

    private def eval_division(args : Array(LispValue)) : LispValue
      raise "Invalid number of arguments for division" if args.size < 2
    
      result = eval(args[0])
    
      args[1..-1].each do |arg|
        evaluated_arg = eval(arg)
    
        unless result.is_a?(LispNumber) && evaluated_arg.is_a?(LispNumber)
          raise "Invalid arguments for division: #{result.inspect} and #{evaluated_arg.inspect}"
        end
    
        result = LispNumber.new((result.value / evaluated_arg.value).to_i)
      end
    
      result
    end         

    private def apply_operator(operator : LispValue, operands : LispList) : LispValue
      case operator
      when LispSymbol
        operator_str = operator.name
      else
        raise "Invalid operator: #{operator.inspect}"
      end

      case operator_str
      when "+"
        eval_addition(operands)
      when "-"
        eval_subtraction(operands.elements)
      when "*"
        eval_multiplication(operands)
      when "/"
        eval_division(operands.elements.to_a)
      else
        raise "Unknown operator: #{operator_str}"
      end
    end
  end
end
